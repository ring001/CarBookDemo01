//
//  CatelogView.m
//  CarBook
//
//  Created by 刘瑞英 on 16/6/27.
//  Copyright © 2016年 slinqueen. All rights reserved.
//

#import "CatalogView.h"
#import "CatalogCell.h"
#import "Catalog.h"

@interface CatalogView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)UITableView  *tableView;
@end

@implementation CatalogView

-(void)setCatalogs:(NSArray *)catalogs
{
    _catalogs=catalogs;
    
}





-(UITableView *)tableView{

    if(_tableView==nil)
    {
        _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return  _tableView;
}

 -(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        self.tableView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.tableView];
        
        
    }
    return self;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.catalogs.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *reuse=@"reuse";
    CatalogCell *cell=[tableView dequeueReusableCellWithIdentifier:reuse];
    if(cell==nil)
    {
        cell= [[[NSBundle mainBundle] loadNibNamed:@ "CatalogCell"  owner:self options:nil] lastObject];
    }
    cell.catelog= self.catalogs[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //需要做的是 隐藏View
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kLeftCatelogClicked" object:nil userInfo:@{@"kSelectedIndex":@(indexPath.row)}];
}

@end
