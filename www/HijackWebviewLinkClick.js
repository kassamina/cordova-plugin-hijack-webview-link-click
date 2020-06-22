/**
 * www: HijackWebviewLinkClick.js
 **/

var exec = require('cordova/exec');

exports.onLinkClicked = function (success, error) {
    exec(success, error, "HijackWebviewLinkClick", "onLinkClicked", []);
};