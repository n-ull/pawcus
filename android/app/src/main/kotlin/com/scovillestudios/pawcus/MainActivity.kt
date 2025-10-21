package com.scovillestudios.pawcus

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.AppOpsManager
import android.content.Context
import android.os.Process

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.scovillestudios.pawcus/permissions"

    /**
     * Registers a MethodChannel on the provided FlutterEngine and installs a method-call handler
     * that responds to platform channel requests for checking app usage-access permission.
     */
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            // implement native functions here!
            if (call.method == "hasUsageAccess") {
                result.success(hasUsageAccess())
            } else {
                result.notImplemented()
            }
        }
    }

    /**
     * Determines whether the app has permission to access device usage statistics.
     *
     * @return `true` if the app is allowed to read usage stats, `false` otherwise.
     */
    private fun hasUsageAccess(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), packageName)
        return mode == AppOpsManager.MODE_ALLOWED
    }
}