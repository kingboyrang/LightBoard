//
//  SettingLightViewController.h
//  LightBoard
//
//  Created by rang on 15-1-24.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LightArea.h"
#import "DXPopover.h"
@interface SettingLightViewController : LBBasicViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *popTableView;
@property (nonatomic,strong) DXPopover *popover;
@property (nonatomic,strong) LightArea *areaEntity;
@property (nonatomic,strong) NSMutableArray *lightSences;//场景
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
//选中的数据源
@property (nonatomic,strong) NSMutableDictionary *selectedArray;

- (IBAction)openClick:(id)sender;

- (IBAction)closeClick:(id)sender;

- (IBAction)upClick:(id)sender;

- (IBAction)downClick:(id)sender;

- (IBAction)brightnessClick:(id)sender;
@end
