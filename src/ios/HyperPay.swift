import Foundation
import OPPWAMobile

@objc(HyperPay)
class HyperPay: CDVPlugin {

    @objc(startPayment:)
    func startPayment(command: CDVInvokedUrlCommand) {
        let amount = command.arguments[0] as? String ?? "0.00"
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Payment started with amount: \(amount)")
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }
}
