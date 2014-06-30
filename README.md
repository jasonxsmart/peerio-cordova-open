open
====

Open documents with compatible applications installed on the user's device.

## Install

```bash
$ cordova plugin add https://github.com/cordova-bridge/open
```

## Usage

The plugin exposes the following methods:

```javascript
cordova.plugins.bridge.open(file, success, error)
```

#### Parameters:

* __file:__ A string representing a local URI
* __success:__ Optional success callback
* __error:__ Optional error callback

## Example

#### Default usage

```javascript
cordova.plugins.bridge.open('cdv://path/to/some/file.mp4');
```

#### With optional callbacks

```javascript
var bridgeOpen = cordova.plugins.bridge.open;

function success() {
  console.log('bridge.open success');
}

function error() {
  console.log('bridge.open error');
}

bridgeOpen('cdv://path/to/some/file.mp4', success, error);
```

## Todo

- ~~Echo on Android~~
- Open files on Android
- Echo on iOS
- Open files on iOS

## Links

- http://stackoverflow.com/questions/18265704/ios-qlpreviewcontroller-show-pdf-saved-to-file-system
- http://stackoverflow.com/questions/9513783/how-to-use-open-in-feature-to-ios-app
- http://code.tutsplus.com/tutorials/ios-sdk-previewing-and-opening-documents--mobile-15130
- http://chrisdell.info/blog/writing-ios-cordova-plugin-pure-swift/
- http://docs.phonegap.com/en/3.5.0/plugin_ref_plugman.md.html#Using%20Plugman%20to%20Manage%20Plugins
- http://docs.phonegap.com/en/3.5.0/guide_hybrid_plugins_index.md.html#Plugin%20Development%20Guide
- http://docs.phonegap.com/en/3.5.0/guide_platforms_android_plugin.md.html#Android%20Plugins
- http://docs.phonegap.com/en/3.5.0/guide_platforms_ios_plugin.md.html#iOS%20Plugins