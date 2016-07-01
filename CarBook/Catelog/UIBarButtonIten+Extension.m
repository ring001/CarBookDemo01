//
//  UIBarButtonIten+Extension.m
//  美团
//
//  Created by 刘瑞英 on 16/4/25.
//  Copyright © 2016年 slinqueen. All rights reserved.
//

#import "UIBarButtonIten+Extension.h"

@implementation UIBarButtonItem (Extension)

+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highlightImage:(NSString *)highlightImage
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
  
    [btn setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 60, 30)];
    UIBarButtonItem *btnItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    return btnItem;
}

@end




