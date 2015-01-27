//
//  LightWIFIManager.h
//  LightBoard
//
//  Created by wulanzhou-mini on 15-1-19.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LightWIFI.h"

#define kNotificationLoadXmlFinished @"kNotificationLoadXmlFinished"

@interface LightWIFIManager : NSObject
@property (nonatomic,strong) NSArray *wifis;
//单例模式
+ (LightWIFIManager *)sharedInstance;
- (void)loadXml;
- (void)loadDataSource;
- (void)loadXmlWithFilePath:(NSString*)path;
@end
