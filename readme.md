# cordova-plugin-hijack-webview-link-click

Hijack webview link clicks. Useful for opening “unrecognized” URLs from, eg., iframes, in Safari.

## Methods
### `onLinkClicked`
Function to execute when the wkwebview tries to navigate to an absolute URL.

#### Example:
```javascript
const {HijackWebviewLinkClick} = window.cordova.plugins;

HijackWebviewLinkClick.onLinkClicked((navigationAction) => {
    console.log(navigationAction.url);
    console.log(navigationAction.sourceFrame);
    console.log(navigationAction.navigatidonType);
});
```
onLinkClicked takes a function which will be called when trying to navigate to an absolute url

navigationAction contains a target url, a sourceFrame which can be used to determine where the request came from, and a navigationType

| navigatidonType  | value |
| ------------- | ------------- |
| WKNavigationTypeOther | -1  |
| WKNavigationTypeLinkActivated  | 0  |
| WKNavigationTypeFormSubmitted | 1  |
| WKNavigationTypeBackForward | 2  |
| WKNavigationTypeReload | 3  |
| WKNavigationTypeFormResubmitted | 4  |