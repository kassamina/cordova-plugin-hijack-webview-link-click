/**
 * src/ios: HijackWebviewLinkClick.h
**/

#import <Cordova/CDVPlugin.h>
#import <WebKit/WebKit.h>

@interface HijackWebviewLinkClick : CDVPlugin <WKUIDelegate, WKNavigationDelegate>
    @property (nonatomic, strong, getter=getListenerId) NSString* listenerId;
    @property (nonatomic, strong) IBOutlet WKWebView* webView;
    @property (nonatomic, copy) NSString *notificationCallbackId;

    // exported
    - (void) onLinkClicked:(CDVInvokedUrlCommand*)command;
//    - (void) listen: (CDVInvokedUrlCommand*) command;
//    - (void) deactivate: (CDVInvokedUrlCommand*) command;

    // Internals
    - (void) handlePluginException: (NSException*) exception :(CDVInvokedUrlCommand*)command;
    - (void) _logError: (NSString*)msg;
    - (void) _logInfo: (NSString*)msg;
@end;
