var HyperPay = {
    startPayment: function(amount, success, error) {
        cordova.exec(success, error, "HyperPay", "startPayment", [amount]);
    }
};

module.exports = HyperPay;
