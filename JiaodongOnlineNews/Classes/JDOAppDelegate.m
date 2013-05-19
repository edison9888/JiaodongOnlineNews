//
//  JDOAppDelegate.m
//  JiaodongOnlineNews
//
//  Created by zhang yi on 13-5-10.
//  Copyright (c) 2013年 胶东在线. All rights reserved.
//

#import "JDOAppDelegate.h"

#import "JDOViewController.h"

@implementation JDOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 异步加载广告页
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, nil), ^{
        NSString *advUrl = [SERVER_URL stringByAppendingString:ADV_SERVICE];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:advUrl]];
        NSError *error ;
        NSData *jsonResult = [NSData dataWithContentsOfFile:advUrl options:NSDataReadingUncached error:&error];
        if(error != nil){
            NSLog(@"获取广告页json出错:%@",error);
            return;
        }
        
    });
    
    // 停止splash，同时加载广告页
    [NSThread sleepForTimeInterval:3.0];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, nil), ^{
        NSError *error;
        [NSData dataWithContentsOfURL:@"" options:NSDataReadingUncached error:&error];
    });
    
    
    
    // Override point for customization after application launch.
    self.viewController = [[JDOViewController alloc] initWithNibName:@"JDOViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end