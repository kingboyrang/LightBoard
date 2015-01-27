//
//  LightWIFIManager.m
//  LightBoard
//
//  Created by wulanzhou-mini on 15-1-19.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "LightWIFIManager.h"
#import "XmlParseHelper.h"
#import "LightArea.h"
#import "LightScenes.h"
#import "GDataXMLNode.h"
#import "LightScenesGroup.h"
#import "LightAreaGroup.h"
#import "UCSUserDefaultManager.h"
#import "FileInfo.h"
@interface LightWIFIManager()
@property (nonatomic,strong) XmlParseHelper *xmlparse;
@end

@implementation LightWIFIManager
//单例模式
+ (LightWIFIManager *)sharedInstance{
    static dispatch_once_t  onceToken;
    static LightWIFIManager * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[LightWIFIManager alloc] init];
    });
    return sSharedInstance;
}
- (id)init{
    if (self=[super init]) { 
    }
    return self;
}
- (void)loadXmlWithFilePath:(NSString*)path{
   
    NSError *readError=nil;
    NSString *xml=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&readError];
    if (readError) {
        NSLog(@"readError =%@",readError.description);
        return;
    }
   
    
    NSError *error=nil;
    GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
    if (error) {
        return;
    }
    GDataXMLElement* rootNode = [document rootElement];
    NSArray *childs=[rootNode nodesForXPath:@"//Wifi" error:nil];
    NSMutableArray *results=[[NSMutableArray alloc] initWithCapacity:0];
    for (GDataXMLNode *item in childs){
        [results addObject:[self getNodeToWifi:item]];
        //[array addObject:[self childsNodeToObject:item forObject:cls]];
    }
    
    self.wifis=results;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoadXmlFinished object:nil userInfo:nil];
}
- (NSArray*) allFilesAtPath:(NSString*) direString {
    NSMutableArray *pathArray = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *tempArray = [fileManager contentsOfDirectoryAtPath:direString error:nil];
    for (NSString *fileName in tempArray) {
        BOOL flag = YES;
        NSString *fullPath = [direString stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                if ([[[fileName pathExtension] lowercaseString] isEqualToString:@"xml"]) {
                    FileInfo *model=[[FileInfo alloc] init];
                    model.path=fullPath;
                    //attributesOfItemAtPath
                    NSDictionary *fileAttributes= [fileManager attributesOfItemAtPath:fullPath error:nil];
                    //NSDictionary *fileAttributes=[fileManager fileAttributesAtPath:fullPath traverseLink:YES];
                    //修改日期
                    model.fileModDate=[fileAttributes objectForKey:NSFileModificationDate];
                    [pathArray addObject:model];
                }
            }
            else {
                [pathArray addObjectsFromArray:[self allFilesAtPath:fullPath]];
                //[pathArray addObject:[self allFilesAtPath:fullPath]];
            }
        }
    }
    
    return pathArray;
}
- (void)loadDataSource{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *path=[UCSUserDefaultManager GetLocalDataString:kDataKeyXmlPath];
    NSLog(@"path =%@",path);
    if (path&&[path length]>0&&[fileManager fileExistsAtPath:path]) {
        [self loadXmlWithFilePath:path];
    }else{//向document目录里面查找
        NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *levelList =[self allFilesAtPath:documentPath];
        //排序处理
        NSComparator cmptr = ^(id obj1, id obj2){
            FileInfo *model1=(FileInfo*)obj1;
            FileInfo *model2=(FileInfo*)obj2;
            return [model2.fileModDate compare:model1.fileModDate];
        };
        levelList=[levelList sortedArrayUsingComparator:cmptr];
        if (levelList&&[levelList count]>0) {
            FileInfo *info=(FileInfo*)[levelList objectAtIndex:0];
            [UCSUserDefaultManager setLocalDataString:info.path key:kDataKeyXmlPath];
            [self loadXmlWithFilePath:info.path];
        }
        
    }
}
- (void)loadXml{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"wifi" ofType:@"xml"];
    [self loadXmlWithFilePath:path];
}
- (NSArray*)getAreasGroupWithNode:(GDataXMLNode*)node{
    NSMutableArray *arr=[NSMutableArray arrayWithCapacity:0];
    NSArray *childs=[node children];
    for (GDataXMLNode *item in childs){
        NSArray *subChilds=[item children];
        LightAreaGroup *model=[[LightAreaGroup alloc] init];
        for (GDataXMLNode *subitem in subChilds) {
            SEL sel=NSSelectorFromString(subitem.name);
            if ([model respondsToSelector:sel]) {
                [model setValue:[subitem stringValue] forKey:subitem.name];
            }
        }
        [arr addObject:model];
    }
    return arr;
}
- (NSArray*)getAreasWithNode:(GDataXMLNode*)node{
    NSMutableArray *arr=[NSMutableArray arrayWithCapacity:0];
    NSArray *childs=[node children];
    for (GDataXMLNode *item in childs){
        NSArray *subChilds=[item children];
        LightArea *model=[[LightArea alloc] init];
        for (GDataXMLNode *subitem in subChilds) {
            if ([subitem.name isEqual:@"groups"]) {
                model.groups=[self getAreasGroupWithNode:subitem];
                continue;
            }
            SEL sel=NSSelectorFromString(subitem.name);
            if ([model respondsToSelector:sel]) {
                [model setValue:[subitem stringValue] forKey:subitem.name];
            }
        }
        [arr addObject:model];
    }
    return arr;
}
- (NSArray*)getScenesGroupWithNode:(GDataXMLNode*)node{
    NSMutableArray *arr=[NSMutableArray arrayWithCapacity:0];
    NSArray *childs=[node children];
    for (GDataXMLNode *item in childs){
        NSArray *subChilds=[item children];
        LightScenesGroup *model=[[LightScenesGroup alloc] init];
        for (GDataXMLNode *subitem in subChilds) {
            SEL sel=NSSelectorFromString(subitem.name);
            if ([model respondsToSelector:sel]) {
                [model setValue:[subitem stringValue] forKey:subitem.name];
            }
        }
        [arr addObject:model];
    }
    return arr;
}
- (NSArray*)getScenesWithNode:(GDataXMLNode*)node{
    NSMutableArray *arr=[NSMutableArray arrayWithCapacity:0];
    NSArray *childs=[node children];
    for (GDataXMLNode *item in childs){
        NSArray *subChilds=[item children];
        LightScenes *model=[[LightScenes alloc] init];
        for (GDataXMLNode *subitem in subChilds) {
            if ([subitem.name isEqualToString:@"groups"]) {
                model.grouplist=[self getScenesGroupWithNode:subitem];
                continue;
            }
            SEL sel=NSSelectorFromString(subitem.name);
            if ([model respondsToSelector:sel]) {
                [model setValue:[subitem stringValue] forKey:subitem.name];
            }
        }
        [arr addObject:model];
    }
    return arr;
}
- (LightWIFI*)getNodeToWifi:(GDataXMLNode*)node{
    NSArray *childs=[node children];
    LightWIFI *model=[[LightWIFI alloc] init];
    for (GDataXMLNode *item in childs) {
        if ([item.name isEqualToString:@"areas"]) {
            model.areas=[self getAreasWithNode:item];
            continue;
        }
        if ([item.name isEqualToString:@"scenes"]) {
            model.scenes=[self getScenesWithNode:item];
            continue;
        }
        SEL sel=NSSelectorFromString(item.name);
        if ([model respondsToSelector:sel]) {
            [model setValue:[item stringValue] forKey:item.name];
        }
    }
    return model;
}
@end
