//
//  WifiManger.h
//  LightBoard
//
//  Created by wulanzhou-mini on 15-1-20.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WifiManger : NSObject
//单例模式
+ (WifiManger *)sharedInstance;
- (NSString *)getWifiName;
@end
