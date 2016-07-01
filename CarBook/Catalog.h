//
//  Catalog.h
//  CarBook
//
//  Created by 刘瑞英 on 16/6/29.
//  Copyright © 2016年 slinqueen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Catalog : NSObject


@property(nonatomic, assign) int index;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *subTitle;
@property(nonatomic, copy)NSString *image;
@property(nonatomic, copy)NSString *bigImage;
@property(nonatomic, assign) BOOL hasVideo;

@property(nonatomic, assign) BOOL hasSubItem;





@end
