package com.shopapp.shop_app

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.core.content.FileProvider
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * Opens WhatsApp with a bill PDF attached, straight to the customer's chat
 * when we have their number (the widely used "jid" extra), otherwise to
 * WhatsApp's own chat picker. WhatsApp Business is preferred when both are
 * installed, since that's the shop's number.
 */
class WhatsAppChannel(
    private val context: Context,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler {

    private val channel = MethodChannel(messenger, "shop_app/whatsapp")

    init {
        channel.setMethodCallHandler(this)
    }

    private fun installed(pkg: String): Boolean = try {
        context.packageManager.getPackageInfo(pkg, 0)
        true
    } catch (e: PackageManager.NameNotFoundException) {
        false
    }

    private val whatsApp: String?
        get() = listOf("com.whatsapp.w4b", "com.whatsapp").firstOrNull(::installed)

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "available" -> result.success(whatsApp != null)
            "sendFile" -> {
                val pkg = whatsApp ?: return result.error("NO_WHATSAPP", "WhatsApp is not installed", null)
                val file = File(call.argument<String>("path")!!)
                val phone = call.argument<String>("phone")
                val text = call.argument<String>("text")
                val uri = FileProvider.getUriForFile(
                    context,
                    "${context.packageName}.shopfiles",
                    file,
                )
                val intent = Intent(Intent.ACTION_SEND).apply {
                    type = "application/pdf"
                    setPackage(pkg)
                    putExtra(Intent.EXTRA_STREAM, uri)
                    if (text != null) putExtra(Intent.EXTRA_TEXT, text)
                    // Indian mobile: 91 + 10 digits.
                    if (phone != null) putExtra("jid", "91$phone@s.whatsapp.net")
                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                try {
                    context.startActivity(intent)
                    result.success(null)
                } catch (e: ActivityNotFoundException) {
                    result.error("NO_WHATSAPP", e.message, null)
                }
            }
            else -> result.notImplemented()
        }
    }

    fun dispose() = channel.setMethodCallHandler(null)
}
