/* global Class, exports:true, NATIVE, logger */

function pluginSend(evt, params) {
  NATIVE.plugins.sendEvent('AppsFlyerPlugin', evt, JSON.stringify(params || {}));
}

var AppsFlyer = Class(function () {

  this.init = function () {
    logger.log('{AppsFlyer} Registering for events on startup');
  };

  this.setUserId = function (params) {
    // Allowed params
    // uid : custom user id
    pluginSend('setUserId', params);
  };

  this.trackPurchase = function (receipt, productId, revenue,
    currency, transaction_id) {
    var params = {
      receipt: receipt,
      productId: productId,
      revenue: revenue,
      currency: currency,
      transaction_id: transaction_id
    };

    pluginSend('trackPurchase', params);
  };

  //refer to AppsFlyerTracker.h for some predefined keys
  this.trackEventWithValue = function (event_name, value) {
    var params = {
      event_name: event_name,
      value: value
    };
    pluginSend('trackEventWithValue', params);
  };

});

exports = new AppsFlyer();
