//
//  LBSocketManager.m
//  LightBoard
//
//  Created by wulanzhou-mini on 15-1-22.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "LBSocketManager.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

@implementation LBSocketManager
//单例模式
+ (LBSocketManager *)sharedInstance{
    static dispatch_once_t  onceToken;
    static LBSocketManager * sSharedInstance;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[LBSocketManager alloc] init];
    });
    return sSharedInstance;
}
// socket连接
-(void)startConnect{
    self.socket= [[AsyncSocket alloc] initWithDelegate:self];
    NSError *error = nil;
    [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:3 error:&error];
    // [_sendSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}
// socket重新连接
-(void)resetConnect{
    // 在连接前先进行手动断开
    self.socket.userData = SocketOfflineByUser;
    [self closeSocket];
    
    // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
    self.socket.userData = SocketOfflineByServer;
    [self startConnect];
}
// 连接成功回调
#pragma mark  - 连接成功回调
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket连接成功");
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:NO];
    [self.connectTimer fire];
}
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    if ([self.socket isConnected]) {
        NSLog(@"socket连接成功 willDisconnectWithError");
    }
    NSLog(@"socket连接失败,err=%@",err.description);
}
// 心跳连接
-(void)longConnectToSocket{
    
    // 根据服务器要求发送固定格式的数据，假设为指令@"longConnect"，但是一般不会是这么简单的指令
    NSString *longConnect = @"longConnect";
    NSData   *dataStream  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:dataStream withTimeout:1 tag:1];
    
    
}
// 切断socket
-(void)closeSocket{
    self.socket.userData = SocketOfflineByUser;
    [self.connectTimer invalidate];
    [self.socket setDelegate:nil];
    [self.socket disconnect];
    self.socket=nil;
}
-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"sorry the connect is failure %ld",sock.userData);
    if (sock.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
        [self startConnect];
    }
    else if (sock.userData == SocketOfflineByUser) {
        // 如果由用户断开，不进行重连
        return;
    }
}
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"读取数据!!!");
    // 对得到的data值进行解析与转换即可
    [self.socket readDataWithTimeout:30 tag:1];
}
#pragma mark - 所有处理
//打开所有灯
-(void)openAllLamp{
   Byte byte[]={16,255,5};
   NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
   [self.socket writeData:adata withTimeout:5 tag:10];
}
//关闭所有灯
-(void)closeAllLamp{
    Byte byte[]={16,255,0};
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [self.socket writeData:adata withTimeout:5 tag:11];
}
#pragma mark - 群组处理
//打开群组
- (void)openGroupWithID:(Byte)groupid{
   Byte byte[2];
   byte[0]=16;
   byte[1]=128+groupid*2+15;
    
   NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
   [self.socket writeData:adata withTimeout:5 tag:20];
}
//关闭群组
- (void)closeGroupWithID:(Byte)groupid{
    Byte byte[2];
    byte[0]=16;
    byte[1]=128+groupid*2+10;
    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [self.socket writeData:adata withTimeout:5 tag:21];
}
//设置群组亮度
- (void)setGroupBrightnessWithID:(Byte)groupid Brightness:(Byte)brightness{
    Byte byte[3];
    byte[0]=16;
    byte[1]=128+groupid*2;
    byte[2]=254*(brightness/100);
    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [self.socket writeData:adata withTimeout:5 tag:30];
}
//设置群组的亮度的调高
- (void)setGroupBrightnessIncreaseWithID:(Byte)groupid{
    Byte byte[3];
    byte[0]=16;
    byte[1]=128+groupid*2+1;
    byte[2]=1;
    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [self.socket writeData:adata withTimeout:5 tag:31];
}
//设置群组的亮度的调低
- (void)setGroupBrightnessReduceWithID:(Byte)groupid{
    Byte byte[3];
    byte[0]=16;
    byte[1]=128+groupid*2+1;
    byte[2]=2;
    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [self.socket writeData:adata withTimeout:5 tag:32];
}
#pragma mark - 场景处理
//打开场景
-(void)openSceneWithID:(Byte)sceneid{
    Byte byte[3];
    byte[0]=16;
    byte[1]=255;
    byte[2]=16+sceneid;
    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [self.socket writeData:adata withTimeout:5 tag:40];
}
@end
