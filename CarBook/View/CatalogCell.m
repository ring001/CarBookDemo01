//
//  CatalogCell.m
//  CarBook
//
//  Created by 刘瑞英 on 16/6/27.
//  Copyright © 2016年 slinqueen. All rights reserved.
//

#import "CatalogCell.h"
#import "UIView+Extension.h"

@interface CatalogCell ()

@property (weak, nonatomic) IBOutlet UIImageView *m_image;
@property (weak, nonatomic) IBOutlet UIImageView *hasVideo;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *hasSubItem;

@property(assign, nonatomic)int index;

@end

@implementation CatalogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCatelog:(Catalog *)catalog
{
    //self.m_image.image=[UIImage imageNamed:catalog.image];
    
    NSString *str= [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"web01/icon/%@",catalog.image] ofType:nil];
    
    self.m_image.image=[UIImage imageNamed:str];
   
    
    self.titleLbl.text=catalog.title;
    self.subTitleLbl.text=catalog.subTitle;
  
    self.hasVideo.hidden=!catalog.hasVideo;
   
    self.hasSubItem.hidden=!catalog.hasSubItem;
    if(!catalog.hasVideo)
    {
        self.hasVideo.image=self.hasSubItem.image;
        self.hasVideo.hidden=!catalog.hasSubItem;
        self.hasSubItem.hidden=YES;
    }

    self.index=catalog.index;
}

@end
