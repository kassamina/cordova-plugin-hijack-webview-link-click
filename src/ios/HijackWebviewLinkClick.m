/**
 * src/ios: HijackWebviewLinkClick.m
**/

#import <Cordova/CDVPlugin.h>
#import <WebKit/WebKit.h>
#import "HijackWebviewLinkClick.h"

@implementation HijackWebviewLinkClick
    - (void) pluginInitialize {
        id<WKUIDelegate> uiDelegate = self;

        [self.webViewEngine updateWithInfo:@{
            kCDVWebViewEngineWKUIDelegate:uiDelegate
        }];

        [self setListenerId:@""];
    }


    - (WKWebView*) webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
        if (!navigationAction.targetFrame.isMainFrame) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:navigationAction.request.URL.absoluteString]];
        }

        return nil;
    }

    - (bool) shouldOverrideLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
        if (navigationType == UIWebViewNavigationTypeLinkClicked) {
            if ([self getListenerId] != "") {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[[request URL] absoluteString]];

                [pluginResult setKeepCallbackAsBool:YES];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:[self getListenerId]];
            }
        }

        return NO;
    }

    - (void) listen:(CDVInvokedUrlCommand*) command {
        @try {
            [self setListenerId:command.callbackId];
        }

        @catch (NSException *exception) {
            NSString* reason = [exception reason];
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:reason];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }

    - (void) deactivate:(CDVInvokedUrlCommand*) command {
        @try {
            [self setListenerId:@""];
        }

        @catch (NSException *exception) {
            NSString* reason = [exception reason];
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:reason];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }

@end;
