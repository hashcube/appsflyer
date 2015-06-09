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
    pluginSend('setUserIds', params);
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

  this.trackEvent = function (event_name, values) {
  var params = {
      event_name: event_name,
      values: values
    };
    pluginSend('trackEvent', params);
  };

});

exports = new AppsFlyer();
