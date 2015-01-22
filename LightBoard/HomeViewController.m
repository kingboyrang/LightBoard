//
//  ViewController.m
//  LightBoard
//
//  Created by wulanzhou-mini on 15-1-19.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "HomeViewController.h"
#import "LightWIFIManager.h"
#import "AreaGroupViewController.h"
#import "UIBarButtonItem+TPCategory.h"
@interface HomeViewController ()
@property (nonatomic,strong) LightWIFI *curLightWifi;
@property (nonatomic,strong) NSArray *wifis;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem barButtonWithTitle:@"导入" target:self action:@selector(importClick) forControlEvents:UIControlEventTouchUpInside];
    
    [[LightWIFIManager sharedInstance] loadXml];
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 200, 40);
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(titleShowPopover) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.titleLabel.font = kAppShowFont;
    
    _labLine=[[UILabel alloc] initWithFrame:CGRectMake(0, 38, 200, 1)];
    _labLine.backgroundColor=UIColorMakeRGB(134,31,31);
    [leftBtn addSubview:_labLine];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    
    
    self.leftTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 180, 250) style:UITableViewStylePlain];
    self.leftTableView.dataSource=self;
    self.leftTableView.delegate=self;
    self.leftTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.middleTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.popover = [DXPopover new];
    
    [self receiveXmlChange];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveXmlChange) name:kNotificationLoadXmlFinished object:nil];
    
    // Do any additional setup after loading the view, typically from a nib.
}
//导入
- (void)importClick{

}
- (void)reloadXml{
    self.wifis=[[LightWIFIManager sharedInstance] wifis];
    if (self.wifis&&[self.wifis count]>0) {
        self.curLightWifi=[self.wifis objectAtIndex:0];
        
        
        
        UIButton *btn=(UIButton*)self.navigationItem.leftBarButtonItem.customView;
        CGSize size=[self.curLightWifi.wifiname textSize:btn.titleLabel.font withWidth:self.view.bounds.size.width];
        [btn setTitle:self.curLightWifi.wifiname forState:UIControlStateNormal];
        
        CGRect r=btn.frame;
        r.size.width=size.width;
        btn.frame=r;
        
        r=_labLine.frame;
        r.size.width=size.width;
        _labLine.frame=r;
        
        [self.leftTableView reloadData];
        [self.middleTableView reloadData];
    }
}
- (void)receiveXmlChange{
    [self performSelectorOnMainThread:@selector(reloadXml) withObject:nil waitUntilDone:NO];
    
}
#pragma mark - popover show
- (void)titleShowPopover
{
    UIView *titleView = self.navigationItem.leftBarButtonItem.customView;
    CGPoint startPoint = CGPointMake(CGRectGetMidX(titleView.frame), CGRectGetMaxY(titleView.frame) + 20);
    
    [self.popover showAtPoint:startPoint popoverPostion:DXPopoverPositionDown withContentView:self.leftTableView inView:self.navigationController.view];
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
    if (self.leftTableView==tableView) {
        return [self.wifis count];
    }
    return [self.curLightWifi.areas count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.leftTableView) {
        static NSString *cellId = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            UIView * _separateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49.5, self.view.bounds.size.width, 0.5)];
            [_separateLine setBackgroundColor:kSeparateLineColor];
            [cell.contentView addSubview:_separateLine];
        }
        LightWIFI *model=[self.wifis objectAtIndex:indexPath.row];
        cell.textLabel.text = model.wifiname;
        cell.textLabel.font=kAppShowFont;
        return cell;
    }
    static NSString *cellId = @"cellIdentifier1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        UIView * _separateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59.5, self.view.bounds.size.width, 0.5)];
        [_separateLine setBackgroundColor:kSeparateLineColor];
        [cell.contentView addSubview:_separateLine];
    }
    LightArea *model=[self.curLightWifi.areas objectAtIndex:indexPath.row];
    cell.textLabel.text = model.zonename;
    cell.textLabel.font=kAppShowFont;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.leftTableView){
        return 50.0;
    }
    return 60.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.leftTableView==tableView) {
        LightWIFI *model=[self.wifis objectAtIndex:indexPath.row];
        self.curLightWifi=model;
        UIButton *btn=(UIButton*)self.navigationItem.leftBarButtonItem.customView;
        [btn setTitle:model.wifiname forState:UIControlStateNormal];
        [self.popover dismiss];
        [self.middleTableView reloadData];
    }else{
        AreaGroupViewController *areaGroup=[self.storyboard instantiateViewControllerWithIdentifier:@"AreaGroupVC"];
        areaGroup.areaEntity=[self.curLightWifi.areas objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:areaGroup animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
