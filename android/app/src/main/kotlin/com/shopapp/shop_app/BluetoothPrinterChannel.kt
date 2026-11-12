package com.shopapp.shop_app

import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothClass
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothSocket
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.util.UUID
import java.util.concurrent.Executors

/**
 * Classic Bluetooth (SPP / RFCOMM) link to a paired thermal printer.
 *
 * Most low-cost 58mm/80mm receipt printers only speak classic Bluetooth, which
 * BLE libraries can't reach, so this talks to Android's Bluetooth API directly.
 * All blocking socket work runs on one background thread, in order.
 */
@SuppressLint("MissingPermission") // Dart requests BLUETOOTH_CONNECT first.
class BluetoothPrinterChannel(
    private val context: Context,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler {

    private val channel = MethodChannel(messenger, "shop_app/bt_printer")
    private val io = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())
    private var socket: BluetoothSocket? = null
    private var connectedAddress: String? = null

    init {
        channel.setMethodCallHandler(this)
    }

    private val adapter: BluetoothAdapter?
        get() = (context.getSystemService(Context.BLUETOOTH_SERVICE) as? BluetoothManager)?.adapter

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "state" -> result.success(
                when {
                    adapter == null -> "unsupported"
                    adapter?.isEnabled != true -> "off"
                    else -> "on"
                }
            )
            "bondedDevices" -> result.success(bondedDevices())
            "connect" -> background(result) { connect(call.argument<String>("address")!!) }
            "write" -> background(result) { write(call.argument<ByteArray>("bytes")!!) }
            "disconnect" -> background(result) { disconnect() }
            "isConnected" -> result.success(socket?.isConnected == true)
            "openSettings" -> {
                val intent = Intent(Settings.ACTION_BLUETOOTH_SETTINGS)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(intent)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun bondedDevices(): List<Map<String, Any?>> =
        adapter?.bondedDevices.orEmpty().map { device ->
            mapOf(
                "name" to (device.name ?: device.address),
                "address" to device.address,
                // Printers usually report the "imaging" device class.
                "looksLikePrinter" to (device.bluetoothClass?.majorDeviceClass ==
                    BluetoothClass.Device.Major.IMAGING),
            )
        }

    private fun connect(address: String): Any? {
        if (socket?.isConnected == true && connectedAddress == address) return null
        disconnect()
        val bt = adapter ?: throw IOException("Bluetooth not available")
        if (!bt.isEnabled) throw IOException("Bluetooth is off")
        val device = bt.getRemoteDevice(address)
        bt.cancelDiscovery()
        socket = openSocket(device)
        connectedAddress = address
        return null
    }

    /** Standard SPP first, then the fallbacks some cheap printers need. */
    private fun openSocket(device: BluetoothDevice): BluetoothSocket {
        val attempts = listOf<() -> BluetoothSocket>(
            { device.createRfcommSocketToServiceRecord(SPP_UUID) },
            { device.createInsecureRfcommSocketToServiceRecord(SPP_UUID) },
            {
                device.javaClass
                    .getMethod("createRfcommSocket", Int::class.javaPrimitiveType)
                    .invoke(device, 1) as BluetoothSocket
            },
        )
        var last: Exception? = null
        for (attempt in attempts) {
            val s = try { attempt() } catch (e: Exception) { last = e; continue }
            try {
                s.connect()
                return s
            } catch (e: IOException) {
                last = e
                try { s.close() } catch (_: IOException) {}
            }
        }
        throw IOException("Couldn't connect to printer: ${last?.message}", last)
    }

    private fun write(bytes: ByteArray): Any? {
        val out = socket?.takeIf { it.isConnected }?.outputStream
            ?: throw IOException("Printer not connected")
        // Small chunks with a short pause: cheap printers have tiny buffers.
        var offset = 0
        while (offset < bytes.size) {
            val end = minOf(offset + CHUNK, bytes.size)
            out.write(bytes, offset, end - offset)
            out.flush()
            offset = end
            Thread.sleep(15)
        }
        return null
    }

    private fun disconnect(): Any? {
        try { socket?.close() } catch (_: IOException) {}
        socket = null
        connectedAddress = null
        return null
    }

    private fun background(result: MethodChannel.Result, work: () -> Any?) {
        io.execute {
            try {
                val value = work()
                main.post { result.success(value) }
            } catch (e: Exception) {
                main.post { result.error("PRINTER", e.message ?: e.toString(), null) }
            }
        }
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        io.execute { disconnect() }
        io.shutdown()
    }

    companion object {
        private val SPP_UUID: UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")
        private const val CHUNK = 512
    }
}
