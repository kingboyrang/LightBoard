//
//  SettingLightViewController.m
//  LightBoard
//
//  Created by rang on 15-1-24.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "SettingLightViewController.h"
#import "SettingTableViewCell.h"
#import "LightAreaGroup.h"
#import "LightScenes.h"
#import "UIBarButtonItem+TPCategory.h"
#import "LBSocketManager.h"
@interface SettingLightViewController ()

@end

@implementation SettingLightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedArray=[[NSMutableDictionary alloc] initWithCapacity:0];
    
    LightScenes *model=[[LightScenes alloc] init];
    model.scenename=@"All Cancel";
    model.name=@"All Cancel";
    [self.lightSences insertObject:model atIndex:0];
    
    model=[[LightScenes alloc] init];
    model.scenename=@"All Select";
    model.name=@"All Select";
    [self.lightSences insertObject:model atIndex:0];
    
    
     self.navigationItem.rightBarButtonItem=[UIBarButtonItem barButtonWithTitle:@"设置" target:self action:@selector(titleShowPopover) forControlEvents:UIControlEventTouchUpInside];
    
    // popover view
    //self.view.bounds.size.width-160-10
    self.popTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 160, 250) style:UITableViewStylePlain];
    self.popTableView.dataSource=self;
    self.popTableView.delegate=self;
    self.popTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.popover = [DXPopover new];
    
    self.title=self.areaEntity.name;
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
    };
}
- (void)bounceTargetView:(UIView *)targetView
{
    targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        targetView.transform = CGAffineTransformIdentity;
    } completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)openClick:(id)sender {
    if([self.selectedArray count]>0){
        for (NSString *item in self.selectedArray.allKeys) {
            LightAreaGroup *model=[self.areaEntity.groups objectAtIndex:[item integerValue]];
            [[LBSocketManager sharedInstance] openGroupWithID:[model.groupid integerValue]];
        }
    }
}

- (IBAction)closeClick:(id)sender {
    if([self.selectedArray count]>0){
        for (NSString *item in self.selectedArray.allKeys) {
            LightAreaGroup *model=[self.areaEntity.groups objectAtIndex:[item integerValue]];
            [[LBSocketManager sharedInstance] closeGroupWithID:[model.groupid integerValue]];
        }
    }
}

- (IBAction)upClick:(id)sender {
    if([self.selectedArray count]>0){
        for (NSString *item in self.selectedArray.allKeys) {
            LightAreaGroup *model=[self.areaEntity.groups objectAtIndex:[item integerValue]];
            [[LBSocketManager sharedInstance] setGroupBrightnessIncreaseWithID:[model.groupid integerValue]];
        }
    }
    
}

- (IBAction)downClick:(id)sender {
    if([self.selectedArray count]>0){
        for (NSString *item in self.selectedArray.allKeys) {
            LightAreaGroup *model=[self.areaEntity.groups objectAtIndex:[item integerValue]];
            [[LBSocketManager sharedInstance] setGroupBrightnessReduceWithID:[model.groupid integerValue]];
        }
    }
}

- (IBAction)brightnessClick:(id)sender {
    UIButton *btn=(UIButton*)sender;
    NSInteger index=btn.tag-100;
    if([self.selectedArray count]>0){
        for (NSString *item in self.selectedArray.allKeys) {
            LightAreaGroup *model=[self.areaEntity.groups objectAtIndex:[item integerValue]];
            [[LBSocketManager sharedInstance] setGroupBrightnessWithID:[model.groupid integerValue] Brightness:index];
        }
    }
    
}
//选中事件
- (void)checkboxClick:(UIButton*)btn{
    btn.selected=!btn.selected;
    NSString *index=[NSString stringWithFormat:@"%d",btn.tag-100];
    if (btn.selected) {
        if (![self.selectedArray.allKeys containsObject:index]) {
            [self.selectedArray setValue:index forKey:index];
        }
    }else{
        [self.selectedArray removeObjectForKey:index];
    }
}
#pragma mark - table source & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.popTableView) {
        return [self.lightSences count];
    }
    return [self.areaEntity.groups count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.popTableView) {
     static  NSString *cellDefaultId = @"cellDefaultId";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellDefaultId];
        
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDefaultId];
            UIView * _separateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49.5, self.view.bounds.size.width, 0.5)];
            [_separateLine setBackgroundColor:kSeparateLineColor];
            [cell.contentView addSubview:_separateLine];
            
        }
        LightScenes *entity=[self.lightSences objectAtIndex:indexPath.row];
        cell.textLabel.text=entity.scenename;
        cell.textLabel.font=kAppShowFont;
        return cell;
    }
    
    static NSString *cellId = @"areagroupIdentifier";
    SettingTableViewCell *cell =(SettingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SettingTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.checkBtn.tag=100+indexPath.row;
        [cell.checkBtn addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    LightAreaGroup *entity=[self.areaEntity.groups objectAtIndex:indexPath.row];
    cell.labName.text=entity.groupname;
    NSString *selectedIndex=[NSString stringWithFormat:@"%d",indexPath.row];
    if ([self.selectedArray.allKeys containsObject:selectedIndex]) {
        cell.checkBtn.selected=YES;
    }else{
        cell.checkBtn.selected=NO;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.popTableView==tableView) {
        return 50.0;
    }
    return 60.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==self.popTableView) {
        [self.popover dismiss];
        if (indexPath.row==0) {//全选
            [self.selectedArray removeAllObjects];
            for (NSInteger i=0;i<self.areaEntity.groups.count;i++) {
                [self.selectedArray setValue:[NSString stringWithFormat:@"%d",i] forKey:[NSString stringWithFormat:@"%d",i]];
            }
            [self.settingTableView reloadData];
        }else if (indexPath.row==1){//反选
            [self.selectedArray removeAllObjects];
            [self.settingTableView reloadData];
        }else{
            //打开场景
             LightScenes *entity=[self.lightSences objectAtIndex:indexPath.row];
            [[LBSocketManager sharedInstance] openSceneWithID:[entity.sceneid integerValue]];
        }
    }
}
@end
