package com.hyperpay.plugin

import org.apache.cordova.CallbackContext
import org.apache.cordova.CordovaPlugin
import org.json.JSONArray
import org.json.JSONException

class HyperPay : CordovaPlugin() {

    override fun execute(action: String, args: JSONArray, callbackContext: CallbackContext): Boolean {
        return if (action == "startPayment") {
            val amount = args.optString(0, "0.00")
            startPayment(amount, callbackContext)
            true
        } else {
            false
        }
    }

    private fun startPayment(amount: String, callbackContext: CallbackContext) {
        try {
            // Integrate HyperPay SDK here (initialize and start payment)
            val response = "Payment started with amount: $amount"
            callbackContext.success(response)
        } catch (e: Exception) {
            callbackContext.error("Error starting payment: ${e.message}")
        }
    }
}
