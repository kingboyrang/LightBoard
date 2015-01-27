//
//  LightScenes.h
//  LightBoard
//
//  Created by wulanzhou-mini on 15-1-19.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LightScenes : NSObject
@property (nonatomic,copy) NSString *sceneid;
@property (nonatomic,copy) NSString *wifiname;
@property (nonatomic,copy) NSString *scenename;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *zonename;
@property (nonatomic,copy) NSString *areaName;
@property (nonatomic,retain) NSArray *grouplist;
@end
