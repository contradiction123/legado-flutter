package com.legado.legado_flutter

import android.content.Intent
import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.legado.legado_flutter/file_share"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "shareFile" -> {
                    val path = call.argument<String>("path")
                    val title = call.argument<String>("title") ?: "share"
                    if (path.isNullOrBlank()) {
                        result.error("invalid_path", "Path is empty", null)
                        return@setMethodCallHandler
                    }

                    try {
                        shareFile(path, title)
                        result.success(null)
                    } catch (error: Throwable) {
                        result.error("share_failed", error.message, null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun shareFile(path: String, title: String) {
        val file = File(path)
        val uri: Uri = FileProvider.getUriForFile(
            this,
            "${applicationContext.packageName}.fileprovider",
            file
        )

        val shareIntent = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_STREAM, uri)
            putExtra(Intent.EXTRA_SUBJECT, title)
            putExtra(Intent.EXTRA_TEXT, title)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }

        startActivity(Intent.createChooser(shareIntent, title))
    }
}
