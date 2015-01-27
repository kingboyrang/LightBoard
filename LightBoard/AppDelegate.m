//
//  AppDelegate.m
//  LightBoard
//
//  Created by wulanzhou-mini on 15-1-19.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "AppDelegate.h"
#import "LBSocketManager.h"
#import "LightWIFIManager.h"
#import "UCSUserDefaultManager.h"

#define HOST @"www.paypal.com"
#define PORT 443

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    Byte byte[] = {16,255,5};
    NSData *adata = [[NSData alloc] initWithBytes:byte length:3];
    adata=[NSData data];
    NSLog(@"adata=%@",adata);
    NSString *str=[[NSString alloc] initWithData:adata encoding:NSUTF8StringEncoding];
    NSLog(@"str=%@",str);
    
    LBSocketManager *manager=[LBSocketManager sharedInstance];
    manager.socketHost=HOST;
    manager.socketPort=PORT;
    [manager startConnect];
    
   [[UINavigationBar appearance] setTintColor:kNavTitleColor];
    
    // Override point for customization after application launch.
    // 注册苹果推送，申请推送权限。
    /***
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge                                    |UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeSound];
    }
     ***/
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if (url != nil && [url isFileURL]) {
        NSString *str1 = @"Documents";
        NSRange rang=[[url path] rangeOfString:str1];
        if (rang.location != NSNotFound) {
           
            NSString *path1=[[url path] substringFromIndex:rang.location+str1.length];
            NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *path=[documentPath stringByAppendingPathComponent:path1];
            [UCSUserDefaultManager setLocalDataString:path key:kDataKeyXmlPath];
        }else{
            [UCSUserDefaultManager setLocalDataString:[url path] key:kDataKeyXmlPath];
        }
         //解析与读取文件
        [[LightWIFIManager sharedInstance] loadXmlWithFilePath:[url path]];
        //[self.viewController handleDocumentOpenURL:url];
    }
    return YES;
}
@end
