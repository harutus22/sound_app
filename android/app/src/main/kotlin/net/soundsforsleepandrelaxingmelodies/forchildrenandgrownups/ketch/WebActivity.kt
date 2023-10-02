package net.soundsforsleepandrelaxingmelodies.forchildrenandgrownups.ketch

import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.isVisible
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.whenStateAtLeast
import com.google.android.gms.ads.identifier.AdvertisingIdClient
import kotlinx.android.synthetic.main.activity_web.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import net.soundsforsleepandrelaxingmelodies.forchildrenandgrownups.R


class WebActivity : AppCompatActivity() {

    private val sharedPreferences: KetchSharedPreferences by lazy {
        KetchSharedPreferences(this)
    }

    private val advertisingId = MutableStateFlow<String?>(null)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_web)


        ketchWebView.listener = object : KetchWebView.KetchListener {
            override fun onCCPAUpdate(ccpaString: String?) {
                sharedPreferences.saveUSPrivacyString(ccpaString)
            }

            override fun onTCFUpdate(tcfString: String?) {
                sharedPreferences.saveTCFTCString(tcfString)
            }

            override fun onClose() {
                onBackPressed()
            }

        }

//        button.setOnClickListener {
//            ketchWebView.show()
//        }

        collectState(advertisingId) {
            it?.let { aaid ->
                progressBar.isVisible = false

                // identities to be passed to the WebView displaying the Ketch Preference Center
                val identities = ArrayList<Identity>()
                identities.add(Identity(ADVERTISING_ID_CODE, aaid))

                ketchWebView.init(ORG_CODE, PROPERTY, identities)
                ketchWebView.show()
            }
        }

        progressBar.isVisible = true

        loadAdvertisingId()
    }

//    @OptIn(DelicateCoroutinesApi::class)
    private fun loadAdvertisingId() {
        GlobalScope.launch(Dispatchers.IO) {
            try {
                advertisingId.value =
                    AdvertisingIdClient.getAdvertisingIdInfo(applicationContext).id
            } catch (e: Exception) {
                e.printStackTrace()
                progressBar.isVisible = false
                Toast.makeText(
                    this@WebActivity,
                    R.string.cannot_get_advertising_id_toast,
                    Toast.LENGTH_LONG
                )
                    .show()
            }
        }
    }

    private fun <A> collectState(
        state: StateFlow<A>,
        minState: Lifecycle.State = Lifecycle.State.STARTED,
        collector: suspend (A) -> Unit
    ) = state.collectLifecycle(minState, collector)

    private fun <T> Flow<T>.collectLifecycle(
        minState: Lifecycle.State,
        collector: suspend (T) -> Unit
    ) {
        lifecycleScope.launch {
            lifecycle.whenStateAtLeast(minState) {
                collectLatest {
                    collector(it)
                }
            }
        }
    }

    companion object {
        private const val ORG_CODE = "soax"
        private const val PROPERTY = "sounds__android_"
        private const val ADVERTISING_ID_CODE = "swb_sounds_for_sleep_and_relaxing__android_"
    }
}