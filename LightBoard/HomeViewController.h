//
//  ViewController.h
//  LightBoard
//
//  Created by wulanzhou-mini on 15-1-19.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBBasicViewController.h"
#import "DXPopover.h"
@interface HomeViewController : LBBasicViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) DXPopover *popover;
@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) UILabel *labLine;
@property (weak, nonatomic) IBOutlet UITableView *middleTableView;

@end

