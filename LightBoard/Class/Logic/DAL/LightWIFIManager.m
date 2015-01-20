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
        /***
        NSString *path=[[NSBundle mainBundle] pathForResource:@"wifi" ofType:@"xml"];
        NSString *xml=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        self.xmlparse=[[XmlParseHelper alloc] initWithData:xml];
        
        NSArray *nodes=nil;
        self.wifis=[self.xmlparse selectNodes:@"//Wifi" forObject:[LightWIFI class] outNodes:&nodes];
        if (nodes) {
            NSInteger index=0;
            for (GDataXMLNode *node in nodes) {
                LightWIFI *item=[self.wifis objectAtIndex:index];
                
                item.areas=[self.xmlparse selectChildsNodesToObjects:node xpath:@"//Area" forObject:[LightArea class]];
                item.scenes=[self.xmlparse selectChildsNodesToObjects:node xpath:@"//Scene" forObject:[LightScenes class]];
                index++;
            }
        }
        ***/
        
    }
    return self;
}
- (void)loadXml{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"wifi" ofType:@"xml"];
    NSString *xml=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
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
    //return array;
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
