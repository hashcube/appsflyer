/* global Class, exports:true, NATIVE, logger */

function pluginSend(evt, params) {
  NATIVE.plugins.sendEvent('AppsFlyerPlugin', evt, JSON.stringify(params || {}));
}

var AppsFlyer = Class(function () {

  this.init = function () {
  };

  this.setUserId = function (uid) {
    // Allowed params
    // uid : custom user id
    pluginSend('setUserId', {
      uid: uid
    });
  };

  this.trackPurchase = function (receipt, productId, revenue,
    currency) {
    pluginSend('trackPurchase', {
      receipt: receipt,
      productId: productId,
      revenue: revenue,
      currency: currency
    });
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
