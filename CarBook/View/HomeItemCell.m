//
//  HomeItemCell.m
//  CarBook
//
//  Created by 刘瑞英 on 16/6/24.
//  Copyright © 2016年 slinqueen. All rights reserved.
//

#import "HomeItemCell.h"

@interface HomeItemCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *m_newItemImg;
@property (weak, nonatomic) IBOutlet UIProgressView *downingSlider;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@property (weak, nonatomic) IBOutlet UIButton *cancleDownBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UILabel *sizeLbl;

@property (weak, nonatomic) IBOutlet UIButton *enterButton;

@end


@implementation HomeItemCell


+(instancetype)homeItemCell
{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"HomeItemCell" owner:nil options:nil]firstObject];
    
}


-(void)awakeFromNib
{
    self.autoresizingMask=UIViewAutoresizingNone;
}

-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.m_newItemImg.hidden=YES;
        self.cancleDownBtn.hidden=YES;
        self.deleteBtn.hidden=YES;
        self.sizeLbl.hidden=YES;
        self.downingSlider.hidden=YES;
        //self.enterButton.userInteractionEnabled=NO;
        
        
    }
    return self;
}
- (IBAction)downLoadBtnClicked:(id)sender {
    

}

- (IBAction)deleteBtnClicked:(id)sender {
    
}

- (IBAction)cancleBtnClicked:(id)sender {
    
    
}

- (IBAction)enterButtonClicked:(id)sender {
        NSLog(@"enterButtonClicked");
    
    if(self.delegate&& [self.delegate respondsToSelector:@selector(homeItemCell:enterContentBtnClickd:)])
    {
        [self.delegate homeItemCell:self enterContentBtnClickd:sender];
    }
    
}




@end
