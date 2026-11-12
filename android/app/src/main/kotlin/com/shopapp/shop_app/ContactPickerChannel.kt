package com.shopapp.shop_app

import android.app.Activity
import android.content.Intent
import android.provider.ContactsContract
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Opens Android's own contact picker (phone numbers). The system grants the
 * app access to just the chosen contact, so no READ_CONTACTS permission.
 */
class ContactPickerChannel(
    private val activity: Activity,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler {

    private val channel = MethodChannel(messenger, "shop_app/contacts")
    private var pending: MethodChannel.Result? = null

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method != "pick") {
            result.notImplemented()
            return
        }
        if (pending != null) {
            result.error("BUSY", "Picker already open", null)
            return
        }
        pending = result
        val intent = Intent(Intent.ACTION_PICK, ContactsContract.CommonDataKinds.Phone.CONTENT_URI)
        try {
            activity.startActivityForResult(intent, REQUEST)
        } catch (e: Exception) {
            pending = null
            result.error("UNAVAILABLE", e.message, null)
        }
    }

    /** Returns true if the result was ours. */
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST) return false
        val result = pending ?: return true
        pending = null
        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null) {
            result.success(null)
            return true
        }
        val projection = arrayOf(
            ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME,
            ContactsContract.CommonDataKinds.Phone.NUMBER,
        )
        try {
            activity.contentResolver.query(uri, projection, null, null, null)?.use { c ->
                if (c.moveToFirst()) {
                    result.success(mapOf("name" to (c.getString(0) ?: ""), "phone" to (c.getString(1) ?: "")))
                    return true
                }
            }
            result.success(null)
        } catch (e: Exception) {
            result.error("READ_FAILED", e.message, null)
        }
        return true
    }

    fun dispose() = channel.setMethodCallHandler(null)

    companion object {
        private const val REQUEST = 4711
    }
}
