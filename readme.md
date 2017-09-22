# cordova-plugin-hijack-webview-link-click

Hijack webview link clicks. Useful for opening “unrecognized” URLs from, eg., iframes, in Safari.

## Methods
### `listen`
Function to execute when the webview tries to navigate to an absolute URL.

#### Example:
```javascript
const {HijackWebviewLinkClick} = window.cordova.plugins;

HijackWebviewLinkClick.listen((url) => {
    window.open(url, '_blank');
});
```

### `deactivate`
Deactivates hijacking.

#### Example:
```javascript
const {HijackWebviewLinkClick} = window.cordova.plugins;
HijackWebviewLinkClick.deactivate();
```
