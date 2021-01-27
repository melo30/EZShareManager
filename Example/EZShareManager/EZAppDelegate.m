//
//  EZAppDelegate.m
//  EZShareManager
//
//  Created by melo30 on 01/15/2021.
//  Copyright (c) 2021 melo30. All rights reserved.
//

#import "EZAppDelegate.h"
#import <ShareSDK/ShareSDK.h>

@implementation EZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //QQ
        [platformsRegister setupQQWithAppId:@"101565838" appkey:@"" enableUniversalLink:YES universalLink:@"https://1xivm.share2dlink.com/qq_conn/101565838"];
        
        //更新到4.3.3或者以上版本，微信初始化需要使用以下初始化
        [platformsRegister setupWeChatWithAppId:@"wx9707f3430c9b321c" appSecret:@"726e7f836849e27e8d46aab0e6ab41f8" universalLink:@"https://1xivm.share2dlink.com/"];
        //新浪
        [platformsRegister setupSinaWeiboWithAppkey:@"2588225579" appSecret:@"f59bcc85ad6d693b729083fb3c21609e" redirectUrl: @"http://www.manjiwang.com" universalLink:@"https://1xivm.share2dlink.com/"];

    }];
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
