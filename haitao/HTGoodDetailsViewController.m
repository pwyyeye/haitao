//
//  HTGoodDetailsViewController.m
//  haitao
//
//  Created by SEM on 15/7/18.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "HTGoodDetailsViewController.h"

#import "EScrollerView.h"
#import "TMRulerColor.h"
#import "ChooseSizeViewController.h"
#import "FCImageTextViewController.h"
#import "AppDelegate.h"
static CGFloat kImageOriginHight = 400;

@interface HTGoodDetailsViewController ()<UIWebViewDelegate>
{
    UIView*navigationBar;
    UrlImageButton* threeButtonImg;
    UrlImageButton* yansechicunImg;
    TMRulerColor *rulerView;
    UIView *_bgView;
    UIView *view_bar1;
    UIWebView *webView;
}
@end

@implementation HTGoodDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton*btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btnBack.frame=CGRectMake(10, 10, 42, 42);
    [btnBack setImage:BundleImage(@"left_grey") forState:0];
    [btnBack addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
//    [view_bar1 addSubview:btnBack];
//    UIView *naviView=(UIView*) [self getNavigationBar];
    
    
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled=YES;
    _scrollView.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor=[UIColor colorWithRed:.98 green:.98 blue:.98 alpha:1.0];
//    _scrollView.contentInset=UIEdgeInsetsMake(kImageOriginHight-100, 0, 50, 0);
    [self.view addSubview:_scrollView];
    [self.view insertSubview:btnBack aboveSubview:_scrollView];
    [self getScrollView];
    
    
    [self getToolBar];
    
    UIButton*btnShare=[UIButton buttonWithType:0];
    btnShare.frame=CGRectMake(self.view.frame.size.width-50, 10, 42, 42);
    //    btnShare.backgroundColor=[UIColor clearColor];
    [btnShare addTarget:self action:@selector(btnShare:) forControlEvents:UIControlEventTouchUpInside];
    [btnShare setImage:BundleImage(@"shop_fx_.png") forState:0];
    [self.view insertSubview:btnShare aboveSubview:_scrollView];
    
    UIButton*btnGoShop=[UIButton buttonWithType:0];
    btnGoShop.frame=CGRectMake(self.view.frame.size.width-50*2,10, 42, 42);
    btnGoShop.backgroundColor=[UIColor clearColor];
    [btnGoShop addTarget:self action:@selector(btnGoCar:) forControlEvents:UIControlEventTouchUpInside];
    [btnGoShop setImage:BundleImage(@"shop_gwc_.png") forState:0];
    [self.view insertSubview:btnGoShop aboveSubview:_scrollView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    _bigImg.frame=CGRectMake(0, -kImageOriginHight, _scrollView.frame.size.width, kImageOriginHight);
//    _scrollView.contentOffset=CGPointMake(0, -kImageOriginHight+100);
}
-(void)getScrollView
{
    
    
    NSMutableArray *bigArr=[[NSMutableArray alloc]init];
    if(self.goods_image.count<1){
        
    }else{
        for (NSString *imgUrl in self.goods_image) {
            NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
            [dicTemp setObject:imgUrl forKey:@"ititle"];
            [dicTemp setObject:@"" forKey:@"mainHeading"];
            [bigArr addObject:dicTemp];
        }

    }
    EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, self.view.frame.size.width, 250)
                                                          scrolArray:[NSArray arrayWithArray:bigArr] needTitile:YES];
    
    scroller.delegate=self;
    scroller.backgroundColor=[UIColor clearColor];
    [_scrollView addSubview:scroller];
    UIView  *nameView=[[UIView alloc]initWithFrame:CGRectMake(0, scroller.frame.size.height+scroller.frame.origin.y, self.view.frame.size.width,90 )];
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 15)];
    title_label.text=self.goods.title;
    title_label.font=[UIFont boldSystemFontOfSize:15];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =[UIColor colorWithRed:.3 green:.3 blue:.3 alpha:1.0];
    title_label.textAlignment=NSTextAlignmentCenter;
    [nameView insertSubview:title_label atIndex:0];
    
    
    
    UILabel *title_money=[[UILabel alloc]initWithFrame:CGRectMake(10, title_label.frame.origin.y+title_label.frame.size.height+10+3, self.view.frame.size.width-20, 15)];
    NSString *ss=[NSString stringWithFormat:@"%.f",self.goods.price];
    title_money.text=[NSString stringWithFormat:@"%@%@",ss,@""];
    
    title_money.font=[UIFont systemFontOfSize:18];
    title_money.backgroundColor=[UIColor clearColor];
    title_money.textColor =hongShe;
    title_money.textAlignment=1;
    [nameView insertSubview:title_money atIndex:0];
    
    UIButton *bijiaBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    bijiaBtn.frame =CGRectMake(self.view.frame.size.width/2-50, title_money.frame.origin.y+title_money.frame.size.height+3, 100, 25);
    [bijiaBtn setTitle:@"全球比价" forState:UIControlStateNormal];
    [bijiaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nameView insertSubview:bijiaBtn atIndex:0];
    
    [_scrollView addSubview:nameView];
    //邮费重量
    UIView *_bigView1=[[UIView alloc]initWithFrame:CGRectMake(0, nameView.frame.size.height+nameView.frame.origin.y+10, self.view.frame.size.width, 50)];
    _bigView1.layer.borderWidth=1;
    _bigView1.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
    _bigView1.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:_bigView1];
    
    UILabel *title1=[[UILabel alloc]initWithFrame:CGRectMake(0,5, self.view.frame.size.width/2, 20)];
    title1.text=@"1.5KG";
    title1.font=[UIFont systemFontOfSize:15];
    title1.backgroundColor=[UIColor clearColor];
    title1.textColor =[UIColor grayColor];
    title1.textAlignment=1;
    [_bigView1 addSubview:title1];
    
    UILabel *title2=[[UILabel alloc]initWithFrame:CGRectMake(0, title1.frame.size.height+5, 320/2, 20)];
    title2.text=@"发货重量";
    title2.font=[UIFont systemFontOfSize:15];
    title2.backgroundColor=[UIColor clearColor];
    title2.textColor =hui2;
    title2.textAlignment=1;
    [_bigView1 addSubview:title2];
    
    UIImageView*line1=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2,( _bigView1.frame.size.height-30)/2, 1, 30)];
    line1.image=BundleImage(@"line_01_.png");
    [_bigView1 addSubview:line1];
    
    
    
    UILabel *title11=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 5, self.view.frame.size.width/2, 20)];
    title11.text=@"80";
    title11.font=[UIFont systemFontOfSize:15];
    title11.backgroundColor=[UIColor clearColor];
    title11.textColor =[UIColor grayColor];
    title11.textAlignment=1;
    [_bigView1 addSubview:title11];
    
    UILabel *title12=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, title1.frame.size.height+5, self.view.frame.size.width/2, 20)];
    title12.text=@"转运运费";
    title12.font=[UIFont systemFontOfSize:15];
    title12.backgroundColor=[UIColor clearColor];
    title12.textColor =hui2;
    title12.textAlignment=1;
    [_bigView1 addSubview:title12];
    
    //邮费重量
    UIView *yunfeiView=[[UIView alloc]initWithFrame:CGRectMake(0, _bigView1.frame.size.height+_bigView1.frame.origin.y, self.view.frame.size.width, 30)];
    yunfeiView.backgroundColor=hui2;
    UILabel *yunfeititle=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width-40, 20)];
    yunfeititle.text=@"￥40/受500g,￥5续100g,每个订单仅收一次首重。";
    yunfeititle.font=[UIFont systemFontOfSize:12];
    yunfeititle.backgroundColor=[UIColor clearColor];
    yunfeititle.textColor =[UIColor blackColor];
    yunfeititle.textAlignment=1;
    [yunfeiView addSubview:yunfeititle];
    [_scrollView addSubview:yunfeiView];
    //支付方式
    _bigView2=[[UrlImageButton alloc]initWithFrame:CGRectMake(0, yunfeiView.frame.size.height+yunfeiView.frame.origin.y+10, 320, 80)];
    _bigView2.userInteractionEnabled=YES;
    _bigView2.backgroundColor=[UIColor whiteColor];
    _bigView2.layer.borderWidth=1;
    [_bigView2 addTarget:self action:@selector(btnGo:) forControlEvents:UIControlEventTouchUpInside];
    _bigView2.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
    [_scrollView addSubview:_bigView2];
    
    
    UrlImageView *headImg=[[UrlImageView alloc]initWithFrame:CGRectMake(15, 10, 60, 60)];
    headImg.image=BundleImage(@"df_03_.png");
    [_bigView2 addSubview:headImg];
    headImg.backgroundColor=[UIColor clearColor];
    
    UrlImageView *headImg1=[[UrlImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    headImg1.image=BundleImage(@"bg_01_.png");
    [headImg addSubview:headImg1];
    headImg1.backgroundColor=[UIColor clearColor];
    
    
    UILabel *title3=[[UILabel alloc]initWithFrame:CGRectMake(headImg.frame.size.width+headImg.frame.origin.x+10, 15,190, 20)];
    title3.text=@"支持支付宝等支付方式";
    title3.font=[UIFont systemFontOfSize:12];
    title3.backgroundColor=[UIColor clearColor];
    title3.textColor =[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1.0];
    title3.textAlignment=0;
    [_bigView2 addSubview:title3];
    
    UILabel *title4=[[UILabel alloc]initWithFrame:CGRectMake(headImg.frame.size.width+headImg.frame.origin.x+10, 15+title3.frame.size.height,50, 20)];
    title4.text=@"美国";
    title4.font=[UIFont systemFontOfSize:10];
    title4.backgroundColor=[UIColor clearColor];
    title4.textColor =[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
    title4.textAlignment=0;
    [_bigView2 addSubview:title4];
    
    UILabel *title5=[[UILabel alloc]initWithFrame:CGRectMake(title4.frame.size.width+title4.frame.origin.x, 15+title3.frame.size.height,130, 30)];
    title5.text=@"下单后6-10个工作日到手";
    
    title5.font=[UIFont systemFontOfSize:10];
    title5.numberOfLines=2;
    title5.backgroundColor=[UIColor clearColor];
    title5.textColor =[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1.0];
    title5.textAlignment=0;
    [_bigView2 addSubview:title5];
    
    
    UIImageView *imageJ=[[UIImageView alloc]initWithFrame:CGRectMake(_bigView2.frame.size.width-44, (_bigView2.frame.size.height-70)/2, 44, 70)];
    imageJ.image=BundleImage(@"bt_04_J.png");
    [_bigView2 addSubview:imageJ];
    
    //选择颜色和尺寸
    yansechicunImg=[[UrlImageButton alloc]initWithFrame:CGRectMake(0, _bigView2.frame.size.height+_bigView2.frame.origin.y+10, self.view.frame.size.width,35 )];
    yansechicunImg.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
    yansechicunImg.layer.borderWidth=1;
    [yansechicunImg addTarget:self action:@selector(yansechicunBtn:) forControlEvents:UIControlEventTouchUpInside];
    yansechicunImg.backgroundColor=[UIColor whiteColor];
    yansechicunImg.userInteractionEnabled=YES;
    [_scrollView addSubview:yansechicunImg];
    
    UILabel *yansechicunLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, yansechicunImg.frame.size.height/2-20/2, 150, 20)];
    yansechicunLbl.text=@"选择颜色和尺寸";
    yansechicunLbl.font=[UIFont systemFontOfSize:12];
    yansechicunLbl.backgroundColor=[UIColor clearColor];
    yansechicunLbl.textColor =hui5;
    yansechicunLbl.textAlignment=0;
    [yansechicunImg addSubview:yansechicunLbl];

    UIImageView *yansechicunimageP=[[UIImageView alloc]initWithFrame:CGRectMake(yansechicunImg.frame.size.width-44, (yansechicunImg.frame.size.height-70)/2, 44, 70)];
    yansechicunimageP.image=BundleImage(@"bt_04_J.png");
    [yansechicunImg addSubview:yansechicunimageP];
    //商品信息
    
    UILabel *shopInfolbl=[[UILabel alloc]initWithFrame:CGRectMake(0, yansechicunImg.frame.size.height+yansechicunImg.frame.origin.y+10, self.view.frame.size.width,15)];
    shopInfolbl.text=@"商品详情";
    shopInfolbl.font=[UIFont systemFontOfSize:12];
    shopInfolbl.backgroundColor=[UIColor clearColor];
    shopInfolbl.textColor =hui5;
    shopInfolbl.textAlignment=0;
    [_scrollView addSubview:shopInfolbl];
    //加载html商品信息
    webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, shopInfolbl.frame.size.height+shopInfolbl.frame.origin.y, self.view.frame.size.width,200)];
    
    
    NSString *webStr=[NSString stringWithFormat:@"<body>%@</body>",self.goodsExt.content];
    
    [webView loadHTMLString:webStr baseURL:nil];
    [webView setScalesPageToFit:YES];
    [webView setBackgroundColor:[UIColor clearColor]];
    webView.delegate=self;
    webView.opaque = NO;
    
//    webView.scrollView.bounces = NO; //__IPHONE_5_0
//    [self webViewDidFinishLoad:webView];
    [_scrollView addSubview:webView];
    
    
    
    
}

-(UIView*)getNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    view_bar1 =[[UIView alloc]init];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>6.1)
    {
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width, 44+20);
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 44+20)];
        imageV.image = BundleImage(@"top.png");
        [view_bar1 addSubview:imageV];
        
        
    }else{
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width,44);
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,44)];
        imageV.image = BundleImage(@"top.png");
        [view_bar1 addSubview:imageV];
        
    }
    view_bar1.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:view_bar1];
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(65, view_bar1.frame.size.height-44, self.view.frame.size.width-130, 44)];
//    title_label.text=@"商品详情";
    title_label.font=[UIFont boldSystemFontOfSize:20];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =[UIColor whiteColor];
    title_label.textAlignment=1;
    [view_bar1 addSubview:title_label];
    
  
    
    
    
    
    
    return view_bar1;
}
-(void)btnBack:(id)sender
{
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController popViewControllerAnimated:YES];
    
}
-(void)btnGo:(id)sender
{
    
    
}

//
-(void)btnComment:(id)sender
{
    
    
}
//图片详情
-(void)btnImageText:(NSArray*)sender
{
    FCImageTextViewController *imageText=[[FCImageTextViewController alloc] init];
    [self.navigationController pushViewController:imageText animated:YES];
    
}

//工具栏
-(UIView *)getToolBar
{
    UIView *view_bar =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    view_bar.backgroundColor=[UIColor whiteColor];
    view_bar.layer.borderColor=[UIColor colorWithRed:.9 green:.9  blue:.9  alpha:1.0].CGColor;
    view_bar.layer.borderWidth=1;
    [self.view addSubview:view_bar];
    
    UIButton*btnCall=[UIButton buttonWithType:0];
    btnCall.frame=CGRectMake(10, 0, 70, 50);
    btnCall.backgroundColor=[UIColor clearColor];
    [btnCall addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    [btnCall setImage:BundleImage(@"shopbt_02_.png") forState:0];
    [view_bar addSubview:btnCall];
    
    UIButton*shoucangBtn=[UIButton buttonWithType:0];
    shoucangBtn.frame=CGRectMake(10+70+5, 0, 70, 50);
    shoucangBtn.backgroundColor=[UIColor clearColor];
    [shoucangBtn addTarget:self action:@selector(shopping:) forControlEvents:UIControlEventTouchUpInside];
    [shoucangBtn setImage:BundleImage(@"shopbt_02_.png") forState:0];
    [view_bar addSubview:shoucangBtn];
    
    UIButton *carBtn=[UIButton buttonWithType:0];
    carBtn.frame=CGRectMake(10+70+5+70+5, 0,70, 50);
    carBtn.backgroundColor=[UIColor clearColor];
    [carBtn addTarget:self action:@selector(shopping:) forControlEvents:UIControlEventTouchUpInside];
    [carBtn setImage:BundleImage(@"shopbt_02_.png") forState:0];
    [view_bar addSubview:carBtn];

    
    UIButton*btnShop=[UIButton buttonWithType:0];
    btnShop.frame=CGRectMake(10+70+5+70+5+70, 49/2-28/2, 100, 28);
    btnShop.backgroundColor=[UIColor clearColor];
    [btnShop addTarget:self action:@selector(shopping:) forControlEvents:UIControlEventTouchUpInside];
    [btnShop setImage:BundleImage(@"shopbt_01_n_.png") forState:0];
    [view_bar addSubview:btnShop];
    
    
    
    return view_bar;
}
//分享
-(void)btnShare:(id)sender
{
    
    
}
//添加购物车
-(void)addShopCar:(id)sender
{
    
    
    //    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 320,self.view.frame.size.height-49)];
    //    [bgView setTag:99999];
    //    [bgView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    //    [bgView setAlpha:0.8];
    //
    //    [self.view addSubview:bgView];
    //    UIView* firstLevelMenuView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 320,0)];
    //    UIImageView*_imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    //    _imageView.image=BundleImage(@"bg_w_.png");
    //    [firstLevelMenuView insertSubview:_imageView aboveSubview:firstLevelMenuView];
    //
    //    firstLevelMenuView.tag = 100000;
    ////    firstLevelMenuView.menuDelegate = self;
    //    firstLevelMenuView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    //    [bgView addSubview:firstLevelMenuView];
    //    [UIView beginAnimations:@"animationID" context:nil];
    //    [UIView setAnimationDuration:0.5];
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:firstLevelMenuView cache:NO];
    //    firstLevelMenuView.frame= CGRectMake(0, 150, 320, self.view.frame.size.height-200);
    //
    ////    [_imageView release];
    //    [UIView commitAnimations];
    
    
    
    showShareMessage(@"商品成功添加购物车！");
}
//联系卖家
-(void)call:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"10086" message:@"确认要拨打电话吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 1001;
    [alert show];
    
}
//去购物车
-(void)btnGoCar:(id)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加入购物车" message:@"商品己成功加入购物车！" delegate:self cancelButtonTitle:@"继续购物" otherButtonTitles:@"去购物车", nil];
    alert.tag = 1000;
    [alert show];
    
}
//立即购买
-(void)shopping:(id)sender
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 320,self.view.frame.size.height)];
    [_bgView setTag:99999];
    [_bgView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]];
    [_bgView setAlpha:1.0];
    
    [self.view addSubview:_bgView];
    rulerView = [[TMRulerColor alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, 320,0) ];
    rulerView.tag = 100000;
    //    rulerView.menuDelegate = self;
    rulerView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [_bgView addSubview:rulerView];
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:rulerView cache:NO];
    rulerView.frame= CGRectMake(0, self.view.frame.size.height-420, 320, 420);
    UIImageView*_imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 6)];
    _imageView.image=BundleImage(@"ic_pull_shadow.png");
    [_bgView addSubview:_imageView];
    
    [UIView commitAnimations];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(_bgView.frame.size.width-36,0 , 36, 32);
    [button setImage:BundleImage(@"bt_clo_.png") forState:0];
    [button addTarget:self action:@selector(SetViewDisappear:) forControlEvents:UIControlEventTouchDown];
    [rulerView insertSubview:button aboveSubview:_bgView];
    button.backgroundColor=[UIColor clearColor];
    
}

//立即购买消失按钮
-(void)SetViewDisappear:(id)sender
{
    UIButton*btn=(UIButton*)sender;
    
    if (_bgView)
    {
        [UIView animateWithDuration:.5
                         animations:^{
                             
                             //                             rulerView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                             //                            _bgView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                             _bgView.alpha=0.0;
                         }];
        [_bgView performSelector:@selector(removeFromSuperview)
                      withObject:nil
                      afterDelay:2];
        
        
    }
    //    if (btn.selected==NO)
    //    {
    //        [btn setImage:BundleImage(@"bt_close_n.png") forState:0];
    //        btn.selected=YES;
    //    }else{
    //        [btn setImage:BundleImage(@"bt_close_s.png") forState:0];
    //        btn.selected=NO;
    //    }
    
}
#pragma mark - 选择颜色尺寸
-(void)yansechicunBtn:(UrlImageButton *)sendid{
    ChooseSizeViewController *chooseSizeViewController=[[ChooseSizeViewController alloc]init];
//    chooseSizeViewController
    chooseSizeViewController.goods_attr=self.goods_attr;
    chooseSizeViewController.goods=self.goods;
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController pushViewController:chooseSizeViewController animated:YES];
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"************");
    UIScrollView *scrollView = (UIScrollView *)[[webView subviews] objectAtIndex:0];
    CGFloat webViewHeight = [scrollView contentSize].height;
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.frame = newFrame;
    //评论
    threeButtonImg=[[UrlImageButton alloc]initWithFrame:CGRectMake(0, webView.frame.size.height+webView.frame.origin.y+10, self.view.frame.size.width,35 )];
    threeButtonImg.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
    threeButtonImg.layer.borderWidth=1;
    [threeButtonImg addTarget:self action:@selector(btnComment:) forControlEvents:UIControlEventTouchUpInside];
    threeButtonImg.backgroundColor=[UIColor whiteColor];
    threeButtonImg.userInteractionEnabled=YES;
    [_scrollView addSubview:threeButtonImg];
    
    UILabel *title_label1=[[UILabel alloc]initWithFrame:CGRectMake(10, threeButtonImg.frame.size.height/2-20/2, 50, 20)];
    title_label1.text=@"评论";
    title_label1.font=[UIFont systemFontOfSize:12];
    title_label1.backgroundColor=[UIColor clearColor];
    title_label1.textColor =hui5;
    title_label1.textAlignment=0;
    [threeButtonImg addSubview:title_label1];
    
    
    UILabel *title_labelCount=[[UILabel alloc]initWithFrame:CGRectMake(title_label1.frame.size.width+title_label1.frame.origin.y, threeButtonImg.frame.size.height/2-20/2, 200, 20)];
    title_labelCount.text=@"123条";
    title_labelCount.font=[UIFont systemFontOfSize:12];
    title_labelCount.backgroundColor=[UIColor clearColor];
    title_labelCount.textColor =hongShe;
    title_labelCount.textAlignment=0;
    
    [threeButtonImg addSubview:title_labelCount];
    
    UIImageView *imageP=[[UIImageView alloc]initWithFrame:CGRectMake(threeButtonImg.frame.size.width-44, (threeButtonImg.frame.size.height-70)/2, 44, 70)];
    imageP.image=BundleImage(@"bt_04_J.png");
    [threeButtonImg addSubview:imageP];
    
    
    for (int i=0; i<8; i++)
    {
        btnNine=[[UrlImageButton alloc]initWithFrame:CGRectMake((i%4)*(320-10)/4+10, floor(i/4)*(320-10)/4+10+threeButtonImg.frame.size.height+threeButtonImg.frame.origin.y, (320-30-10)/4, (320-30-10)/4)];
        btnNine.backgroundColor=[UIColor whiteColor];
        [btnNine setImage:[UIImage imageNamed:@"df_01.png"] forState:0];
        btnNine.tag=i+1000;
        [btnNine addTarget:self action:@selector(btnImageText:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btnNine];
        
    }
    if (IS_IPHONE_5)
    {
        _scrollView.contentSize=CGSizeMake(320, self.view.frame.size.height);
    }else{
        _scrollView.contentSize=CGSizeMake(320, self.view.frame.size.height+100);
    }
    UIView *view=[[UILabel alloc]initWithFrame:CGRectMake(10, btnNine.frame.size.height+btnNine.frame.origin.y+10, 300, 80)];
    view.layer.borderWidth=1;
    view.backgroundColor=[UIColor whiteColor];
    view.layer.borderColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0].CGColor;
    [_scrollView addSubview:view];
    [_scrollView setContentSize:CGSizeMake(320, view.frame.size.height+view.frame.origin.y+10)];
    UILabel *labelDetail=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 290, 70)];
    
    labelDetail.backgroundColor=[UIColor redColor];
    labelDetail.font=[UIFont systemFontOfSize:10];
    labelDetail.textColor=[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
    labelDetail.text=@"e2e1e12e21e21e21e1fdfdffsdfdsfdsfdsfdsfdfsdfdsfdsfdsf";
    labelDetail.numberOfLines=0;
    [labelDetail sizeToFit];
    [view addSubview :labelDetail ];
    
    _scrollView.frame=CGRectMake(0, view_bar1.frame.size.height, 320, self.view.frame.size.height+140-view.frame.size.height-10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
