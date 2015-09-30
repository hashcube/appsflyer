/* global Class, exports:true, NATIVE */

function pluginSend(evt, params) {
  'use strict';

  NATIVE.plugins.sendEvent('AppsFlyerPlugin', evt,
    JSON.stringify(params || {}));
}

var AppsFlyer = Class(function () {
  'use strict';

  this.init = function () {};

  this.setUserId = function (uid) {
    // Allowed params
    // uid : custom user id
    pluginSend('setUserId', {
      uid: uid
    });
  };

  this.trackPurchase = function (receipt, item, revenue,
    currency, transaction_id) {
    pluginSend('trackPurchase', {
      receipt: receipt,
      transactionId: transaction_id,
      productId: item,
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
