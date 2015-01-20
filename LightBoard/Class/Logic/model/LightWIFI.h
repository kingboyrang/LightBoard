//
//  LightWIFI.h
//  LightBoard
//
//  Created by wulanzhou-mini on 15-1-19.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LightArea.h"
#import "LightScenes.h"
@interface LightWIFI : NSObject
@property (nonatomic,copy) NSString *wifiname;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *port;
@property (nonatomic,retain) NSArray *areas;
@property (nonatomic,retain) NSArray *scenes;
@end
