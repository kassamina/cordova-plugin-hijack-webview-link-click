/**
 * src/ios: HijackWebviewLinkClick.m
**/

#import <Cordova/CDVPlugin.h>
#import <WebKit/WebKit.h>
#import "HijackWebviewLinkClick.h"

static NSString*const LOG_TAG = @"HijackWebviewLinkClick[native]";

@implementation HijackWebviewLinkClick
    @synthesize notificationCallbackId;

    - (void) pluginInitialize {
        [self _logInfo:@"Starting HijackWebviewLinkClick plugin"];
        id<WKUIDelegate> uiDelegate = self;

        [self.webViewEngine updateWithInfo:@{
            kCDVWebViewEngineWKUIDelegate:uiDelegate
        }];

        [self setListenerId:@""];
    }

    - (WKWebView*) webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
        if (self.notificationCallbackId != nil) {
            NSMutableDictionary* infoObject = [NSMutableDictionary dictionaryWithCapacity:3];
            [infoObject setObject:[NSNumber numberWithInteger:[navigationAction navigationType]] forKey:@"navigationType"];
            [infoObject setObject:[[[navigationAction request] URL] absoluteString] forKey:@"url"];
            [infoObject setObject:[[[[navigationAction sourceFrame] request] URL] absoluteString] forKey:@"sourceFrame"];

            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:infoObject];
            [pluginResult setKeepCallbackAsBool:YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.notificationCallbackId];
        }

        return nil;
    }

    - (void) onLinkClicked:(CDVInvokedUrlCommand *)command {
        @try {
            self.notificationCallbackId = command.callbackId;
        }@catch (NSException *exception) {
            [self handlePluginException:exception :command];
        }
    }

    - (BOOL)shouldOverrideRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
        NSString *scheme = [request URL].scheme;
        [self _logInfo:[NSString stringWithFormat:@"shouldOverrideRequest: %ld, %@", (long)navigationType, scheme]];

        if (self.notificationCallbackId != nil && navigationType == 0 && ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"])) {
             NSMutableDictionary* infoObject = [NSMutableDictionary dictionaryWithCapacity:2];
             [infoObject setObject:[NSNumber numberWithInteger:navigationType] forKey:@"navigationType"];
             [infoObject setObject:[[request URL] absoluteString] forKey:@"url"];

             CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:infoObject];
             [pluginResult setKeepCallbackAsBool:YES];
             [self.commandDelegate sendPluginResult:pluginResult callbackId:self.notificationCallbackId];
            return YES;
        } else {
            return NO;
        }
    }

    - (BOOL) respondsToSelector:(SEL)selector {
        return selector == NSSelectorFromString(@"shouldOverrideRequest:navigationType:");;
    }


    - (void) handlePluginException: (NSException*) exception :(CDVInvokedUrlCommand*)command {
        [self _logError:[NSString stringWithFormat:@"EXCEPTION: %@", exception.reason]];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:exception.reason];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }

    - (void)executeGlobalJavascript: (NSString*)jsString {
        [self.commandDelegate evalJs:jsString];
    }

    - (void)_logError: (NSString*)msg {
        NSLog(@"%@ ERROR: %@", LOG_TAG, msg);
        NSString* jsString = [NSString stringWithFormat:@"console.error(\"%@: %@\")", LOG_TAG, [self escapeJavascriptString:msg]];
        [self executeGlobalJavascript:jsString];
    }

    - (void)_logInfo: (NSString*)msg {
        NSLog(@"%@ INFO: %@", LOG_TAG, msg);
        NSString* jsString = [NSString stringWithFormat:@"console.info(\"%@: %@\")", LOG_TAG, [self escapeJavascriptString:msg]];
        [self executeGlobalJavascript:jsString];
    }

    - (NSString*)escapeJavascriptString: (NSString*)str {
        NSString* result = [str stringByReplacingOccurrencesOfString: @"\"" withString: @"\\\""];
        result = [result stringByReplacingOccurrencesOfString: @"\n" withString: @"\\\n"];
        return result;
    }
@end;
