/**
 * www: HijackWebviewLinkClick.js
 **/

var exec = require('cordova/exec');
//
// exports.listen = function (success, error) {
//     exec(success, error, 'HijackWebviewLinkClick', 'listen');
// };
//
// exports.deactivate = function (success, error) {
//     exec(success, error, 'HijackWebviewLinkClick', 'deactivate');
// };

exports.onLinkClicked = function (success, error) {
    exec(success, error, "HijackWebviewLinkClick", "onLinkClicked", []);
};