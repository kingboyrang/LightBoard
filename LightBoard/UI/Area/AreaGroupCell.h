//
//  AreaGroupCell.h
//  LightBoard
//
//  Created by wulanzhou-mini on 15-1-20.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaGroupCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UISwitch *areaSwitch;
@property (weak, nonatomic) IBOutlet UILabel *labLine;

@end
