var exec = require("cordova/exec");

exports.setup = function (options, success, error) {
  cordova.exec(success, error, "HyperPay", "setup", [options]);
};

exports.checkout = function (options, success, error) {
  cordova.exec(success, error, "HyperPay", "checkout", [options]);
};

exports.getPaymentStatus = function (options, success, error) {
  cordova.exec(success, error, "HyperPay", "getPaymentStatus", [options]);
};

exports.applePay = function (params, success, error) {
  cordova.exec(success, error, "HyperPay", "applePay", [params]);
};
