// Generated by CoffeeScript 1.12.3
(function() {
  var SecurityManager, debug;

  debug = require('debug')('smartLeave:SecurityManager');

  SecurityManager = (function() {
    function SecurityManager() {}

    SecurityManager.sessionList = {};

    SecurityManager.maintagID = 0;

    SecurityManager.maxIDN = 5000;

    SecurityManager.getTagID = function() {
      if (this.maintagID >= this.maxIDN) {
        this.maintagID = 0;
      }
      return "" + ((this.maintagID += 1) % this.maxIDN);
    };

    SecurityManager.queryAccount = function(tagID) {
      debug(this.sessionList);
      if (tagID in this.sessionList) {
        return this.sessionList[tagID];
      } else {
        return {
          status: false
        };
      }
    };

    SecurityManager.sendCertification = function(phoneID, tagID) {
      var tlb;
      tlb = {
        "0933216219": {
          status: true,
          name: "許木坤",
          pwd: "5325707"
        }
      };
      this.sessionList["" + tagID] = tlb["" + phoneID];
    };

    return SecurityManager;

  })();

  module.exports = SecurityManager;

}).call(this);