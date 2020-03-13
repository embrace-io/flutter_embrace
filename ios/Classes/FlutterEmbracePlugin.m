#import "FlutterEmbracePlugin.h"
#import <Embrace/Embrace.h>

static NSString *const kEmbraceChannelName = @"flutter_embrace";
//calls
static NSString *const kEmbraceCallStart = @"start";
static NSString *const kEmbraceCallLogInfo = @"logInfo";
static NSString *const kEmbraceCallLogError = @"logError";
static NSString *const kEmbraceCallLogWarning = @"logWarning";
static NSString *const kEmbraceCallLogBreadcrumb = @"logBreadcrumb";
static NSString *const kEmbraceCallIsStarted = @"isStarted";
static NSString *const kEmbraceCallSetUserIdentifier = @"setUserIdentifier";
static NSString *const kEmbraceCallClearUserIdentifier = @"clearUserIdentifier";
static NSString *const kEmbraceCallSetUsername = @"setUsername";
static NSString *const kEmbraceCallClearUsername = @"clearUsername";
static NSString *const kEmbraceCallSetUserEmail = @"setUserEmail";
static NSString *const kEmbraceCallClearUserEmail = @"clearUserEmail";
static NSString *const kEmbraceCallSetUserAsPayer = @"setUserAsPayer";
static NSString *const kEmbraceCallClearUserAsPayer = @"clearUserAsPayer";
static NSString *const kEmbraceCallClearAllUserPersonas = @"clearAllUserPersonas";
static NSString *const kEmbraceCallSetUserPersona = @"setUserPersona";
static NSString *const kEmbraceCallClearUserPersona = @"clearUserPersona";
static NSString *const kEmbraceCallStartEvent = @"startEvent";
static NSString *const kEmbraceCallEndEvent = @"endEvent";
static NSString *const kEmbraceCallStartAppStartup = @"startAppStartup";
static NSString *const kEmbraceCallEndAppStartup = @"endAppStartup";
static NSString *const kEmbraceCallLogNetworkCall = @"logNetworkCall";
static NSString *const kEmbraceCallLogNetworkError = @"logNetworkError";
static NSString *const kEmbraceCallLogView = @"logView";
static NSString *const kEmbraceCallLogWebView = @"logWebView";
static NSString *const kEmbraceCallForceLogView = @"forceLogView";
static NSString *const kEmbraceCallStop = @"stop";
static NSString *const kEmbraceCallCrash = @"crash";
//arguments
static NSString *const kEmbraceArgumentMessage = @"message";
static NSString *const kEmbraceArgumentProperties = @"properties";
static NSString *const kEmbraceArgumentAllowScreenshot = @"allowScreenshot";
static NSString *const kEmbraceArgumentName = @"name";
static NSString *const kEmbraceArgumentIdentifier = @"identifier";
static NSString *const kEmbraceArgumentInformation = @"information";
static NSString *const kEmbraceArgumentException = @"exception";
static NSString *const kEmbraceArgumentStackTraceElements = @"stackTraceElements";
static NSString *const kEmbraceArgumentContext = @"context";
static NSString *const kEmbraceArgumentStartTime = @"startTime";
static NSString *const kEmbraceArgumentErrorMessage = @"errorMessage";
static NSString *const kEmbraceArgumentMethod = @"method";
static NSString *const kEmbraceArgumentEndTime = @"endTime";
static NSString *const kEmbraceArgumentUrl = @"url";
static NSString *const kEmbraceArgumentErrorType = @"errorType";
//error codes
static NSString *const  kEmbraceErrorCodeUnhandledCall = @"100";
static NSString *const  kEmbraceErrorCodeMissingArgument = @"101";

@implementation FlutterEmbracePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:kEmbraceChannelName binaryMessenger:registrar.messenger];
    FlutterEmbracePlugin *plugin = [FlutterEmbracePlugin new];
    [registrar addMethodCallDelegate:plugin channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:kEmbraceCallStart]) {
        NSLog(@"The Embrace SDK must be started by adding a call to start in the Runner's AppDelegate.swift:didFinishLaunchingWithOptions.");
        result(FlutterMethodNotImplemented);
    } else if ([call.method isEqualToString:kEmbraceCallIsStarted]) {
        NSLog(@"The Embrace iOS SDK does not implement the isStarted property.");
        result(FlutterMethodNotImplemented);
    } else if ([call.method isEqualToString:kEmbraceCallStop]) {
        NSLog(@"The Embrace iOS SDK does not implement the stop call.");
        result(FlutterMethodNotImplemented);
    } else if ([call.method isEqualToString:kEmbraceCallForceLogView]) {
        NSLog(@"The Embrace iOS SDK does not implement the forceLogView call.");
        result(FlutterMethodNotImplemented);
    } else if ([call.method isEqualToString:kEmbraceCallLogInfo] ||
               [call.method isEqualToString:kEmbraceCallLogError] ||
               [call.method isEqualToString:kEmbraceCallLogWarning]) {
        [self handleLoggingCall:call result:result];
    } else if ([call.method isEqualToString:kEmbraceCallSetUserIdentifier] ||
               [call.method isEqualToString:kEmbraceCallClearUserIdentifier] ||
               [call.method isEqualToString:kEmbraceCallSetUsername] ||
               [call.method isEqualToString:kEmbraceCallClearUsername] ||
               [call.method isEqualToString:kEmbraceCallSetUserEmail] ||
               [call.method isEqualToString:kEmbraceCallClearUserEmail] ||
               [call.method isEqualToString:kEmbraceCallSetUserAsPayer] ||
               [call.method isEqualToString:kEmbraceCallClearUserAsPayer] ||
               [call.method isEqualToString:kEmbraceCallClearAllUserPersonas] ||
               [call.method isEqualToString:kEmbraceCallSetUserPersona] ||
               [call.method isEqualToString:kEmbraceCallClearUserPersona]) {
        [self handlePersonaCall:call result:result];
    } else if ([call.method isEqualToString:kEmbraceCallStartEvent] ||
               [call.method isEqualToString:kEmbraceCallEndEvent] ||
               [call.method isEqualToString:kEmbraceCallStartAppStartup] ||
               [call.method isEqualToString:kEmbraceCallEndAppStartup] ||
               [call.method isEqualToString:kEmbraceCallLogBreadcrumb]) {
        [self handleEventCall:call result:result];
    } else if ([call.method isEqualToString:kEmbraceCallLogNetworkCall] ||
               [call.method isEqualToString:kEmbraceCallLogNetworkError] ||
               [call.method isEqualToString:kEmbraceCallLogView] ||
               [call.method isEqualToString:kEmbraceCallLogWebView] ||
               [call.method isEqualToString:kEmbraceCallCrash]) {
        [self handleMiscCall:call result:result];
    } else {
        NSLog(@"Unhandled method call: %@", call);
        result([FlutterError errorWithCode:kEmbraceErrorCodeUnhandledCall message:@"Unhandled method call" details:nil]);
    }
}

// TODO: these methods parse the arguments which (bizzarly, like seriously guys?) use NSNull pointers!?! to indicate nil
// I could do an explicit check for the type in here, if I do that then bad arguments will cast down to nil and may cause the method call to work but give incorrect results
// For now it seems safer to allow bad arguments to go through and raise the underlying crash to notify the dev.
// We should discuss this before review, it may not be the best strategy for args...
- (NSArray *)ArrayOrNilFromArguments:(NSDictionary *)arguments withKey:(NSString *)key {
    NSArray *result = nil;
    if (arguments[key] != nil && ![arguments[key] isKindOfClass:[NSNull class]]) {
        result = arguments[key];
    }
    return result;
}

- (NSDictionary *)DictinaryOrNilFromArguments:(NSDictionary *)arguments withKey:(NSString *)key {
    NSDictionary *result = nil;
    if (arguments[key] != nil && ![arguments[key] isKindOfClass:[NSNull class]]) {
        result = arguments[key];
    }
    return result;
}

- (NSString *)StringOrNilFromArguments:(NSDictionary *)arguments withKey:(NSString *)key {
    NSString *result = nil;
    if (arguments[key] != nil && ![arguments[key] isKindOfClass:[NSNull class]]) {
        result = arguments[key];
    }
    return result;
}

- (NSDate *)DateOrNilFromArguments:(NSDictionary *)arguments withKey:(NSString *)key {
    NSDate *result = nil;
    if (arguments[key] != nil && ![arguments[key] isKindOfClass:[NSNull class]]) {
        NSNumber *timestamp = arguments[key];
        long epochTime = timestamp.longValue / 1000;  // Flutter is in microseconds?
        result = [NSDate dateWithTimeIntervalSince1970:epochTime];
    }
    return result;
}

- (BOOL)BoolOrNOFromArguments:(NSDictionary *)arguments withKey:(NSString *)key {
    BOOL result = NO;
    if (![arguments[key] isKindOfClass:[NSNull class]]) {
        result = arguments[key];
    }
    return result;
}

- (void)handleMiscCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:kEmbraceCallLogNetworkCall]) {
        // TODO: iOS implements this entirely differently, we need to create a network request from these properties
        NSDate *startDate = [self DateOrNilFromArguments:call.arguments withKey:kEmbraceArgumentStartTime];
        NSDate *endDate = [self DateOrNilFromArguments:call.arguments withKey:kEmbraceArgumentEndTime];
        NSString *method = [self StringOrNilFromArguments:call.arguments withKey:kEmbraceArgumentMethod];
        NSString *url = [self StringOrNilFromArguments:call.arguments withKey:kEmbraceArgumentUrl];
        NSLog(@"logNetworkError, no-op for now: %@, %@, %@, %@", startDate, endDate, method, url);
    } else if ([call.method isEqualToString:kEmbraceCallLogNetworkError]) {
        // TODO: iOS implements this entirely differently, we need to create a network request from these properties
        NSDate *startDate = [self DateOrNilFromArguments:call.arguments withKey:kEmbraceArgumentStartTime];
        NSDate *endDate = [self DateOrNilFromArguments:call.arguments withKey:kEmbraceArgumentEndTime];
        NSString *errorMessage = [self StringOrNilFromArguments:call.arguments withKey:kEmbraceArgumentErrorMessage];
        NSString *method = [self StringOrNilFromArguments:call.arguments withKey:kEmbraceArgumentMethod];
        NSString *errorType = [self StringOrNilFromArguments:call.arguments withKey:kEmbraceArgumentErrorType];
        NSString *url = [self StringOrNilFromArguments:call.arguments withKey:kEmbraceArgumentUrl];
        NSLog(@"logNetworkError, no-op for now: %@, %@, %@, %@, %@, %@", startDate, endDate, errorMessage, method, errorType, url);
    } else if ([call.method isEqualToString:kEmbraceCallLogView]) {
        // TODO: iOS implements this via two methods (custom view API).
        NSLog(@"The Embrace iOS SDK does not implement the logView call.");
        result(FlutterMethodNotImplemented);
        return;
    } else if ([call.method isEqualToString:kEmbraceCallLogWebView]) {
        // TODO: iOS implements this via two methods (begin and complete).
        NSLog(@"The Embrace iOS SDK does not implement the logWebView call.");
        result(FlutterMethodNotImplemented);
        return;
    } else if ([call.method isEqualToString:kEmbraceCallCrash]) {
        // TODO: this does not seem to be used for the same "test crash" purpose as on iOS, I think this is a reporting method?
        // it isn't clear who would all this or why or where they would get the argument values from when calling it...
        NSString *information = [self StringOrNilFromArguments:call.arguments withKey:kEmbraceArgumentInformation];
        NSString *exception = [self StringOrNilFromArguments:call.arguments withKey:kEmbraceArgumentException];
        NSString *context = [self StringOrNilFromArguments:call.arguments withKey:kEmbraceArgumentContext];
        NSArray *stackTraceElements = [self ArrayOrNilFromArguments:call.arguments withKey:kEmbraceArgumentStackTraceElements];
        NSLog(@"crash call, no-op for now: %@, %@, %@, %@", information, exception, context, stackTraceElements);
    } else {
        NSLog(@"Unhandled method call: %@", call);
        result([FlutterError errorWithCode:kEmbraceErrorCodeUnhandledCall message:@"Unhandled method call" details:nil]);
        return;
    }
    result(nil);
}

- (void)handleEventCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:kEmbraceCallStartEvent]) {
        NSDictionary *properties = [self DictinaryOrNilFromArguments:call.arguments withKey:kEmbraceArgumentProperties];
        BOOL allowScreenshot = [self BoolOrNOFromArguments:call.arguments withKey:kEmbraceArgumentAllowScreenshot];
        NSString *name = [self StringOrNilFromArguments:call.arguments withKey:kEmbraceArgumentName];
        if (name == nil) {
            NSLog(@"start event call requires the name argument.");
            result([FlutterError errorWithCode:kEmbraceErrorCodeMissingArgument message:@"Missing 'name' argument to the start event call." details:nil]);
            return;
        }
        NSString *identifier = [self StringOrNilFromArguments:call.arguments withKey:kEmbraceArgumentIdentifier];
        [Embrace.sharedInstance startMomentWithName:name identifier:identifier allowScreenshot:allowScreenshot properties:properties];
    } else if ([call.method isEqualToString:kEmbraceCallEndEvent]) {
        NSDictionary *properties = [self DictinaryOrNilFromArguments:call.arguments withKey:kEmbraceArgumentProperties];
        NSString *name = [self StringOrNilFromArguments:call.arguments withKey:kEmbraceArgumentName];
        if (name == nil) {
            NSLog(@"end event call requires the name argument.");
            result([FlutterError errorWithCode:kEmbraceErrorCodeMissingArgument message:@"Missing 'name' argument to the end event call." details:nil]);
            return;
        }
        NSString *identifier = [self StringOrNilFromArguments:call.arguments withKey:kEmbraceArgumentIdentifier];
        [Embrace.sharedInstance endMomentWithName:name identifier:identifier properties:properties];
    } else if ([call.method isEqualToString:kEmbraceCallStartAppStartup]) {
        NSLog(@"The Embrace iOS SDK does not implement the startAppStartup method.");
        result(FlutterMethodNotImplemented);
        return;
    } else if ([call.method isEqualToString:kEmbraceCallEndAppStartup]) {
        [Embrace.sharedInstance endAppStartup];
    } else if ([call.method isEqualToString:kEmbraceCallLogBreadcrumb]) {
        [Embrace.sharedInstance logBreadcrumbWithMessage:call.arguments];
    } else {
        NSLog(@"Unhandled event call: %@", call);
        result([FlutterError errorWithCode:kEmbraceErrorCodeUnhandledCall message:@"Unhandled persona call" details:nil]);
        return;
    }
    result(nil);
}

- (void)handlePersonaCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:kEmbraceCallSetUserIdentifier]) {
        [Embrace.sharedInstance setUserIdentifier:call.arguments];
    } else if ([call.method isEqualToString:kEmbraceCallClearUserIdentifier]) {
        [Embrace.sharedInstance clearUserIdentifier];
    } else if ([call.method isEqualToString:kEmbraceCallSetUsername]) {
        [Embrace.sharedInstance setUsername:call.arguments];
    } else if ([call.method isEqualToString:kEmbraceCallClearUsername]) {
        [Embrace.sharedInstance clearUsername];
    } else if ([call.method isEqualToString:kEmbraceCallSetUserEmail] ) {
        [Embrace.sharedInstance setUserEmail:call.arguments];
    } else if ([call.method isEqualToString:kEmbraceCallClearUserEmail]) {
        [Embrace.sharedInstance clearUserEmail];
    } else if ([call.method isEqualToString:kEmbraceCallSetUserAsPayer]) {
        [Embrace.sharedInstance setUserAsPayer];
    } else if ([call.method isEqualToString:kEmbraceCallClearUserAsPayer]) {
        [Embrace.sharedInstance clearUserAsPayer];
    } else if ([call.method isEqualToString:kEmbraceCallClearAllUserPersonas]) {
        [Embrace.sharedInstance clearAllUserPersonas];
    } else if ([call.method isEqualToString:kEmbraceCallSetUserPersona]) {
        [Embrace.sharedInstance setUserPersona:call.arguments];
    } else if ([call.method isEqualToString:kEmbraceCallClearUserPersona]) {
        [Embrace.sharedInstance clearUserPersona:call.arguments];
    } else {
        NSLog(@"Unhandled persona call: %@", call);
        result([FlutterError errorWithCode:kEmbraceErrorCodeUnhandledCall message:@"Unhandled persona call" details:nil]);
        return;
    }
    result(nil);
}

- (void)handleLoggingCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (call.arguments == nil || [call.arguments isKindOfClass:[NSNull class]]) {
        NSLog(@"logging methods require the message argument.");
        result([FlutterError errorWithCode:kEmbraceErrorCodeMissingArgument message:@"Missing 'message' argument to logging call." details:nil]);
        return;
    }
    NSString *message = [self StringOrNilFromArguments:call.arguments withKey:kEmbraceArgumentMessage];
    if (message == nil) {
        NSLog(@"logging methods require the message argument.");
        result([FlutterError errorWithCode:kEmbraceErrorCodeMissingArgument message:@"Missing 'message' argument to logging call." details:nil]);
        return;
    }
    NSDictionary *properties = [self DictinaryOrNilFromArguments:call.arguments withKey:kEmbraceArgumentProperties];
    BOOL allowScreenshot = [self BoolOrNOFromArguments:call.arguments withKey:kEmbraceArgumentAllowScreenshot];
    EMBSeverity severity;
    if ([call.method isEqualToString:kEmbraceCallLogInfo]) {
        severity = EMBSeverityInfo;
    } else if ([call.method isEqualToString:kEmbraceCallLogWarning]) {
        severity = EMBSeverityWarning;
    } else if ([call.method isEqualToString:kEmbraceCallLogError]) {
        severity = EMBSeverityError;
    } else {
        NSLog(@"Unhandled logging call: %@", call);
        result([FlutterError errorWithCode:kEmbraceErrorCodeUnhandledCall message:@"Unhandled logging call" details:nil]);
        return;
    }
    [Embrace.sharedInstance logMessage:message withSeverity:severity properties:properties takeScreenshot:allowScreenshot];
    result(nil);
}

@end
