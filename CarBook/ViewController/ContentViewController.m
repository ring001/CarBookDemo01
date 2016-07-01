//
//  ContentViewController.m
//  CarBook
//
//  Created by 刘瑞英 on 16/6/24.
//  Copyright © 2016年 slinqueen. All rights reserved.
//

#import "ContentViewController.h"
#import "UIBarButtonIten+Extension.h"
#import "UIView+Extension.h"
#import "ContentMenuView.h"
#import "CatalogView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "MJExtension.h"
#import "Catalog.h"
#import "AppDelegate.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ContentViewController ()<UIGestureRecognizerDelegate,UIWebViewDelegate,ContentMenuViewDelegate>
{
    AVPlayerViewController      *_playerController;
    AVPlayer                    *_player;
    AVAudioSession              *_session;
    NSString                    *_urlString;
     AVPlayerItem               *_playItem;
}

@property(nonatomic, strong)UIWebView *m_webView;

@property(nonatomic, strong)CatalogView *leftView;

@property(nonatomic, strong) UITapGestureRecognizer *singleTap;


@property(nonatomic, strong)UIView *bottomView;
@property(nonatomic, strong)UISlider *slider;


@property(nonatomic, strong)ContentMenuView *contentMenu;//内容菜单


@property (nonatomic,weak) JSContext * context;

@property(nonatomic, assign)int currentIndex;




@end


@implementation ContentViewController



-(UIView *)leftView
{
    if(_leftView==nil)
    {
        _leftView=[[CatalogView alloc]initWithFrame:CGRectMake(0, 60,1024*0.35f, 768-50)];
        _leftView.backgroundColor=[UIColor redColor];
        [self.view addSubview:_leftView];
        _leftView.width=0;
    }
    
    return _leftView;
}



-(ContentMenuView *) contentMenu
{
    if(!_contentMenu)
    {
        _contentMenu=[ContentMenuView contentMenuView];
        if(_contentMenu)
        {
        _contentMenu.frame=CGRectMake(0, 50, 1024, 768-50-40);
      
        [self.view addSubview:_contentMenu];
        _contentMenu.hidden=YES;
        _contentMenu.delegate=self;
        }
    }
    
    return  _contentMenu;
}

-(UIView *)bottomView
{
    if(!_bottomView)
    {
        _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 768-40, 1024, 40)];
        _slider=[[UISlider alloc]initWithFrame:CGRectMake(0, 0, 1024, 40)];
        _slider.backgroundColor=[UIColor lightGrayColor];
        [_slider addTarget:self action:@selector(valueChange:) forControlEvents:(UIControlEventValueChanged)];
        [_bottomView addSubview:_slider];
        [self.view addSubview:_bottomView];
        
    }
    
    return _bottomView;
}

-(UISlider *)slider
{
    if(!_slider)
    {
        _slider=[[UISlider alloc]initWithFrame:CGRectMake(0, 0, 1024, 40)];
        [self.view addSubview:_slider];
    }
    
    return _slider;
}


-(UIWebView *)m_webView
{
    if(_m_webView==nil)
    {
        _m_webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _m_webView.delegate=self;         
        [self.view addSubview:_m_webView];
    }
    return _m_webView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"BMW 7 Series 11/2015";
    self.view.backgroundColor=[UIColor whiteColor];
    self.m_webView.backgroundColor=[UIColor whiteColor];
   
    [self setupLeftNav];
    [self setupRightNav];
    self.bottomView.hidden=YES;
  
    
    NSArray *array=[Catalog objectArrayWithFilename:@"7er.plist"];
    if(array)
    {
        self.contentMenu.imageArrag=array;
        self.leftView.catalogs=array;
        self.slider.maximumValue=array.count-1;
        self.slider.minimumValue=0.0f;
    }
    
    self.leftView.width=0;
    self.contentMenu.hidden=YES;
    
    
    
    //添加Tap手势，用于控制导航栏和Sliderbar的显隐
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapWebView:)];
    tap.numberOfTouchesRequired = 1; //手指数
    tap.numberOfTapsRequired=1;
    tap.delegate=self;
    [self.view addGestureRecognizer:tap];
    self.singleTap=tap;
    self.bottomView.hidden=NO;
 
 
    //加载Web页面
  NSString *webPath=[[NSBundle mainBundle] pathForResource:@"web01/index.html" ofType:nil];
    if(webPath)
    {
        NSLog(@"webPath%@",webPath);
        NSURL *url=[NSURL URLWithString:webPath];
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        [self.m_webView loadRequest:request];
        
       
    }
    
    
    
    //注册SliderBar值变化通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(changeSliderValue:) name:@"SliderChange" object:nil];
 
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(leftCatelogClicked:) name:@"kLeftCatelogClicked" object:nil];
   
    
    
    
}

#pragma mark 通知处理



-(void)leftCatelogClicked:(NSNotification *)notification
{
    [self hidenLeftView:YES];
    self.navigationController.navigationBarHidden=YES;
    self.bottomView.hidden=YES;
    NSDictionary *userInfo=notification.userInfo;
    if(userInfo)
    {
        int index= [userInfo[@"kSelectedIndex"] intValue];
         [self.m_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"closeContent(); mySwiperFirst.slideTo('%d',0);",index]];
    }
    
}

-(void)changeSliderValue:(NSNotification *)notification
{
    
    NSDictionary *sliderValues=notification.userInfo;
    if(sliderValues)
    {
        float i= [sliderValues[@"SliderValue"] floatValue];
        self.slider.value=i;
    }
}

#pragma mark Slider值变化
-(void)valueChange:(UISlider *)slider
{
    [self.contentMenu setupSelectIndex:slider.value];
    if(self.contentMenu.hidden)
        self.contentMenu.hidden=NO;
    
}



#pragma mark dealloc
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark 手势处理
-(void)tapWebView:(UITapGestureRecognizer *)recognizer
{
    self.navigationController.navigationBarHidden=!self.navigationController.navigationBarHidden;
    self.bottomView.hidden=self.navigationController.navigationBarHidden;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
//    NSLog(@"gestureRecognizer:%@",gestureRecognizer.view);
//    if(gestureRecognizer.view==self.view)
//        return YES;
//    NSLog(@"otherGestureRecognizer:%@",otherGestureRecognizer.view);
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint currentPoint = [gestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(CGRectMake(150,100, 1024-300, 768-200), currentPoint) ){
        return YES;
    }
    
    return NO;
}

#pragma mark 设置导航栏按钮

-(void)setupLeftNav{
    UIBarButtonItem *homeItem=[UIBarButtonItem itemWithTarget:self action:@selector(goHome) image:@"menu_home" highlightImage:@"menu_home"];
    UIBarButtonItem *menuListItem=[UIBarButtonItem itemWithTarget:self action:@selector(menuListShow) image:@"menu_landscape" highlightImage:@"menu_landscape"];
  //  UIBarButtonItem *backItem=[UIBarButtonItem itemWithTarget:self action:@selector(goLastPage) image:@"menu_back" highlightImage:@"menu_back"];
    
    self.navigationItem.leftBarButtonItems=@[homeItem,menuListItem];

}


-(void)setupRightNav{
    
    //UIBarButtonItem *collectItem=[UIBarButtonItem itemWithTarget:self action:@selector(collect) image:@"menu_collector" highlightImage:@"menu_collector"];
    UIBarButtonItem *menuListItem=[UIBarButtonItem itemWithTarget:self action:@selector(menuShow) image:@"menu_portrait" highlightImage:@"menu_portrait"];
    
    self.navigationItem.rightBarButtonItems=@[menuListItem];
}


#pragma mark 按钮点击事件处理

//右侧菜单按钮
-(void)menuShow
{
    
   if(self.contentMenu.hidden)
   {
       //显示右侧列表
      [self hidenLeftView:YES];
       [self.view removeGestureRecognizer:self.singleTap];
       self.contentMenu.hidden=NO;
       
   }
   else
   {
       self.contentMenu.hidden=YES;
       [self contentMenuViewSelectIndexChanged:self.contentMenu.currentPage];
       [self.view addGestureRecognizer:self.singleTap];
   }
    
    
}

//左侧列表 show
-(void)menuListShow
{
    if(self.leftView.width==0)
    {
        //如果内容菜单显示中，则隐藏其显示
        if(!self.contentMenu.hidden)
        {
            self.contentMenu.hidden=YES;
        }
        //显示左侧列表
        [self hidenLeftView:NO];
    }
    else
    {
         [self hidenLeftView:YES];
    }
    
}


-(void)hidenLeftView:(BOOL)hiden
{
    
    if(!hiden)//显示
    {
        //移除屏幕点击监听事件
        [self.view removeGestureRecognizer:self.singleTap];
        self.bottomView.hidden=YES;
        [UIView  animateWithDuration:0.1f animations:^(void){
            self.leftView.width=1024*0.35f;
        }];
    }
    else
    {
        //添加屏幕点击监听事件
        [self.view addGestureRecognizer:self.singleTap];
        self.bottomView.hidden=NO;
        [UIView  animateWithDuration:0.1f animations:^(void){
            self.leftView.width=0;
        }];
    }
}

// 添加收藏
-(void)collect
{
    
}


//返回上一页
-(void)goLastPage
{
    
}

//// 返回主页
-(void)goHome
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark 设置配置文件





#pragma mark UIWebViewDelegate方法

- (void)webViewDidFinishLoad:(UIWebView *)webView{
 
     
    //获取js的运行环境
        _context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
 
    
         _context[@"slideChangeEnd"] = ^(){
                 NSArray * args = [JSContext currentArguments];//传过来的参数
                 for (id  obj in args) {
                     NSLog(@"html传过来的参数%@",obj);
                 }
                 NSString * name = args[0];
                 NSString * str = args[1];
                 [self slideChangeEndValue:name and:str];
             };
 
        _context[@"iosPlayVideo"]=^(){
            
            [self playVideo];
            };
 }


#pragma mark JS调用IOS 方法

-(void)playVideo
{
    [self performSelectorOnMainThread:@selector(playVideo3)withObject:nil waitUntilDone:NO];
}


-(void)playVideo3
{
    NSString *videoPath =[[NSBundle mainBundle] pathForResource:@"gaoxiaodongli_v7" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:videoPath];
    MPMoviePlayerViewController *mpViewCtrlor = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    mpViewCtrlor.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    mpViewCtrlor.moviePlayer.shouldAutoplay = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:mpViewCtrlor.moviePlayer];
    
    [self presentMoviePlayerViewControllerAnimated:mpViewCtrlor];
    [mpViewCtrlor.moviePlayer play];
    self.navigationController.navigationBarHidden=YES;
    self.bottomView.hidden=YES;
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    self.navigationController.navigationBarHidden=YES;
    self.bottomView.hidden=YES;
 //[[UIApplication sharedApplication] setStatusBarHidden:YES];
   // self dismissViewControllerAnimated:<#(BOOL)#> completion:<#^(void)completion#>
}



-(void)playerItemDidReachEnd:(CMTime) time
{
    [_player pause];
    [_player replaceCurrentItemWithPlayerItem:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




-(void)slideChangeEndValue:(NSString *)str1 and:(NSString *)str2{
   JSValue *js=(JSValue*)str2;
    self.currentIndex=[js toInt32];
   [self.contentMenu setupSelectIndex:[js toInt32]];

}

#pragma mark ContentMenuViewDelegate
-(void)contentMenuViewSelectIndexChanged:(NSInteger)index
{
    if(self.currentIndex== (int)index )
        return;
    self.currentIndex=(int)index;
    
    
    [self.m_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"closeContent(); mySwiperFirst.slideTo('%d',0);",(int)(index)]];
    
    [self.view addGestureRecognizer:self.singleTap];
    if(!self.contentMenu.hidden)
        self.contentMenu.hidden=YES;
    self.navigationController.navigationBarHidden=YES;
    self.bottomView.hidden=YES;
    
}



#pragma mark 废弃的视频播放方法

-(void)playVideo2
{
    NSString *videoPath =[[NSBundle mainBundle] pathForResource:@"gaoxiaodongli_v7" ofType:@"mp4"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:videoPath]){
        return;
    }
    _session = [AVAudioSession sharedInstance];
    [_session setCategory:AVAudioSessionCategoryPlayback error:nil];
    _player=[[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:videoPath]];
    
    
    
    //_player = [AVPlayer playerWithURL:[NSURL URLWithString:videoPath]];
    [_player setVolume:1];
    _playerController = [[AVPlayerViewController alloc] init];
    _playerController.player = _player;
    _playerController.videoGravity = AVLayerVideoGravityResize;
    _playerController.allowsPictureInPicturePlayback = NO;    //画中画，iPad可用
    _playerController.showsPlaybackControls = true;
    
    [self addChildViewController:_playerController];
    //_playerController.view.translatesAutoresizingMaskIntoConstraints = true;    //AVPlayerViewController 内部可能是用约束写的，这句可以禁用自动约束，消除报错
    //self.view.bounds
    _playerController.view.frame = CGRectMake(0, 0, 320, 300);
    [self.view addSubview:_playerController.view];
    [_playerController.player play];    //自动播放
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification
                                               object:_player.currentItem];
    
}
- (void)playVideo1 {
    
    
    NSString *videoPath =[[NSBundle mainBundle] pathForResource:@"gaoxiaodongli_v7" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:videoPath];
    
    
    MPMoviePlayerController *movewController =[[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    
    // 这里注册相关操作的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(movieFinishedCallback:)
     
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
     
                                               object:movewController]; //播放完后的通知
    
    [movewController prepareToPlay];
    
    //   [movewController.view setFrame:self.view.bounds];
    
    [movewController setControlStyle:MPMovieControlStyleDefault];
    
    [movewController setFullscreen:YES];
    
    [self.view addSubview:movewController.view];//设置写在添加之后   // 这里是addSubView
    
    movewController.shouldAutoplay=YES;
    
    
    [movewController play];
    
    
    
    
}

-(void)movieFinishedCallback:(NSNotification*)notification
{
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    if(player.view.superview)
    {
        [player.view removeFromSuperview];
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
