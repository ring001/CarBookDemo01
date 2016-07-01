//
//  ContentMenuView.m
//  CarBook
//
//  Created by 刘瑞英 on 16/6/27.
//  Copyright © 2016年 slinqueen. All rights reserved.
//

#import "ContentMenuView.h"
#import "UIView+Extension.h"
#import "Catalog.h"


#define  kBaseTag 100
#define  kScreenWidth [UIScreen mainScreen].bounds.size.width
#define  kHalfScreenWidth (kScreenWidth*0.5f)
#define  kItemSpacing 20.0f
#define  kItemWidth  250.0f
#define  kItemHeight (kItemWidth*0.7f)
#define  kStart  (kHalfScreenWidth-kItemWidth*0.5f)
#define  kScrollViewContentOffset (kHalfScreenWidth-kItemWidth*0.5f-kItemSpacing)



@interface ContentMenuView ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contentScroll;

@property(nonatomic, assign)int totalPage;


@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLbl;

@property (weak, nonatomic) IBOutlet UIImageView *hasVideo;

@property (weak, nonatomic) IBOutlet UIImageView *hasSubItem;

@property (nonatomic, assign, readwrite) CGPoint        scrollViewContentOffset;
@end

@implementation ContentMenuView

 

+(instancetype)contentMenuView
{ 
  return [[[NSBundle mainBundle]loadNibNamed:@"ContentMenuView" owner:nil options:nil]firstObject];
    
}




-(void)setImageArrag:(NSArray *)imageArrag
{
    _imageArrag=imageArrag;
    self.totalPage=(int)imageArrag.count;
    self.currentPage=0;
    [self setupScrollView];
    [self setupTilte:0];
}


-(void)setupScrollView
{
    
    self.currentPage=0;
    
    self.contentScroll.showsVerticalScrollIndicator=NO;
 
    self.contentScroll.bouncesZoom=NO;
    
    self.contentScroll.showsHorizontalScrollIndicator = NO;
   // self.contentScroll.decelerationRate = UIScrollViewDecelerationRateFast;
    self.contentScroll.alwaysBounceHorizontal = YES;
    self.contentScroll.delegate = self;
    self.contentScroll.contentInset = UIEdgeInsetsMake(0, kScrollViewContentOffset, 0, kScrollViewContentOffset);
  
    
    CGFloat w=self.totalPage*(kItemSpacing+kItemWidth)+kItemSpacing;

    self.contentScroll.contentSize=CGSizeMake(w, self.contentScroll.frame.size.height);
    
    
    for(int i=0;i<self.imageArrag.count;i++)
    {
        Catalog *catalog=self.imageArrag[i];
        
//        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:catalog.image]];
//        imageView.width=kItemWidth;
//        imageView.y=10;
//        imageView.tag=kBaseTag+i;
//        imageView.x=kItemSpacing+i*(kItemSpacing+kItemWidth);
//        imageView.height=kItemHeight;
//        imageView.userInteractionEnabled=YES;
//        [self.contentScroll addSubview:imageView];
//        //[self.imageArrag addObject:imageView];
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
//        [imageView addGestureRecognizer:tapGesture];
        
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        
           NSString *str= [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"web01/icon/%@",catalog.image] ofType:nil];
        if(catalog.bigImage)
        {
            str= [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"web01/icon/%@",catalog.bigImage] ofType:nil];
        }
        UIImage *image=[UIImage imageNamed:str];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.width=kItemWidth;
        button.y=10;
        button.x=kItemSpacing+i*(kItemSpacing+kItemWidth);
       // button.height=kItemHeight;
        button.height=image.size.height;
        button.tag=kBaseTag+i;
        [self.contentScroll addSubview:button];
        [button addTarget:self action:@selector(tapDetected:) forControlEvents:UIControlEventTouchUpInside];
        
        
       

    }
    
    self.contentScroll.contentOffset=CGPointMake( - kScrollViewContentOffset, 0);
   
    
}


- (void)tapDetected:(UIButton *)tapGesture
{
    if (tapGesture.tag == self.currentPage + kBaseTag) {
 
        if(self.delegate && [self.delegate respondsToSelector:@selector(contentMenuViewSelectIndexChanged:)])
        {
            [self.delegate contentMenuViewSelectIndexChanged:self.currentPage];
            return;
        }
    }
    
    CGPoint point = [tapGesture.superview convertPoint:tapGesture.center toView:self.contentScroll];
    point = CGPointMake(point.x - kScrollViewContentOffset - ((kItemWidth / 2 + kItemSpacing)), 0);
    self.scrollViewContentOffset = point;
    
    [self.contentScroll setContentOffset:point animated:YES];
}

#pragma  mark ScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    int index = (scrollView.contentOffset.x + kScrollViewContentOffset + (kItemWidth / 2 + kItemSpacing / 2)) / (kItemWidth + kItemSpacing);
    index=MIN(self.totalPage-1,MAX(0,index));
    
    if(self.currentPage!=index)
    {
        self.currentPage=index;
        //重置标题栏
        [self setupTilte:index];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"SliderChange" object:nil userInfo:@{@"SliderValue":@(index)}];
    }
 
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSInteger index = (targetContentOffset->x + kScrollViewContentOffset + (kItemWidth / 2 + kItemSpacing / 2)) / (kItemWidth + kItemSpacing);
    targetContentOffset->x = (kItemSpacing + kItemWidth) * index - kScrollViewContentOffset;
    
//        float value=(scrollView.contentOffset.x + kScrollViewContentOffset ) / (kItemWidth + kItemSpacing);
 
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
  //  NSLog(@"AnimationEnd");
   
}

-(void)setupSelectIndex:(CGFloat)value
{
   
    
//    CGFloat contentOffsetX=value* (kItemWidth + kItemSpacing)-(kScrollViewContentOffset + (kItemWidth / 2 + kItemSpacing / 2)) ;
//
//    [self.contentScroll setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
    
    //value=value/3.0f;

        
    int index=(int)roundf(value);
    
    index=MIN(self.totalPage-1,MAX(0,index));
 
    CGPoint targetContentOffset=CGPointMake((kItemSpacing + kItemWidth) * index - kScrollViewContentOffset, 0);
    [self.contentScroll setContentOffset:targetContentOffset animated:YES];
    
  
}


-(void)setupTilte:(int)index
{
    Catalog *catalog=self.imageArrag[index];
    self.hasVideo.hidden=!catalog.hasVideo;
    self.hasSubItem.hidden=!catalog.hasSubItem;
    self.titleLbl.text=catalog.title;
    self.subTitleLbl.text=catalog.subTitle;
//    if(!catalog.hasVideo)
//    {
//        self.hasVideo.image=self.hasSubItem.image;
//        self.hasVideo.hidden=!catalog.hasSubItem;
//        self.hasSubItem.hidden=YES;
//    }
    
}

@end
