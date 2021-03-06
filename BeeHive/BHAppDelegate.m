/**
 * Created by BeeHive.
 * Copyright (c) 2016, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the GNU GENERAL PUBLIC LICENSE.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import "BHAppDelegate.h"
#import "BeeHive.h"
#import "BHModuleManager.h"
#import "BHTimeProfiler.h"

@interface BHAppDelegate ()

@property (nonatomic, strong) BHTimeProfiler *timeProdiler;

@end

@implementation BHAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef DEBUG
    self.timeProdiler = [BHTimeProfiler sharedTimeProfiler];
#endif
    
    [[BHModuleManager sharedManager] tiggerEvent:BHMSetupEvent];
    [[BHModuleManager sharedManager] tiggerEvent:BHMInitEvent];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[BHModuleManager sharedManager] tiggerEvent:BHMSplashEvent];
    });
    
#ifdef DEBUG
    [self.timeProdiler printOutTimeProfileResult];
    [self.timeProdiler saveTimeProfileDataIntoFile:@"BeeHiveTimeProfiler"];
#endif
    
    return YES;
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400 

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
  
    [[BeeHive shareInstance].context.touchShortcutItem setShortcutItem: shortcutItem];
    [[BeeHive shareInstance].context.touchShortcutItem setScompletionHandler: completionHandler];
    [[BHModuleManager sharedManager] tiggerEvent:BHMQuickActionEvent];
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[BHModuleManager sharedManager] tiggerEvent:BHMWillResignActiveEvent];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[BHModuleManager sharedManager] tiggerEvent:BHMDidEnterBackgroundEvent];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[BHModuleManager sharedManager] tiggerEvent:BHMWillEnterForegroundEvent];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[BHModuleManager sharedManager] tiggerEvent:BHMDidBecomeActiveEvent];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[BHModuleManager sharedManager] tiggerEvent:BHMWillTerminateEvent];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[BeeHive shareInstance].context.openURLItem setOpenURL:url];
    [[BeeHive shareInstance].context.openURLItem setSourceApplication:sourceApplication];
    [[BHModuleManager sharedManager] tiggerEvent:BHMOpenURLEvent];
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
  
    [[BeeHive shareInstance].context.openURLItem setOpenURL:url];
    [[BeeHive shareInstance].context.openURLItem setOptions:options];
    [[BHModuleManager sharedManager] tiggerEvent:BHMOpenURLEvent];
    return YES;
}
#endif


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[BHModuleManager sharedManager] tiggerEvent:BHMDidReceiveMemoryWarningEvent];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[BeeHive shareInstance].context.notificationsItem setNotificationsError:error];
    [[BHModuleManager sharedManager] tiggerEvent:BHMDidFailToRegisterForRemoteNotificationsEvent];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[BeeHive shareInstance].context.notificationsItem setDeviceToken: deviceToken];
    [[BHModuleManager sharedManager] tiggerEvent:BHMDidRegisterForRemoteNotificationsEvent];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[BeeHive shareInstance].context.notificationsItem setUserInfo: userInfo];
    [[BHModuleManager sharedManager] tiggerEvent:BHMDidReceiveRemoteNotificationEvent];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[BeeHive shareInstance].context.notificationsItem setUserInfo: userInfo];
    [[BeeHive shareInstance].context.notificationsItem setNotifciationResultHander: completionHandler];
    [[BHModuleManager sharedManager] tiggerEvent:BHMDidReceiveRemoteNotificationEvent];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[BeeHive shareInstance].context.notificationsItem setLocalNotification: notification];
    [[BHModuleManager sharedManager] tiggerEvent:BHMDidReceiveLocalNotificationEvent];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80000
- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity
{
    if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
        [[BeeHive shareInstance].context.userActivityItem setUserActivity: userActivity];
        [[BHModuleManager sharedManager] tiggerEvent:BHMDidUpdateUserActivityEvent];
    }
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error
{
    if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
        [[BeeHive shareInstance].context.userActivityItem setUserActivityType: userActivityType];
        [[BeeHive shareInstance].context.userActivityItem setUserActivityError: error];
        [[BHModuleManager sharedManager] tiggerEvent:BHMDidFailToContinueUserActivityEvent];
    }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
        [[BeeHive shareInstance].context.userActivityItem setUserActivity: userActivity];
        [[BeeHive shareInstance].context.userActivityItem setRestorationHandler: restorationHandler];
        [[BHModuleManager sharedManager] tiggerEvent:BHMContinueUserActivityEvent];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType
{
    if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
        [[BeeHive shareInstance].context.userActivityItem setUserActivityType: userActivityType];
        [[BHModuleManager sharedManager] tiggerEvent:BHMWillContinueUserActivityEvent];
    }
    return YES;
}
#endif

@end

@implementation BHOpenURLItem

@end

@implementation BHShortcutItem

@end

@implementation BHUserActivityItem

@end

@implementation BHNotificationsItem

@end
