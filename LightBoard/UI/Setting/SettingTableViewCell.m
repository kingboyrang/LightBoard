//
//  SettingTableViewCell.m
//  LightBoard
//
//  Created by rang on 15-1-24.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.labName.font=kAppShowFont;
    self.labLine.backgroundColor=kSeparateLineColor;
    
    CGRect r=self.labLine.frame;
    r.size.height=0.5;
    r.origin.y=60-r.size.height;
    self.labLine.frame=r;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
