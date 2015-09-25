//
//  AppDelegate.m
//  DemoBackgroundSession
//
//  Created by Александр О. Кургин on 21.09.15.
//  Copyright (c) 2015 Yandex.Money. All rights reserved.
//

#import "AppDelegate.h"
#import "YMViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    UIViewController *rootViewController = self.window.rootViewController;
    if ([rootViewController isKindOfClass:[YMViewController class]]) {
        YMViewController *viewController = (YMViewController *)rootViewController;
        viewController.backgroundSessionCompletionHandler = completionHandler;
    }
}



@end
