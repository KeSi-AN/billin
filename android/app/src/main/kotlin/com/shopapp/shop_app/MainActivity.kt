package com.shopapp.shop_app

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var printer: BluetoothPrinterChannel? = null
    private var contacts: ContactPickerChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        printer = BluetoothPrinterChannel(applicationContext, messenger)
        contacts = ContactPickerChannel(this, messenger)
    }

    @Deprecated("Needed for the system contact picker result")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (contacts?.onActivityResult(requestCode, resultCode, data) == true) return
        @Suppress("DEPRECATION")
        super.onActivityResult(requestCode, resultCode, data)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        printer?.dispose()
        contacts?.dispose()
        printer = null
        contacts = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
