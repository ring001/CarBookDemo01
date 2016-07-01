//
//  HomeItemCell.h
//  CarBook
//
//  Created by 刘瑞英 on 16/6/24.
//  Copyright © 2016年 slinqueen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeItemCell;

@protocol HomeItemCellDelegate <NSObject>

 @optional

-(void)homeItemCell:(HomeItemCell *)cell enterContentBtnClickd:(id)btn;

@end



@interface HomeItemCell : UIView

+(instancetype)homeItemCell;

@property(weak, nonatomic) id<HomeItemCellDelegate> delegate;


@end
