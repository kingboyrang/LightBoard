//
//  UIBarButtonItem+TPCategory.m
//  BurglarStar
//
//  Created by aJia on 2014/4/9.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "UIBarButtonItem+TPCategory.h"
#import "NSString+TPCategory.h"
@implementation UIBarButtonItem (TPCategory)
+ (id)barButtonWithTitle:(NSString*)title target:(id)sender action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kNavTitleColor forState:UIControlStateNormal];
    [btn addTarget:sender action:action forControlEvents:controlEvents];
    btn.titleLabel.font=kNavTitleFont;
    CGSize size=[title textSize:btn.titleLabel.font withWidth:320.0f];
    btn.frame=CGRectMake(0, 0, size.width, size.height);
    
    UIBarButtonItem *barButton=[[self alloc] initWithCustomView:btn];
    return barButton;
}
+ (id)barButtonWithImage:(NSString*)imageName target:(id)sender action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIImage *image=[UIImage imageNamed:imageName];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:sender action:action forControlEvents:controlEvents];
    NSLog(@"btn.frame =%@",NSStringFromCGRect(btn.frame));
    UIBarButtonItem *barButton=[[self alloc] initWithCustomView:btn];
    return barButton;
}
@end
