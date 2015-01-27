//
//  WifiManger.m
//  LightBoard
//
//  Created by wulanzhou-mini on 15-1-20.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "WifiManger.h"
#import <SystemConfiguration/CaptiveNetwork.h>
@implementation WifiManger
//单例模式
+ (WifiManger *)sharedInstance{
    static dispatch_once_t  onceToken;
    static WifiManger * sSharedInstance;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[WifiManger alloc] init];
    });
    return sSharedInstance;
}
- (NSString *)getWifiName
{
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    return wifiName;
}
@end
