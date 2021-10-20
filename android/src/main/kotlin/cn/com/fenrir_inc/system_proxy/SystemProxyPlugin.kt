package cn.com.fenrir_inc.system_proxy

import android.content.Context
import android.net.ConnectivityManager
import android.os.Build
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** SystemProxyPlugin */
class SystemProxyPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var connectivityManager: ConnectivityManager

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val context = flutterPluginBinding.applicationContext
        connectivityManager =
            context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "system_proxy")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getProxySettings") {
            result.success(getProxySettings())
        } else {
            result.notImplemented()
        }
    }

    private fun getProxySettings(): String? {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val info = connectivityManager.defaultProxy ?: return null
            return "${info.host}:${info.port}"
        } else {
            val host = System.getProperty("http.proxyHost") ?: return null
            val port = System.getProperty("http.proxyPort") ?: return null
            return "$host:$port"
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
