package net.soundsforsleepandrelaxingmelodies.forchildrenandgrownups

import android.content.Intent
import android.os.Build
import android.view.WindowManager
import androidx.annotation.NonNull
import net.soundsforsleepandrelaxingmelodies.forchildrenandgrownups.ketch.FlutterService
import net.soundsforsleepandrelaxingmelodies.forchildrenandgrownups.ketch.WebActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutter.dev/sounds"
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//
//    }
//
//    override fun onStop() {
//
//        super.onStop()
//    }
//
    override fun onStart() {
        super.onStart()
    }

    private lateinit var _result: MethodChannel.Result
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {

                call, result ->
            if (call.method == "start_service") {
                startService(Intent(this, FlutterService::class.java))
                result.success("service_started")
            } else if (call.method == "get_ads") {
                startActivity(Intent(this, WebActivity::class.java))
            }
        }
        var originalStatusBarColor = 0
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            originalStatusBarColor = window.statusBarColor
            window.statusBarColor = 0xff03A9F4.toInt()
        }
        val originalStatusBarColorFinal = originalStatusBarColor
        window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            window.statusBarColor = originalStatusBarColorFinal
        }
    }
}
