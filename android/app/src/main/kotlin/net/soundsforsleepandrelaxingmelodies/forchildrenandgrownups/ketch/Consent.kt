package net.soundsforsleepandrelaxingmelodies.forchildrenandgrownups.ketch

import com.google.gson.annotations.SerializedName

data class Consent(
    @SerializedName("purposes") var purposes: Map<String, Boolean>?,
    @SerializedName("vendors") var vendors: List<String>?
)