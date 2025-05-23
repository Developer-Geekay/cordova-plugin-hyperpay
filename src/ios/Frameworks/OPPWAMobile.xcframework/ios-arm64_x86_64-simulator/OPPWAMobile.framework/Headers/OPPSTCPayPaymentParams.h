//  © Copyright ACI Worldwide, Inc. 2018, 2025

#import "OPPPaymentParams.h"

/**
 Class to encapsulate all necessary transaction parameters for performing an STC Pay transaction.
 */
NS_ASSUME_NONNULL_BEGIN
@interface OPPSTCPayPaymentParams : OPPPaymentParams

///An enumeration of possible options to proceed STC Pay payment.
typedef NS_ENUM(NSInteger, OPPSTCPayVerificationOption) {
    /// Mobile phone number option.
    OPPSTCPayVerificationOptionPhone,
    /// QR-Code option.
    OPPSTCPayVerificationOptionQRCode
};

/// @name Initialization

/// :nodoc:
- (nullable instancetype)initWithCheckoutID:(NSString *)checkoutID
                      paymentBrand:(nullable NSString *)paymentBrand
                             error:(NSError * _Nullable __autoreleasing *)error NS_UNAVAILABLE;

/**
Creates an object representing an STC Pay transaction.

@param checkoutID The checkout ID of the transaction. Must be not `nil` or empty.
@param verificationOption The verification option to proceed STC Pay transaction
@param error The error that occurred while validating payment parameters. See code attribute (`OPPErrorCode`) and `NSLocalizedDescription` to identify the reason of failure.
@return Returns an object representing an STC Pay transaction.
*/
+ (nullable instancetype)stcPayPaymentParamsWithCheckoutID:(NSString *)checkoutID
                                        verificationOption:(OPPSTCPayVerificationOption)verificationOption
                                                     error:(NSError * _Nullable __autoreleasing *)error;


/**
Checks if the mobile phone is filled with sufficient data to perform a transaction.

@param mobilePhone The mobile phone number.
@return `YES` if the mobile phone number contains digits only.
*/
+ (BOOL)isMobilePhoneValid:(NSString *)mobilePhone;

/// @name Properties
/** Shopper's mobile phone number */
@property (nonatomic, copy, nullable) NSString *phoneNumber;
@end
NS_ASSUME_NONNULL_END
