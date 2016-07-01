//
//  HomeViewController.m
//  CarBook
//
//  Created by 刘瑞英 on 16/6/24.
//  Copyright © 2016年 slinqueen. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeItemCell.h"
#import "UIView+Extension.h"
#import "ContentViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface HomeViewController ()<HomeItemCellDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentView;



@end

@implementation HomeViewController



-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
   
    self.contentView.contentSize=CGSizeMake(self.view.bounds.size.width, 400);
    
    HomeItemCell *cell=[HomeItemCell homeItemCell];
    [self.contentView addSubview:cell];
    cell.delegate=self;
    cell.x=20;
    cell.y=0;
    
    
        
}



-(void)homeItemCell:(HomeItemCell *)cell enterContentBtnClickd:(id)btn
{
    ContentViewController *content=[[ContentViewController alloc]init];
    content.edgesForExtendedLayout=UIRectEdgeAll;
    //content.extendedLayoutIncludesOpaqueBars=YES;
      //_m_webView.automaticallyAdjustsScrollViewInsets = YES;
    //content.automaticallyAdjustsScrollViewInsets=YES;
    //self.navigationController.navigationBar.translucent=YES;
   [self.navigationController pushViewController:content animated:YES];
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
