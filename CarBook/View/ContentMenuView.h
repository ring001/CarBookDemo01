//
//  ContentMenuView.h
//  CarBook
//
//  Created by 刘瑞英 on 16/6/27.
//  Copyright © 2016年 slinqueen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentMenuView;
@protocol ContentMenuViewDelegate <NSObject>

@optional

-(void)contentMenuViewSelectIndexChanged:(NSInteger)index;

@end

@interface ContentMenuView : UIView

@property(nonatomic, weak)id<ContentMenuViewDelegate> delegate;
@property(nonatomic, strong)NSArray *imageArrag;
@property(nonatomic, assign)int currentPage;

+(instancetype)contentMenuView;
-(void)setupSelectIndex:(CGFloat)value;
@end
