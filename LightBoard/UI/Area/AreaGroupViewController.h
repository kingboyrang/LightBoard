//
//  AreaGroupViewController.h
//  LightBoard
//
//  Created by wulanzhou-mini on 15-1-20.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LightArea.h"
#import "DXPopover.h"

//用户拨打方式
typedef enum
{
    AreaGroupSourceDefault = 0,//默认
    AreaGroupSourceBrightness = 1,//亮度
    AreaGroupSourceScene = 2,   //长景
    AreaGroupSourceSetting = 3,     //设置
}AreaGroupSourceType;


@interface AreaGroupViewController : LBBasicViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *areaTableView;
@property (nonatomic,strong) UITableView *popTableView;
@property (nonatomic,strong) DXPopover *popover;
@property (nonatomic,assign) AreaGroupSourceType sourceType;
@property (nonatomic,strong) LightArea *areaEntity;

@end
