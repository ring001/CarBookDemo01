//
//  UIBarButtonIten+Extension.h
//  美团
//
//  Created by 刘瑞英 on 16/4/25.
//  Copyright © 2016年 slinqueen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highlightImage:(NSString *)highlightImage;

@end
