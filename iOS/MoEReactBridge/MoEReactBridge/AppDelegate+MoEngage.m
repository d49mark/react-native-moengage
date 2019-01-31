
//
//  AppDelegate+MoEngage.m
//  MoEngage
//
//  Created by Chengappa C D on 18/08/2016.
//  Copyright MoEngage 2016. All rights reserved.
//


#import "AppDelegate+MoEngage.h"
#import <objc/runtime.h>
#import <MoEngage/MoEngage.h>

#define MoEngage_APP_ID_KEY                 @"MoEngage_APP_ID"
#define MoEngage_DICT_KEY                   @"MoEngage"

@interface AppDelegate(MoEngageNotifications) <MOInAppDelegate>

@end

@implementation AppDelegate (MoEngageNotifications)

#pragma mark- Load Method

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        id delegate = [UIApplication sharedApplication].delegate;
        
        //ApplicationDidFinshLaunching Method
        SEL appDidFinishLaunching = @selector(application:didFinishLaunchingWithOptions:);
        SEL swizzledAppDidFinishLaunching = @selector(moengage_swizzled_application:didFinishLaunchingWithOptions:);
        [self swizzleMethodWithClass:class originalSelector:appDidFinishLaunching andSwizzledSelector:swizzledAppDidFinishLaunching];
        
        //Application Register for remote notification
        if ([delegate respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
            SEL registerForNotificationSelector = @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
            SEL swizzledRegisterForNotificationSelector = @selector(moengage_swizzled_application:didRegisterForRemoteNotificationsWithDeviceToken:);
            [self swizzleMethodWithClass:class originalSelector:registerForNotificationSelector andSwizzledSelector:swizzledRegisterForNotificationSelector];
        } else {
            SEL registerForNotificationSelector = @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
            SEL swizzledRegisterForNotificationSelector = @selector(moengage_swizzled_no_application:didRegisterForRemoteNotificationsWithDeviceToken:);
            [self swizzleMethodWithClass:class originalSelector:registerForNotificationSelector andSwizzledSelector:swizzledRegisterForNotificationSelector];
        }
        
        if ([delegate respondsToSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)]) {
            SEL failRegisterForNotificationSelector = @selector(application:didFailToRegisterForRemoteNotificationsWithError:);
            SEL swizzledFailRegisterForNotificationSelector = @selector(moengage_swizzled_application:didFailToRegisterForRemoteNotificationsWithError:);
            [self swizzleMethodWithClass:class originalSelector:failRegisterForNotificationSelector andSwizzledSelector:swizzledFailRegisterForNotificationSelector];
        } else {
            SEL failRegisterForNotificationSelector = @selector(application:didFailToRegisterForRemoteNotificationsWithError:);
            SEL swizzledFailRegisterForNotificationSelector = @selector(moengage_swizzled_no_application:didFailToRegisterForRemoteNotificationsWithError:);
            [self swizzleMethodWithClass:class originalSelector:failRegisterForNotificationSelector andSwizzledSelector:swizzledFailRegisterForNotificationSelector];
        }
        
        //Application Register for  user notification settings
        if ([delegate respondsToSelector:@selector(application:didRegisterUserNotificationSettings:)]) {
            SEL registerForUserSettingsSelector = @selector(application:didRegisterUserNotificationSettings:);
            SEL swizzledRegisterForUserSettingsSelector = @selector(moengage_swizzled_application:didRegisterUserNotificationSettings:);
            [self swizzleMethodWithClass:class originalSelector:registerForUserSettingsSelector andSwizzledSelector:swizzledRegisterForUserSettingsSelector];
        } else {
            SEL registerForUserSettingsSelector = @selector(application:didRegisterUserNotificationSettings:);
            SEL swizzledRegisterForUserSettingsSelector = @selector(moengage_swizzled_no_application:didRegisterUserNotificationSettings:);
            [self swizzleMethodWithClass:class originalSelector:registerForUserSettingsSelector andSwizzledSelector:swizzledRegisterForUserSettingsSelector];
        }
        
        //Application Did Receive Remote Notification
        if ([delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
            SEL receivedNotificationSelector = @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:);
            SEL swizzledReceivedNotificationSelector = @selector(moengage_swizzled_application:didReceiveRemoteNotification:fetchCompletionHandler:);
            [self swizzleMethodWithClass:class originalSelector:receivedNotificationSelector andSwizzledSelector:swizzledReceivedNotificationSelector];
        } else if ([delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:)]) {
            SEL receivedNotificationSelector = @selector(application:didReceiveRemoteNotification:);
            SEL swizzledReceivedNotificationSelector = @selector(moengage_swizzled_application:didReceiveRemoteNotification:);
            [self swizzleMethodWithClass:class originalSelector:receivedNotificationSelector andSwizzledSelector:swizzledReceivedNotificationSelector];
        } else {
            SEL receivedNotificationSelector = @selector(application:didReceiveRemoteNotification:);
            SEL swizzledReceivedNotificationSelector = @selector(moengage_swizzled_no_application:didReceiveRemoteNotification:);
            [self swizzleMethodWithClass:class originalSelector:receivedNotificationSelector andSwizzledSelector:swizzledReceivedNotificationSelector];
            
        }
    });
}

#pragma mark- Swizzle Method

+ (void)swizzleMethodWithClass:(Class)class originalSelector:(SEL)originalSelector andSwizzledSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark- Application LifeCycle methods

- (BOOL)moengage_swizzled_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //Add Observer for Life Cycle Events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moengage_applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moengage_applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moengage_applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moengage_applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    [self initializeApplication:application andLaunchOptions:launchOptions];
    return [self moengage_swizzled_application:application didFinishLaunchingWithOptions:launchOptions];
}

-(void)initializeApplication:(UIApplication*)application andLaunchOptions:(NSDictionary*)launchOptions{
    NSString* appID = [self getMoEngageAppID];
    if (appID == nil) {
        return;
    }
    
#ifdef DEBUG
    [[MoEngage sharedInstance] initializeDevWithApiKey:appID inApplication:application withLaunchOptions:launchOptions openDeeplinkUrlAutomatically:YES];
#else
    [[MoEngage sharedInstance] initializeProdWithApiKey:appID inApplication:application withLaunchOptions:launchOptions openDeeplinkUrlAutomatically:YES];
#endif
    
    [MoEngage sharedInstance].delegate = self;
    
    if([application isRegisteredForRemoteNotifications]){
        if (@available(iOS 10.0, *)) {
            [[MoEngage sharedInstance] registerForRemoteNotificationWithCategories:nil withUserNotificationCenterDelegate:self];
        } else {
            [[MoEngage sharedInstance] registerForRemoteNotificationForBelowiOS10WithCategories:nil];
        }
    }
}

-(NSString*)getMoEngageAppID {
    NSString* moeAppID;
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    
    if ( [infoDict objectForKey:MoEngage_DICT_KEY] != nil && [infoDict objectForKey:MoEngage_DICT_KEY] != [NSNull null]) {
        NSDictionary* moeDict = [infoDict objectForKey:MoEngage_DICT_KEY];
        if ([moeDict objectForKey:MoEngage_APP_ID_KEY] != nil && [moeDict objectForKey:MoEngage_APP_ID_KEY] != [NSNull null]) {
            moeAppID = [moeDict objectForKey:MoEngage_APP_ID_KEY];
        }
    }
    
    if (moeAppID.length > 0) {
        return moeAppID;
    }
    else{
        NSLog(@"MoEngage - Provide the APP ID for your MoEngage App in Info.plist for key MoEngage_APP_ID to proceed. To get the AppID login to your MoEngage account, after that go to Settings -> App Settings. You will find the App ID in this screen.");
        return nil;
    }

}

- (void)moengage_applicationWillEnterForeground:(NSNotification*)notif{
}

- (void)moengage_applicationDidBecomeActive:(NSNotification*)notif {
}

- (void)moengage_applicationDidEnterBackground:(NSNotification*)notif {
}

- (void)moengage_applicationWillTerminate:(NSNotification *)notif {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}


#pragma mark- Register For Push methods

- (void)moengage_swizzled_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self moengage_swizzled_application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    [[MoEngage sharedInstance] setPushToken:deviceToken];
    
    NSDictionary* userInfo = @{MoEngage_Device_Token_Key: deviceToken};
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_Registered_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
}

- (void)moengage_swizzled_no_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[MoEngage sharedInstance] setPushToken:deviceToken];
    
    NSDictionary* userInfo = @{MoEngage_Device_Token_Key: deviceToken};
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_Registered_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
}

-(void)moengage_swizzled_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [self moengage_swizzled_application:application didFailToRegisterForRemoteNotificationsWithError:error];
    [[MoEngage sharedInstance]didFailToRegisterForPush];
    
    NSDictionary* userInfo = @{@"error": error};
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_Registration_Failed_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
}


-(void)moengage_swizzled_no_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[MoEngage sharedInstance]didFailToRegisterForPush];

    NSDictionary* userInfo = @{@"error": error};
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_Registration_Failed_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
}

-(void)moengage_swizzled_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [self moengage_swizzled_application:application didRegisterUserNotificationSettings:notificationSettings];
    [[MoEngage sharedInstance]didRegisterForUserNotificationSettings:notificationSettings];
    
    NSDictionary* userInfo = @{MoEngage_Notification_Settings_Key: notificationSettings};
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_UserSettings_Registered_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
}

-(void)moengage_swizzled_no_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [[MoEngage sharedInstance]didRegisterForUserNotificationSettings:notificationSettings];
    
    NSDictionary* userInfo = @{MoEngage_Notification_Settings_Key: notificationSettings};
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_UserSettings_Registered_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
    
}

#pragma mark- Receive Notification methods

- (void)moengage_swizzled_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
        [self moengage_swizzled_application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    }
    
    [[MoEngage sharedInstance] didReceieveNotificationinApplication:application withInfo:userInfo openDeeplinkUrlAutomatically:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_Received_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
    
}

- (void)moengage_swizzled_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self moengage_swizzled_application:application didReceiveRemoteNotification:userInfo];
    [[MoEngage sharedInstance] didReceieveNotificationinApplication:application withInfo:userInfo openDeeplinkUrlAutomatically:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_Received_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
}

- (void)moengage_swizzled_no_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[MoEngage sharedInstance] didReceieveNotificationinApplication:application withInfo:userInfo openDeeplinkUrlAutomatically:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_Received_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
}

#pragma mark- iOS10 UserNotification Framework delegate methods

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler{
    [[MoEngage sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response];
    NSDictionary *pushDictionary = response.notification.request.content.userInfo;
    [self performSelector:@selector(postClickedNotificationWithUserInfo:) withObject:pushDictionary afterDelay:1.0];
    completionHandler();
}

-(void)postClickedNotificationWithUserInfo:(NSDictionary*)pushDictionary{
    if (pushDictionary) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_Received_Notification object:[UIApplication sharedApplication] userInfo:pushDictionary];
    }
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    completionHandler((UNNotificationPresentationOptionSound
                       | UNNotificationPresentationOptionAlert ));
}


#pragma mark- InAppDelegate methods

-(void)inAppShownWithCampaignID:(NSString*)campaignID{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"campaignID" : campaignID}];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppShownNotification" object:nil userInfo:dict];
}

-(void)inAppClickedForWidget:(InAppWidget)widget screenName:(NSString*)screenName andDataDict:(NSDictionary *)dataDict{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    if (dataDict != nil){
        dict[@"screenData"] = dataDict;
    }
    
    if (screenName != nil){
        dict[@"screenName"] = screenName;
    }
    
    NSString* widgetStr = @"";
    switch (widget) {
        case BUTTON:
            widgetStr = @"button";
            break;
        case IMAGE:
            widgetStr = @"image";
            break;
        case LABEL:
            widgetStr = @"label";
            break;
        case CLOSE_BUTTON:
            widgetStr = @"close_button";
            break;
    }
    dict[@"widgetTapped"] = widgetStr;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppClickedNotification" object:nil userInfo:dict];
}

-(void)eventTriggeredInAppAvailableWithData:(id)data{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:data];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EventTriggeredSelfHandledInAppNotification" object:nil userInfo:dict];
}

@end


