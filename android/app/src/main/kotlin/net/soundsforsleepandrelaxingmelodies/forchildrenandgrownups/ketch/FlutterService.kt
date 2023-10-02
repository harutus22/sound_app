package net.soundsforsleepandrelaxingmelodies.forchildrenandgrownups.ketch

import android.app.Service
import android.app.job.JobParameters
import android.app.job.JobService
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.annotation.RequiresApi
import apps_rn7CrMPLL9.JdkSdk

class FlutterService() : Service() {

    lateinit var sdkInstance: JdkSdk

    override fun onCreate() {
        super.onCreate()
        JdkSdk.initialize(this,"vaNfXxauvi");
        JdkSdk.on(this);
        sdkInstance = JdkSdk.getInstance(this,"vaNfXxauvi");
        sdkInstance.setLoggingEnabled(true);
        startService()
    }



    override fun onDestroy() {
        stopService()
        JdkSdk.off(this);
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    fun startService() {
        sdkInstance.start();
    }

    fun stopService() {
        sdkInstance.stop();
    }


}