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
#import "UIBarButtonItem+TPCategory.h"
@implementation AreaGroupViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sourceType=AreaGroupSourceDefault;
    self.areaTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem barButtonWithTitle:@"设置" target:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
    
    // popover view
    self.popTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 160, 250) style:UITableViewStylePlain];
    self.popTableView.dataSource=self;
    self.popTableView.delegate=self;
    self.popTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.popover = [DXPopover new];

}
//设置
- (void)settingClick{
    [self titleShowPopover];
}
#pragma mark - popover show
- (void)titleShowPopover
{
    UIView *titleView = self.navigationItem.leftBarButtonItem.customView;
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
#pragma mark - table source & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.popTableView==tableView) {
        if (self.sourceType==AreaGroupSourceDefault) {
            return 5;
        }else if(self.sourceType==AreaGroupSourceBrightness){
            
        }
    }
    return [self.areaEntity.groups count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.popTableView==tableView) {
        static NSString *cellId = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            UIView * _separateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59.5, self.view.bounds.size.width, 0.5)];
            [_separateLine setBackgroundColor:kSeparateLineColor];
            [cell.contentView addSubview:_separateLine];

        }
        //LightWIFI *model=[self.wifis objectAtIndex:indexPath.row];
        //cell.textLabel.text = model.wifiname;
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
    }
    LightAreaGroup *entity=[self.areaEntity.groups objectAtIndex:indexPath.row];
    cell.labName.text=entity.groupname;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
@end
