//
//  AreaGroupViewController.m
//  LightBoard
//
//  Created by wulanzhou-mini on 15-1-20.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "AreaGroupViewController.h"
#import "AreaGroupCell.h"
#import "LightAreaGroup.h"
#import "LightScenes.h"
#import "UIBarButtonItem+TPCategory.h"
#import "SettingLightViewController.h"
#import "LBSocketManager.h"
#define SourceDefaultData [NSArray arrayWithObjects:@"Turn On All",@"Turn Off All",@"Brightness",@"Scene",@"Setting", nil]
#define SourceBrightnessData [NSArray arrayWithObjects:@"10%",@"25%",@"50%",@"50%",@"75%", nil]

@implementation AreaGroupViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedArray=[[NSMutableDictionary alloc] initWithCapacity:0];
    self.sourceType=AreaGroupSourceDefault;
    self.areaTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem barButtonWithTitle:@"设置" target:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
    
    // popover view
    //self.view.bounds.size.width-160-10
    self.popTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 160, 260) style:UITableViewStylePlain];
    self.popTableView.dataSource=self;
    self.popTableView.delegate=self;
    self.popTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.popover = [DXPopover new];
    
    self.title=self.areaEntity.name;
    
}
//重写
-(BOOL)isNavigationBack{
    //断开连接
    [[LBSocketManager sharedInstance] closeSocket];
    return YES;
}
//设置
- (void)settingClick{
    [self titleShowPopover];
}
//是否开启
- (void)lightOnOffChange:(UISwitch*)swith{
    NSString *index=[NSString stringWithFormat:@"%d",swith.tag-100];
    if (swith.on) {
        if (![self.selectedArray.allKeys containsObject:index]) {
            [self.selectedArray setValue:index forKey:index];
            LightAreaGroup *model=[self.areaEntity.groups objectAtIndex:[index integerValue]];
            [[LBSocketManager sharedInstance] openGroupWithID:[model.groupid integerValue]];
        }
    }else{
        [self.selectedArray removeObjectForKey:index];
        LightAreaGroup *model=[self.areaEntity.groups objectAtIndex:[index integerValue]];
        [[LBSocketManager sharedInstance] closeGroupWithID:[model.groupid integerValue]];
    }
}
#pragma mark - popover show
- (void)titleShowPopover
{
    UIView *titleView = self.navigationItem.rightBarButtonItem.customView;
    CGPoint startPoint = CGPointMake(CGRectGetMidX(titleView.frame), CGRectGetMaxY(titleView.frame) + 20);
    
    [self.popover showAtPoint:startPoint popoverPostion:DXPopoverPositionDown withContentView:self.popTableView inView:self.navigationController.view];
    __weak typeof(self)weakSelf = self;
    self.popover.didDismissHandler = ^{
        [weakSelf bounceTargetView:titleView];
        weakSelf.sourceType=AreaGroupSourceDefault;
        [weakSelf.popTableView reloadData];
    };
}
- (void)bounceTargetView:(UIView *)targetView
{
    targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        targetView.transform = CGAffineTransformIdentity;
    } completion:nil];
}
#pragma mark - table source & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.popTableView==tableView) {
        if (self.sourceType==AreaGroupSourceDefault) {
            return [SourceDefaultData count];
        }else if(self.sourceType==AreaGroupSourceBrightness){
            return [SourceBrightnessData count];
        }else if (self.sourceType==AreaGroupSourceScene){
            return [self.lightSences count];
        }
    }
    return [self.areaEntity.groups count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.popTableView==tableView) {
        NSString *cellDefaultId = [NSString stringWithFormat:@"cellDefaultId%d",self.sourceType];
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellDefaultId];
        
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDefaultId];
            UIView * _separateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49.5, self.view.bounds.size.width, 0.5)];
            [_separateLine setBackgroundColor:kSeparateLineColor];
            [cell.contentView addSubview:_separateLine];

        }
        //LightWIFI *model=[self.wifis objectAtIndex:indexPath.row];
        if (self.sourceType==AreaGroupSourceDefault) {
           cell.textLabel.text = [SourceDefaultData objectAtIndex:indexPath.row];
        }else if (self.sourceType==AreaGroupSourceBrightness)
        {
            cell.textLabel.text = [SourceBrightnessData objectAtIndex:indexPath.row];
        }else if (self.sourceType==AreaGroupSourceScene){
            LightScenes *entity=[self.lightSences objectAtIndex:indexPath.row];
            cell.textLabel.text=entity.scenename;
            NSLog(@"name =%@",entity.scenename);
        }
        
        cell.textLabel.font=kAppShowFont;
        return cell;
    }
    
    static NSString *cellId = @"areagroupIdentifier";
    AreaGroupCell *cell =(AreaGroupCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AreaGroupCell" owner:self options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.labName.font=kAppShowFont;
        cell.labLine.backgroundColor=kSeparateLineColor;
        
        CGRect r=cell.labLine.frame;
        r.size.height=0.5;
        r.origin.y=60-r.size.height;
        cell.labLine.frame=r;
        
        cell.areaSwitch.tag=100+indexPath.row;
        [cell.areaSwitch addTarget:self action:@selector(lightOnOffChange:) forControlEvents:UIControlEventValueChanged];
    }
    LightAreaGroup *entity=[self.areaEntity.groups objectAtIndex:indexPath.row];
    cell.labName.text=entity.groupname;
    NSString *selectedIndex=[NSString stringWithFormat:@"%d",indexPath.row];
    if ([self.selectedArray.allKeys containsObject:selectedIndex]) {
        cell.areaSwitch.on=YES;
    }else{
        cell.areaSwitch.on=NO;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.popTableView==tableView){
        return 50.0;
    }
    return 60.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.popTableView) {
        
        if (self.sourceType==AreaGroupSourceDefault&&(indexPath.row!=2&&indexPath.row!=3)) {
            [self.popover dismiss];
        }
        //默认数据源
        if (self.sourceType==AreaGroupSourceDefault) {
            if (indexPath.row==0) {//打开所有
                [self.selectedArray removeAllObjects];
                for (NSInteger i=0;i<self.areaEntity.groups.count;i++) {
                    [self.selectedArray setValue:[NSString stringWithFormat:@"%d",i] forKey:[NSString stringWithFormat:@"%d",i]];
                }
                [self.areaTableView reloadData];
                [[LBSocketManager sharedInstance] openAllLamp];
            }else if (indexPath.row==1){//关闭所有
                [self.selectedArray removeAllObjects];
                [self.areaTableView reloadData];
                [[LBSocketManager sharedInstance] closeAllLamp];
            }
            else if (indexPath.row==2) {//亮度
                self.sourceType=AreaGroupSourceBrightness;
                [self.popTableView reloadData];
                [self titleShowPopover];
            }else if (indexPath.row==3){//场景
                self.sourceType=AreaGroupSourceScene;
                [self.popTableView reloadData];
                [self titleShowPopover];
            }else if (indexPath.row==4){//设置
                SettingLightViewController *setting=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingLightVC"];
                setting.areaEntity=self.areaEntity;
                
                NSMutableArray *source=[NSMutableArray arrayWithCapacity:0];
                if (self.lightSences&&[self.lightSences count]>0) {
                    [source addObjectsFromArray:self.lightSences];
                }
                setting.lightSences=source;
                [self.navigationController pushViewController:setting animated:YES];
            }
        }
        //亮度
        if (self.sourceType==AreaGroupSourceBrightness) {
            NSString *birght=[SourceBrightnessData objectAtIndex:indexPath.row];
            birght=[birght stringByReplacingOccurrencesOfString:@"%" withString:@""];
            for (NSString *item in self.selectedArray.allKeys) {
                LightAreaGroup *model=[self.areaEntity.groups objectAtIndex:[item integerValue]];
                [[LBSocketManager sharedInstance] setGroupBrightnessWithID:[model.groupid integerValue] Brightness:[birght integerValue]];
            }
            
        }
        //场景
        if (self.sourceType==AreaGroupSourceBrightness) {
            LightScenes *entity=[self.lightSences objectAtIndex:indexPath.row];
            [[LBSocketManager sharedInstance] openSceneWithID:[entity.sceneid integerValue]];
        }
    }
}
@end
