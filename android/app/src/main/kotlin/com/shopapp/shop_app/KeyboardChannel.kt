package com.shopapp.shop_app

import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.provider.Settings
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * A Bluetooth barcode scanner is a keyboard to Android. While one is
 * connected, Android hides the on-screen keyboard unless "Use on-screen
 * keyboard" is on, so the shopkeeper can't type names or numbers. This tells
 * the app when that is happening and opens the setting.
 */
class KeyboardChannel(
    private val context: Context,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler {

    private val channel = MethodChannel(messenger, "shop_app/keyboard")

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "state" -> {
                val config = context.resources.configuration
                val hardKeyboard =
                    config.hardKeyboardHidden == Configuration.HARDKEYBOARDHIDDEN_NO
                // Hidden setting: may be unreadable on some Android versions.
                val showIme: Boolean? = try {
                    Settings.Secure.getInt(
                        context.contentResolver,
                        "show_ime_with_hard_keyboard",
                    ) == 1
                } catch (e: Exception) {
                    null
                }
                result.success(mapOf("hardKeyboard" to hardKeyboard, "showIme" to showIme))
            }
            "openSettings" -> {
                val intents = listOf(
                    Intent(Settings.ACTION_HARD_KEYBOARD_SETTINGS),
                    Intent(Settings.ACTION_INPUT_METHOD_SETTINGS),
                )
                for (intent in intents) {
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    try {
                        context.startActivity(intent)
                        break
                    } catch (e: Exception) {
                        continue
                    }
                }
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    fun dispose() = channel.setMethodCallHandler(null)
}
