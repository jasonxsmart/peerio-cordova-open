/**
 * disusered.open.js
 *
 * @overview Open documents with compatible apps.
 * @author Carlos Antonio
 * @license MIT
*/

var exec = require('cordova/exec');

/**
 * open
 *
 * @param {String} uri File URI
 * @param {Function} success Success callback
 * @param {Function} error Failure callback
 * @param {Boolean} trustAllCertificates Trusts any certificate when the connection is done over HTTPS.
 * @returns {void}
 */
exports.open = function(uri, success, error, trustAllCertificates) {
  if (!uri || arguments.length === 0) { return false; }

  uri = encodeURI(uri);
  exec(onSuccess.bind(this, uri, success),
       onError.bind(this, error), 'Open', 'open', [uri]);
};

/**
 * onSuccess
 *
 * @param {String} path File URI
 * @param {Function} callback Callback
 * @returns {String} File URI
 */
function onSuccess(path, callback) {
  fire('success', path);
  if (typeof callback === 'function') {
    callback(path);
  }
  return path;
}

/**
 * onError
 *
 * @param {Function} callback Callback
 * @returns {Number} Error Code
 */
function onError(callback) {
  var code = (arguments.length > 1) ? arguments[1] : 0;
  fire('error', code);
  if (typeof callback === 'function') {
    callback(code);
  }
  return code;
}

/**
 * fire
 *
 * @param {String} event Event name
 * @param {String} data Success or error data
 * @returns {void}
 */
function fire(event, data) {
  var channel = require('cordova/channel');
  var cordova = require('cordova');
  var payload = {};

  channel.onCordovaReady.subscribe(function() {
    var name = 'open.' + event;
    var prop = (event === 'error') ? event : 'data';
    payload[prop] = data;
    cordova.fireDocumentEvent(name, payload);
  });
}
