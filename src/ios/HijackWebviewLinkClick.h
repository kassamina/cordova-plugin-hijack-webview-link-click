/**
 * src/ios: HijackWebviewLinkClick.h
**/

#import <Cordova/CDVPlugin.h>
#import <WebKit/WebKit.h>

@interface HijackWebviewLinkClick : CDVPlugin <WKUIDelegate>
    @property (nonatomic, strong, getter=getListenerId) NSString* listenerId;
    @property (nonatomic, strong) IBOutlet WKWebView* webView;

    - (void) listen: (CDVInvokedUrlCommand*) command;
    - (void) deactivate: (CDVInvokedUrlCommand*) command;
@end;
