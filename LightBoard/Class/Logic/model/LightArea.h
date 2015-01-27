//
//  LightGroup.h
//  LightBoard
//
//  Created by wulanzhou-mini on 15-1-19.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LightArea : NSObject
@property (nonatomic,copy) NSString *wifiname;
@property (nonatomic,copy) NSString *zonename;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,retain) NSArray *groups;
@end
