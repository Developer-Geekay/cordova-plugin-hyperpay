#import <OPPWAMobile/OPPWAMobile.h>
#import <Cordova/CDVPlugin.h>

@interface HyperPay : CDVPlugin {
}

@property(nonatomic, strong) OPPPaymentProvider *provider;
@property(nonatomic, strong) NSString *shopperResultURL;
@property(nonatomic, strong) NSString *appIdentifier;
@property(nonatomic, strong) NSString *merchantIdentifier;
@property(nonatomic, strong) NSString *countryCode;
@property(nonatomic, strong) NSString *checkoutID;
@property(nonatomic, strong) NSString *mode;
@property(nonatomic, strong) NSArray *supportedNetworks;
@property(nonatomic, strong) NSString *companyName;
@property(nonatomic, strong) NSDecimalNumber *amount;

- (void)setup:(CDVInvokedUrlCommand *)command;
- (void)checkout:(CDVInvokedUrlCommand *)command;
- (void)getPaymentStatus:(CDVInvokedUrlCommand *)command;
- (void)applePay:(CDVInvokedUrlCommand *)command;

@end