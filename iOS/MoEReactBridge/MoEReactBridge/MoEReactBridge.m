//
//  MoEngageManager.m
//  MoEngage
//
//  Created by Chengappa C D on 11/11/16.
//  Copyright © 2016 MoEngage. All rights reserved.
//

#import "MoEReactBridge.h"
#import <React/RCTLog.h>
#import <React/RCTConvert.h>
#import <MoEngage/MoEngage.h>

@implementation MoEReactBridge{
    bool hasListeners;
}

#pragma mark- Observers
// Will be called when this module's first listener is added.
-(void)startObserving {
    // Set up any upstream listeners or background tasks as necessary
    hasListeners = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationClickedCallback:) name:@"MoEngage_Notification_Received" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inAppShownCallback:) name:@"InAppShownNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inAppClickedCallback:) name:@"InAppClickedNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventTriggeredSelfHandledInAppCallback:) name:@"EventTriggeredSelfHandledInAppNotification" object:nil];
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
    // Remove upstream listeners, stop unnecessary background tasks
    hasListeners = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MoEngage_Notification_Received" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"InAppShownNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"InAppClickedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EventTriggeredSelfHandledInAppNotification" object:nil];
}

#pragma mark- Event Emitters
- (NSArray<NSString *> *)supportedEvents
{
    return @[@"notificationClicked",@"inAppShown",@"inAppClicked", @"eventTriggeredSelfHandledInApp"];
}

-(void)notificationClickedCallback:(NSNotification *)notification{
    if (hasListeners) { // Only send events if anyone is listening
        [self sendEventWithName:@"notificationClicked" body:notification.userInfo];
    }
}

-(void)inAppShownCallback:(NSNotification *)notification{
    if (hasListeners) { // Only send events if anyone is listening
        [self sendEventWithName:@"inAppShown" body:notification.userInfo];
    }
}

-(void)inAppClickedCallback:(NSNotification *)notification{
    if (hasListeners) { // Only send events if anyone is listening
        [self sendEventWithName:@"inAppClicked" body:notification.userInfo];
    }
}

-(void)eventTriggeredSelfHandledInAppCallback:(NSNotification *)notification{
    if (hasListeners) { // Only send events if anyone is listening
        [self sendEventWithName:@"eventTriggeredSelfHandledInApp" body:notification.userInfo];
    }
}

RCT_EXPORT_MODULE();

#pragma mark- registerForPushNotification

RCT_EXPORT_METHOD(registerForPushNotification)
{
    if (@available(iOS 10.0, *)) {
        [[MoEngage sharedInstance] registerForRemoteNotificationWithCategories:nil withUserNotificationCenterDelegate:[UIApplication sharedApplication].delegate];
    } else {
        [[MoEngage sharedInstance] registerForRemoteNotificationForBelowiOS10WithCategories:nil];
    }
}

#pragma mark- trackEvent

RCT_EXPORT_METHOD(trackEvent:(NSString *)name withAttributes:(NSDictionary *)details)
{
    [[MoEngage sharedInstance] trackEvent:name andPayload:[details mutableCopy]];
}

#pragma mark- User Attribute Methods
#pragma mark setUserAttribute
RCT_EXPORT_METHOD(setUserAttribute:(NSDictionary *)userAttributeDict)
{
    if (userAttributeDict != nil) {
        NSString* attributeName = [MoEReactBridge validObjectForKey:@"AttributeName" inDict:userAttributeDict];
        id attributeValue = [MoEReactBridge validObjectForKey:@"AttributeValue" inDict:userAttributeDict];
        [[MoEngage sharedInstance] setUserAttribute:attributeValue forKey:attributeName];
    }
    
}

#pragma mark setUserAttributeLocation

RCT_EXPORT_METHOD(setUserAttributeLocation:(NSDictionary *)userAttributeDict)
{
    if (userAttributeDict != nil) {
        NSString* attributeName = [MoEReactBridge validObjectForKey:@"AttributeName" inDict:userAttributeDict];
        double attributeLatValue = [[MoEReactBridge validObjectForKey:@"LatVal" inDict:userAttributeDict] doubleValue];
        double attributeLngValue = [[MoEReactBridge validObjectForKey:@"LngVal" inDict:userAttributeDict] doubleValue];
        [[MoEngage sharedInstance] setUserAttributeLocationLatitude:attributeLatValue longitude:attributeLngValue forKey:attributeName];
    }
    
}

#pragma mark setUserAttributeTimestamp

RCT_EXPORT_METHOD(setUserAttributeTimestamp:(NSDictionary *)userAttributeDict)
{
    if (userAttributeDict != nil) {
        NSString* attributeName = [MoEReactBridge validObjectForKey:@"AttributeName" inDict:userAttributeDict];
        double attributeValue = [[MoEReactBridge validObjectForKey:@"TimeStampVal" inDict:userAttributeDict] doubleValue];
        [[MoEngage sharedInstance] setUserAttributeTimestamp:attributeValue forKey:attributeName];
    }
    
}


#pragma mark- logout

RCT_EXPORT_METHOD(logout)
{
    [[MoEngage sharedInstance] resetUser];
}


#pragma mark- inApp Methods
#pragma mark showInApp

RCT_EXPORT_METHOD(showInApp)
{
    [[MoEngage sharedInstance] handleInAppMessage];
}

#pragma mark disableInApps

RCT_EXPORT_METHOD(disableInApps)
{
    [MoEngage sharedInstance].disableInApps = YES;
}



#pragma mark- isExistingUser

RCT_EXPORT_METHOD(isExistingUser:(BOOL)isExisting)
{
    if (isExisting) {
        [[MoEngage sharedInstance] appStatus:UPDATE];
    }
    else{
        [[MoEngage sharedInstance] appStatus:INSTALL];
    }
}


#pragma mark- disableInbox

RCT_EXPORT_METHOD(disableInbox)
{
    [MoEngage sharedInstance].disableInbox = YES;
}

#pragma mark- setLogLevel

RCT_EXPORT_METHOD(setLogLevel:(nonnull NSNumber *)level)
{
    NSInteger levelInt = [level integerValue];
    if (levelInt == 2) {
        [MoEngage debug:LOG_EXCEPTIONS];
    }
    else if (levelInt == 1 ){
        [MoEngage debug:LOG_ALL];
    }
    else{
        [MoEngage debug:LOG_NONE];
    }
}


#pragma mark- Utility Methods

+ (id)validObjectForKey: (id)key inDict:(NSDictionary*)dict {
    id obj = [dict objectForKey:key];
    if (obj == [NSNull null]) {
        obj = nil;
    }
    return obj;
}

+ (id)validObjectForKeyPath:(id)keyPath inDict:(NSDictionary*)dict{
    id obj = [dict valueForKeyPath:keyPath];
    if (obj == [NSNull null]) {
        obj = nil;
    }
    return obj;
}

#pragma mark- Thread
- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end
