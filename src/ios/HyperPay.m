#import "HyperPay.h"
#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>

@implementation HyperPay

- (void)setup:(CDVInvokedUrlCommand *)command {
  NSDictionary *options = [command.arguments objectAtIndex:0];

  self.merchantIdentifier = options[@"merchantIdentifier"];
  self.appIdentifier = options[@"appIdentifier"];
  self.shopperResultURL = options[@"shopperResultURL"];
  self.countryCode = options[@"countryCode"];
  self.checkoutID = options[@"checkoutID"];
  self.mode = options[@"mode"] ?: @"TestMode";
  self.supportedNetworks = options[@"supportedNetworks"];
  self.companyName = options[@"companyName"];
  self.amount = [NSDecimalNumber decimalNumberWithString:options[@"amount"]];

  if ([self.mode isEqualToString:@"LiveMode"]) {
    self.provider = [OPPPaymentProvider paymentProviderWithMode:OPPProviderModeLive];
  } else {
    self.provider = [OPPPaymentProvider paymentProviderWithMode:OPPProviderModeTest];
  }

  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"HyperPay setup complete"];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)checkout:(CDVInvokedUrlCommand *)command {

    OPPCheckoutSettings *checkoutSettings = [[OPPCheckoutSettings alloc] init];
    // Set available payment brands for your shop
    checkoutSettings.paymentBrands = @[ @"MADA",@"VISA",@"MASTER" ];

    // Set shopper result URL
    checkoutSettings.shopperResultURL = @"com.muat.riyadcapital.PushNotificationPOC://result";

    OPPCheckoutProvider *checkoutProvider = [OPPCheckoutProvider checkoutProviderWithPaymentProvider:self.provider checkoutID:self.checkoutID settings:checkoutSettings];
    [checkoutProvider presentCheckoutForSubmittingTransactionCompletionHandler:^(OPPTransaction *_Nullable transaction, NSError *_Nullable error) {
        CDVPluginResult *pluginResult;
        NSLog(@"Transaction Response : %@", transaction.type == OPPTransactionTypeSynchronous ? @"Synchronous" : @"Asynchronous");
        if (transaction.type == OPPTransactionTypeSynchronous) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:transaction.resourcePath];
            NSLog(@"Transaction resourcePath Response : %@", transaction.resourcePath);
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:transaction.redirectURL];
            NSLog(@"Transaction redirectURL Response : %@", transaction.redirectURL);
        }
        

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
        
        } cancelHandler:^{
            NSLog(@"Transaction error Response");
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"HyperPay Payment not complete"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            return;
        }
    ];
}

- (void)getPaymentStatus:(CDVInvokedUrlCommand *)command {
    // NSString *URL = [NSString stringWithFormat:@"https://YOUR_URL/paymentStatus?resourcePath=%@", [transaction.resourcePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // NSURLRequest *merchantServerRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];
    // [[[NSURLSession sharedSession] dataTaskWithRequest:merchantServerRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //     // handle error
    //     NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //     BOOL status = [result[@"paymentResult"] boolValue];
    // }] resume];
}


- (void)applePay:(CDVInvokedUrlCommand *)command {

    // Setup Apple Pay payment request
    OPPCheckoutSettings *checkoutSettings = [[OPPCheckoutSettings alloc] init];

    PKPaymentRequest *paymentRequest = [OPPPaymentProvider paymentRequestWithMerchantIdentifier:self.merchantIdentifier countryCode:self.countryCode];

    paymentRequest.supportedNetworks = self.supportedNetworks;

    NSDecimalNumber *amount = self.amount;

    paymentRequest.paymentSummaryItems = @[
        [PKPaymentSummaryItem summaryItemWithLabel:self.companyName amount:amount]
    ];

    checkoutSettings.shopperResultURL = self.shopperResultURL;
    checkoutSettings.applePayPaymentRequest = paymentRequest;

    OPPCheckoutProvider *checkoutProvider = [OPPCheckoutProvider checkoutProviderWithPaymentProvider:self.provider checkoutID:self.checkoutID settings:checkoutSettings];

    // Present the checkout UI
    NSLog(@"Checkout UI presented");
    [checkoutProvider presentCheckoutWithPaymentBrand:@"APPLEPAY"
        loadingHandler:^(BOOL inProgress) {
            // You can fire JS events here if needed
            NSLog(@"Apple Pay loading state: %@", inProgress ? @"YES" : @"NO");
        }
        completionHandler:^(OPPTransaction * _Nullable transaction, NSError * _Nullable error) {
            if (error) {
                CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                return;
            }
            
            NSLog(@"Apple Pay transaction completed. Type: %@", transaction.type == OPPTransactionTypeSynchronous ? @"Synchronous" : @"Asynchronous");
            
            CDVPluginResult *pluginResult;
            NSMutableDictionary *result = [NSMutableDictionary dictionary];
            if (transaction.resourcePath){
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:transaction.resourcePath];
                NSLog(@"Transaction resourcePath Response : %@", transaction.resourcePath);
            } 
            if (transaction.redirectURL){
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:transaction.redirectURL];
                NSLog(@"Transaction redirectURL Response : %@", transaction.redirectURL);
            } 

            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            return;
        }
        cancelHandler:^{
            NSLog(@"Apple Pay transaction completed with error.");
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"cancel"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            return;
        }
    ];
}

@end
