package com.shopapp.shop_app

import android.content.ContentUris
import android.content.ContentValues
import android.content.Context
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * Saves backup files to the phone's Downloads/ShopBackups folder, where they
 * survive the app being uninstalled and can be found in the Files app.
 * Keeps the newest [KEEP]; older backups this app saved there are removed.
 * Android 10+ only (older phones would need a storage permission).
 */
class DownloadsChannel(
    private val context: Context,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler {

    private val channel = MethodChannel(messenger, "shop_app/downloads")

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "saveBackup" -> {
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
                    result.success(false)
                    return
                }
                try {
                    save(File(call.argument<String>("path")!!))
                    prune()
                    result.success(true)
                } catch (e: Exception) {
                    result.error("DOWNLOADS", e.message, null)
                }
            }
            else -> result.notImplemented()
        }
    }

    private val folder = "${Environment.DIRECTORY_DOWNLOADS}/ShopBackups/"

    private fun save(file: File) {
        val resolver = context.contentResolver
        val values = ContentValues().apply {
            put(MediaStore.Downloads.DISPLAY_NAME, file.name)
            put(MediaStore.Downloads.MIME_TYPE, "application/zip")
            put(MediaStore.Downloads.RELATIVE_PATH, folder)
            put(MediaStore.Downloads.IS_PENDING, 1)
        }
        val collection = MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
        val uri = resolver.insert(collection, values) ?: error("Couldn't create the file")
        resolver.openOutputStream(uri).use { out ->
            file.inputStream().use { it.copyTo(out!!) }
        }
        values.clear()
        values.put(MediaStore.Downloads.IS_PENDING, 0)
        resolver.update(uri, values, null, null)
    }

    /** Deletes this app's older backups in the folder, keeping [KEEP]. */
    private fun prune() {
        val resolver = context.contentResolver
        val collection = MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
        val ids = mutableListOf<Long>()
        resolver.query(
            collection,
            arrayOf(MediaStore.Downloads._ID),
            "${MediaStore.Downloads.RELATIVE_PATH} = ? AND ${MediaStore.Downloads.DISPLAY_NAME} LIKE ?",
            arrayOf(folder, "ShopBackup_%"),
            "${MediaStore.Downloads.DISPLAY_NAME} DESC",
        )?.use { c ->
            while (c.moveToNext()) ids += c.getLong(0)
        }
        for (id in ids.drop(KEEP)) {
            try {
                resolver.delete(ContentUris.withAppendedId(collection, id), null, null)
            } catch (e: Exception) {
                // Not ours (e.g. from before a reinstall): leave it.
            }
        }
    }

    fun dispose() = channel.setMethodCallHandler(null)

    companion object {
        private const val KEEP = 14
    }
}
