//
//  LBSocketManager.h
//  LightBoard
//
//  Created by wulanzhou-mini on 15-1-22.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "LightWIFI.h"
enum{
    SocketOfflineByServer,
    SocketOfflineByUser,
};

@interface LBSocketManager : NSObject<AsyncSocketDelegate>
@property (nonatomic, strong) AsyncSocket    *socket;       // socket
@property (nonatomic, copy  ) NSString       *socketHost;   // socket的Host
@property (nonatomic, assign) UInt16         socketPort;    // socket的prot

@property (nonatomic, retain) NSTimer        *connectTimer; // 计时器
//单例模式
+ (LBSocketManager *)sharedInstance;

//打开连接(根据wifi连接来处理)
-(void)startConnectWithWIFI:(LightWIFI*)model;

-(void)startConnect;// socket连接
-(void)resetConnect;// socket重新连接

-(void)closeSocket;// 断开socket连接

/*******************所有控制*********************/
//打开所有灯
-(void)openAllLamp;
//关闭所有灯
-(void)closeAllLamp;

/*******************群组控制*********************/
//打开群组
- (void)openGroupWithID:(Byte)groupid;
//关闭群组
- (void)closeGroupWithID:(Byte)groupid;
//设置群组亮度
- (void)setGroupBrightnessWithID:(Byte)groupid Brightness:(Byte)brightness;
//设置群组的亮度的调高
- (void)setGroupBrightnessIncreaseWithID:(Byte)groupid;
//设置群组的亮度的调低
- (void)setGroupBrightnessReduceWithID:(Byte)groupid;

/*******************场景控制*********************/
//打开场景
-(void)openSceneWithID:(Byte)sceneid;
@end
