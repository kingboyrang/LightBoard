//
//  FileInfo.h
//  LightBoard
//
//  Created by wulanzhou-mini on 15-1-26.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileInfo : NSObject
@property (nonatomic,strong) NSDate *fileModDate;//文件修改日期
@property (nonatomic,strong) NSString *path;//文件路径
@end
