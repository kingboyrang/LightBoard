//
//  UCSUserDefaultManager.h
//  UCSVoipDemo
//
//  Created by tongkucky on 14-6-26.
//  Copyright (c) 2014年 UCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCSUserDefaultManager : NSObject

+ (NSString *) GetLocalDataString:(NSString *)aKey;
+ (void)setLocalDataString:(NSString *)aValue key:(NSString *)aKey;
+ (id) GetLocalDataObject:(NSString *)aKey;
+ (void) SetLocalDataObject:(id)aValue key:(NSString *)aKey;
+ (bool) GetLocalDataBoolen:(NSString *)aKey;
+ (void) SetLocalDataBoolen:(bool)bValue key:(NSString *)aKey;
+ (void) removeForKey:(NSString*)key;
@end
