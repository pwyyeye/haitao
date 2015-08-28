//
//  HTGoodDetailsViewController.m
//  haitao
//
//  Created by SEM on 15/7/18.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "HTGoodDetailsViewController.h"
#import "CFContentForDicKeyViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "EScrollerView.h"
#import "BiJiaView.h"
#import "ChooseSizeViewController.h"
#import "FCImageTextViewController.h"
#import "AppDelegate.h"
#import "HTShopStoreCarViewController.h"
#import "BiJiaModel.h"
#import "GoodImageButton.h"
#import "GouWuXuZhiViewController.h"
#import "ChatViewController.h"
#import "QAViewController.h"
static CGFloat kImageOriginHight = 400;

@interface HTGoodDetailsViewController ()<UIWebViewDelegate,ChooseSizeDelegate>
{
    UIView*navigationBar;
    UrlImageButton* threeButtonImg;
    UrlImageButton* yansechicunImg;
    BiJiaView *rulerView;
    UIView *_bgView;
    UIView *view_bar1;
    UIWebView *webView1;
    NSMutableArray *bijiaArr;
    UIButton *bijiaBtn;
}
@end

@implementation HTGoodDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    UIButton*btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btnBack.frame=CGRectMake(10, 20, 42, 42);
    [btnBack setImage:BundleImage(@"DetailsPage_btn_banner_share_") forState:0];
    [btnBack addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
//    [view_bar1 addSubview:btnBack];
//    UIView *naviView=(UIView*) [self getNavigationBar];
    
    
    self.view.backgroundColor=[UIColor colorWithRed:.98 green:.98 blue:.98 alpha:1.0];
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height+20)];

    _scrollView.backgroundColor=RGB(237,237,237);
//    _scrollView.delegate = self;
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
    btnShare.frame=CGRectMake(self.view.frame.size.width-50, 20, 42, 42);
    //    btnShare.backgroundColor=[UIColor clearColor];
    [btnShare addTarget:self action:@selector(btnShare:) forControlEvents:UIControlEventTouchUpInside];
    [btnShare setImage:BundleImage(@"DetailsPage_btn_banner_return_") forState:0];
    [self.view insertSubview:btnShare aboveSubview:_scrollView];
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    _bigImg.frame=CGRectMake(0, -kImageOriginHight, _scrollView.frame.size.width, kImageOriginHight);
//    _scrollView.contentOffset=CGPointMake(0, -kImageOriginHight+100);
}
-(void)getScrollView
{
    
    
    NSMutableArray *bigArr=[[NSMutableArray alloc]init];
    if(self.goods.img_450){
        NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
        [dicTemp setObject:self.goods.img_450 forKey:@"ititle"];
        [dicTemp setObject:@"" forKey:@"mainHeading"];
        [bigArr addObject:dicTemp];
    }
    if(self.goods_image.count<1){
        
    }else{
        for (NSString *imgUrl in self.goods_image) {
            NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
            [dicTemp setObject:imgUrl forKey:@"ititle"];
            [dicTemp setObject:@"" forKey:@"mainHeading"];
            [bigArr addObject:dicTemp];
        }

    }
    EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)
                                                          scrolArray:[NSArray arrayWithArray:bigArr] needTitile:YES];
    
    scroller.delegate=self;
    scroller.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:scroller];
    UIView  *nameView=[[UIView alloc]initWithFrame:CGRectMake(0, scroller.frame.size.height+scroller.frame.origin.y, self.view.frame.size.width,100 )];
    nameView.backgroundColor=[UIColor whiteColor];
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 40)];
    title_label.text=self.goods.title;
    title_label.numberOfLines=2;
    title_label.lineBreakMode=UILineBreakModeWordWrap;
    title_label.font=[UIFont boldSystemFontOfSize:15];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =RGB(128, 128, 128);
    title_label.textAlignment=NSTextAlignmentCenter;
    [nameView insertSubview:title_label atIndex:0];
    
    
    
    UILabel *title_money=[[UILabel alloc]initWithFrame:CGRectMake(10, title_label.frame.origin.y+title_label.frame.size.height+5, self.view.frame.size.width-20, 15)];
    NSString *ss=[NSString stringWithFormat:@"￥%.2f",self.goods.price_cn];
    title_money.text=[NSString stringWithFormat:@"%@%@",ss,@""];
    
    title_money.font=[UIFont systemFontOfSize:18];
    title_money.backgroundColor=[UIColor clearColor];
    title_money.textColor =hongShe;
    title_money.textAlignment=1;
    [nameView insertSubview:title_money atIndex:0];
    
    bijiaBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    bijiaBtn.userInteractionEnabled=true;
    bijiaBtn.backgroundColor=[UIColor clearColor];
    bijiaBtn.frame =CGRectMake(self.view.frame.size.width/2-50, title_money.frame.origin.y+title_money.frame.size.height+3, 100, 30);
    [bijiaBtn setTitle:@"全球比价" forState:UIControlStateNormal];
    bijiaBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [bijiaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bijiaBtn setHidden:YES];
    [bijiaBtn addTarget:self action:@selector(quanqiubijia:) forControlEvents:UIControlEventTouchUpInside];
    [self queryBiJia];
    UIImageView *rightimg=[[UIImageView alloc]initWithFrame:CGRectMake(bijiaBtn.width-20, 12, 7, 7)];
    rightimg.image=[UIImage  imageNamed:@"icon_Drop-rightList"];
    [bijiaBtn addSubview:rightimg];
    [nameView insertSubview:bijiaBtn atIndex:0];
        [_scrollView addSubview:nameView];
    //邮费重量
    UIView *_bigView1=[[UIView alloc]initWithFrame:CGRectMake(0, nameView.frame.size.height+nameView.frame.origin.y+10, self.view.frame.size.width, 50)];
    _bigView1.layer.borderWidth=1;
    _bigView1.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
    _bigView1.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:_bigView1];
    //判断直邮和转运
    if([self.goods.ship_type isEqualToString:@"2"]){
        UILabel *title1=[[UILabel alloc]initWithFrame:CGRectMake(0,5, self.view.frame.size.width, 20)];
        title1.text=[NSString stringWithFormat:@"%@g",self.goodsExt.weight_g];
        title1.font=[UIFont systemFontOfSize:13];
        title1.backgroundColor=[UIColor clearColor];
        title1.textColor =RGB(128, 128, 128);
        title1.textAlignment=1;
        [_bigView1 addSubview:title1];
        
        UILabel *title2=[[UILabel alloc]initWithFrame:CGRectMake(0, title1.frame.size.height+5, self.view.frame.size.width, 20)];
        title2.text=@"发货重量";
        title2.font=[UIFont systemFontOfSize:10];
        title2.backgroundColor=[UIColor clearColor];
        title2.textColor =RGB(179, 179, 179);
        title2.textAlignment=1;
        [_bigView1 addSubview:title2];
        
        UIImageView*line1=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2,( _bigView1.frame.size.height-30)/2, 1, 30)];
        line1.image=BundleImage(@"line_01_.png");
//        [_bigView1 addSubview:line1];
        
        
//        
//        UILabel *title11=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 5, self.view.frame.size.width/2, 20)];
//        title11.text=@"0";
//        title11.font=[UIFont systemFontOfSize:13];
//        title11.backgroundColor=[UIColor clearColor];
//        title11.textColor =RGB(128, 128, 128) ;
//        title11.textAlignment=1;
//        [_bigView1 addSubview:title11];
//        
//        UILabel *title12=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, title1.frame.size.height+5, self.view.frame.size.width/2, 20)];
//        title12.text=@"转运运费";
//        title12.font=[UIFont systemFontOfSize:10];
//        title12.backgroundColor=[UIColor clearColor];
//        title12.textColor =RGB(179, 179, 179) ;
//        title12.textAlignment=1;
//        [_bigView1 addSubview:title12];
    }else{
        UILabel *title1=[[UILabel alloc]initWithFrame:CGRectMake(0,5, self.view.frame.size.width, 20)];
        title1.text=[NSString stringWithFormat:@"%@g",self.goodsExt.weight_g];
        title1.font=[UIFont systemFontOfSize:13];
        title1.backgroundColor=[UIColor clearColor];
        title1.textColor =RGB(128, 128, 128);
        title1.textAlignment=1;
        [_bigView1 addSubview:title1];
        
        UILabel *title2=[[UILabel alloc]initWithFrame:CGRectMake(0, title1.frame.size.height+5, self.view.frame.size.width, 20)];
        title2.text=@"发货重量";
        title2.font=[UIFont systemFontOfSize:10];
        title2.backgroundColor=[UIColor clearColor];
        title2.textColor =RGB(179, 179, 179) ;
        title2.textAlignment=1;
        [_bigView1 addSubview:title2];
        
        UIImageView*line1=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3,( _bigView1.frame.size.height-30)/2, 1, 30)];
        line1.image=BundleImage(@"line_01_.png");
//        [_bigView1 addSubview:line1];
        
        
        
//        UILabel *title11=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3, 5, self.view.frame.size.width/3, 20)];
//        title11.text=@"0";
//        title11.font=[UIFont systemFontOfSize:13];
//        title11.backgroundColor=[UIColor clearColor];
//        title11.textColor =RGB(128, 128, 128);
//        title11.textAlignment=1;
//        [_bigView1 addSubview:title11];
//        
//        UILabel *title12=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3, title1.frame.size.height+5, self.view.frame.size.width/3, 20)];
//        title12.text=@"直邮运费";
//        title12.font=[UIFont systemFontOfSize:10];
//        title12.backgroundColor=[UIColor clearColor];
//        title12.textColor =RGB(179, 179, 179);
//        title12.textAlignment=1;
//        [_bigView1 addSubview:title12];
//        
//        UIImageView*line2=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*2/3,( _bigView1.frame.size.height-30)/2, 1, 30)];
//        line2.image=BundleImage(@"line_01_.png");
//        [_bigView1 addSubview:line2];
        
        
        
//        UILabel *title13=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 5, self.view.frame.size.width/2, 20)];
//        title13.text=[NSString stringWithFormat:@"%.f",self.goodsExt.direct_tax ];
//        title13.font=[UIFont systemFontOfSize:13];
//        title13.backgroundColor=[UIColor clearColor];
//        title13.textColor =RGB(128, 128, 128);
//        title13.textAlignment=1;
//        [_bigView1 addSubview:title13];
//        
//        UILabel *title32=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, title1.frame.size.height+5, self.view.frame.size.width/2, 20)];
//        title32.text=@"预收关税";
//        title32.font=[UIFont systemFontOfSize:10];
//        title32.backgroundColor=[UIColor clearColor];
//        title32.textColor =RGB(179, 179, 179);
//        title32.textAlignment=1;
//        [_bigView1 addSubview:title32];

    }
    
    
    //邮费重量
    UIView *yunfeiView=[[UIView alloc]initWithFrame:CGRectMake(0, _bigView1.frame.size.height+_bigView1.frame.origin.y, self.view.frame.size.width, 30)];
    yunfeiView.backgroundColor=hexColor(@"#ffe0eb");
    UILabel *yunfeititle=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width-40, 20)];
    yunfeititle.text=@"￥40/首500g,￥5续100g,每个订单仅收一次首重。";
    yunfeititle.font=[UIFont systemFontOfSize:12];
    yunfeititle.backgroundColor=[UIColor clearColor];
    yunfeititle.textColor =RGB(175, 104, 122);
    yunfeititle.textAlignment=1;
    [yunfeiView addSubview:yunfeititle];
//    [_scrollView addSubview:yunfeiView];
    //支付方式
    _bigView2=[[UIView alloc]initWithFrame:CGRectMake(0, _bigView1.frame.size.height+_bigView1.frame.origin.y+10, _scrollView.width, 60)];
    _bigView2.backgroundColor=[UIColor whiteColor];
//    _bigView2.layer.borderWidth=0.5;
//    _bigView2.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
    [_scrollView addSubview:_bigView2];
    
    //商城专区
    
    
    //titel
//    UILabel *title3=[[UILabel alloc]initWithFrame:CGRectMake(10, 10,190, 10)];
//    title3.text=@"支持支付宝等支付方式";
//    title3.font=[UIFont boldSystemFontOfSize:13];
//    title3.backgroundColor=[UIColor clearColor];
//    title3.textColor =RGB(51, 51, 51);
//    title3.textAlignment=0;
//    [_bigView2 addSubview:title3];
    
    UIImageView *headImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 60, 60)];
    [headImg setImageWithURL:[NSURL URLWithString:self.goods.shop_logo_app] placeholderImage:[UIImage imageNamed:@"default_04"]];
//    headImg.image=[UIImage imageNamed:@"AlipayIcon"];
    [_bigView2 addSubview:headImg];
    headImg.backgroundColor=[UIColor clearColor];
    
    //商城名称
    UILabel *shopname=[[UILabel alloc] initWithFrame:CGRectMake(headImg.width+headImg.left+5, 8, 70, 20)];
    shopname.text=self.goods.shop_name;
    shopname.font =[UIFont  systemFontOfSize:10];
    shopname.textColor=RGB(179, 179, 179);
    [_bigView2 addSubview:shopname];
    //国家
    //国家icon
    UIImageView *country=[[UIImageView alloc] initWithFrame:CGRectMake(_bigView2.width-45-90, 10, 15, 15)];
    [country setImageWithURL:[NSURL URLWithString:self.goods.country_flag_url] placeholderImage:[UIImage imageNamed:@"default_04.png"]];
    [_bigView2 addSubview:country];
    
    //国家名称
    UILabel *countryname=[[UILabel alloc] initWithFrame:CGRectMake(country.left+country.width+5, 8, 70, 20)];
    countryname.text=self.goods.country_name;
    countryname.font =[UIFont  systemFontOfSize:10];
    countryname.textColor=RGB(179, 179, 179);
    [_bigView2 addSubview:countryname];

    
    UILabel *title5=[[UILabel alloc]initWithFrame:CGRectMake(headImg.width+headImg.left+5, 35,200, 20)];
    title5.text=[self.goods.country_name isEqualToString:@"美国"]?@"国外商城发货后10~17个工作日到手":@"国外商城发货后3-5个工作日到手";
    
    title5.font=[UIFont systemFontOfSize:9];
    title5.numberOfLines=2;
    title5.backgroundColor=[UIColor clearColor];
    title5.textColor =RGB(179, 179, 179);
    title5.textAlignment=0;
    [_bigView2 addSubview:title5];
  //商品专区
    UIButton *spzqBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    spzqBtn.userInteractionEnabled=true;
    spzqBtn.backgroundColor=[UIColor clearColor];
    spzqBtn.frame =CGRectMake(_bigView2.width-10-80, title5.top-6, 80, 30);
    [spzqBtn setTitle:@"商城专区" forState:UIControlStateNormal];
    spzqBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [spzqBtn setTitleColor:RGB(128, 128, 128)  forState:UIControlStateNormal];
    [spzqBtn addTarget:self action:@selector(shopquQuery:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *rightspimg=[[UIImageView alloc]initWithFrame:CGRectMake(spzqBtn.width-8, 12, 7, 7)];
    rightspimg.image=[UIImage  imageNamed:@"icon_Drop-rightList"];
    [spzqBtn addSubview:rightspimg];
    [_bigView2 insertSubview:spzqBtn atIndex:0];

    
    //选择颜色和尺寸
    yansechicunImg=[[UrlImageButton alloc]initWithFrame:CGRectMake(0, _bigView2.frame.size.height+_bigView2.frame.origin.y+10, self.view.frame.size.width,35 )];
    yansechicunImg.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
    yansechicunImg.layer.borderWidth=1;
    [yansechicunImg addTarget:self action:@selector(yansechicunBtn:) forControlEvents:UIControlEventTouchUpInside];
    yansechicunImg.backgroundColor=[UIColor whiteColor];
    yansechicunImg.userInteractionEnabled=YES;
    [_scrollView addSubview:yansechicunImg];
    
    UILabel *yansechicunLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, yansechicunImg.frame.size.height/2-30/2, 150, 30)];
    yansechicunLbl.text=@"选择商品属性和数量";
    yansechicunLbl.font=[UIFont boldSystemFontOfSize:13];
    yansechicunLbl.backgroundColor=[UIColor clearColor];
    yansechicunLbl.textColor =RGB(51, 51, 51);
    yansechicunLbl.textAlignment=0;
    [yansechicunImg addSubview:yansechicunLbl];

    UIImageView *yansechicunimageP=[[UIImageView alloc]initWithFrame:CGRectMake(yansechicunImg.frame.size.width-20, (yansechicunImg.frame.size.height-7)/2, 7, 7)];
    yansechicunimageP.image=BundleImage(@"icon_Drop-rightList");
    [yansechicunImg addSubview:yansechicunimageP];
    //商品信息
    //品牌信息
    UIView *brandView=[[UIView alloc]initWithFrame:CGRectMake(0, yansechicunImg.frame.size.height+yansechicunImg.frame.origin.y+10, self.view.frame.size.width,200)];
    brandView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:brandView];
    //品牌信息
    
    
    UrlImageView *brandImg=[[UrlImageView alloc]initWithFrame:CGRectMake(10,10, 60, 60)];
    [brandImg setImageWithURL:[NSURL URLWithString:self.goods.brand_logo] placeholderImage:[UIImage imageNamed:@"default_04"]];
    [brandView addSubview:brandImg];
    brandImg.backgroundColor=[UIColor clearColor];
    
    //titel
    UILabel *pinpaiLbl=[[UILabel alloc]initWithFrame:CGRectMake(brandImg.width+brandImg.left+5, 10,190, 10)];
    pinpaiLbl.text=self.goods.brand_name;
    pinpaiLbl.font=[UIFont boldSystemFontOfSize:10];
    pinpaiLbl.backgroundColor=[UIColor clearColor];
    pinpaiLbl.textColor =RGB(179, 179, 179);
    pinpaiLbl.textAlignment=0;
    [brandView addSubview:pinpaiLbl];
    
    UILabel *barndMiaoshu=[[UILabel alloc]initWithFrame:CGRectMake(brandImg.width+brandImg.left+5, brandImg.top+brandImg.height-20,160, 20)];
    barndMiaoshu.text=@"国际知名品牌";
    
    barndMiaoshu.font=[UIFont systemFontOfSize:10];
    barndMiaoshu.backgroundColor=[UIColor clearColor];
    barndMiaoshu.textColor =RGB(179, 179, 179);
    barndMiaoshu.textAlignment=0;
    [brandView addSubview:barndMiaoshu];
    //进入品牌专区
    UIButton *brandAct=[UIButton buttonWithType:UIButtonTypeCustom];
    brandAct.userInteractionEnabled=true;
    brandAct.backgroundColor=[UIColor clearColor];
    brandAct.frame =CGRectMake(brandView.width-10-80, barndMiaoshu.top-6, 80, 30);
    [brandAct setTitle:@"品牌专区" forState:UIControlStateNormal];
    brandAct.titleLabel.font = [UIFont systemFontOfSize:11];
    [brandAct setTitleColor:RGB(128, 128, 128)  forState:UIControlStateNormal];
    [brandAct addTarget:self action:@selector(brandQuQuery:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *rightBrandimg=[[UIImageView alloc]initWithFrame:CGRectMake(brandAct.width-8, 12, 7, 7)];
    rightBrandimg.image=[UIImage  imageNamed:@"icon_Drop-rightList"];
    [brandAct addSubview:rightBrandimg];
    [brandView insertSubview:brandAct atIndex:0];
    //品牌描述
    UILabel *barndMiaoshuContent=[[UILabel alloc]initWithFrame:CGRectMake(brandImg.left, brandImg.top+brandImg.height+25,brandView.width-brandImg.left-10, 20)];
//    barndMiaoshuContent.text=@"    日本花王集团创立于1887年，是日本的家庭用品和化妆品生产企业。我们生产和销售日常生活中所需的高品质生活用品，有乐而雅，妙而舒，洁霸，碧柔，碧柔男士等品牌。花王集团立足于消费者和顾客，竭诚提供性能优异的高品质产品，努力为满足和丰富世界人民的生活作出贡献。";
    barndMiaoshuContent.text=@"";
    
    barndMiaoshuContent.font=[UIFont boldSystemFontOfSize:11];
    barndMiaoshuContent.backgroundColor=[UIColor clearColor];
    barndMiaoshuContent.textColor =RGB(51, 51, 51);
    barndMiaoshuContent.textAlignment=NSTextAlignmentLeft;
    barndMiaoshuContent.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
    barndMiaoshuContent.lineBreakMode=UILineBreakModeWordWrap;
    //高度固定不折行，根据字的多少计算label的宽度
    
    CGSize size = [barndMiaoshuContent.text sizeWithFont:barndMiaoshuContent.font
                      constrainedToSize:CGSizeMake(barndMiaoshuContent.width, MAXFLOAT)
                          lineBreakMode:NSLineBreakByWordWrapping];
    //        NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
    //根据计算结果重新设置UILabel的尺寸
    barndMiaoshuContent.height=size.height;
    
    [brandView addSubview:barndMiaoshuContent];
    brandView.height=barndMiaoshuContent.height+barndMiaoshuContent.top+20;
    
    //加载html商品信息
    webView1=[[UIWebView alloc]initWithFrame:CGRectMake(-2, brandView.top+brandView.height, _scrollView.width+2,200)];
    
    
    NSString *webStr=[NSString stringWithFormat:@"<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no\" /></head><body>%@<script type=\"text/javascript\">var imgs = document.getElementsByTagName('img');for(var i = 0; i<imgs.length; i++){imgs[i].style.width = '310';imgs[i].style.height = 'auto';}</script></body>",self.goodsExt.content];
    //
    
    
    
//
    isLoadingFinished = NO;
    [webView1 loadHTMLString:webStr baseURL:nil];
    [webView1 setScalesPageToFit:NO];
    [webView1  setUserInteractionEnabled:NO];
    [webView1 setBackgroundColor:[UIColor whiteColor]];
    webView1.delegate=self;
    webView1.opaque = NO;
    
//    webView.scrollView.bounces = NO; //__IPHONE_5_0
//    [self webViewDidFinishLoad:webView];
    [_scrollView addSubview:webView1];
    
    
    
    
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
    if(self.delegate){

        [self.delegate changeGoodFrame];
    }
    
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
    UIView *view_bar =[[UIView alloc]initWithFrame:CGRectMake(0,  self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    view_bar.backgroundColor=[UIColor whiteColor];
    view_bar.layer.borderColor=[UIColor colorWithRed:.9 green:.9  blue:.9  alpha:1.0].CGColor;
    view_bar.layer.borderWidth=1;
    [self.view addSubview:view_bar];
    
    UIButton*btnCall=[UIButton buttonWithType:0];
    btnCall.frame=CGRectMake(0, 0, view_bar.frame.size.width/5,  view_bar.frame.size.height);
    btnCall.backgroundColor=[UIColor clearColor];
    btnCall.userInteractionEnabled=YES;
    [btnCall addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
//    [btnCall setImage:BundleImage(@"shopbt_02_.png") forState:0];
    [view_bar addSubview:btnCall];
    
    UIImageView *callImg=[[UrlImageView alloc]initWithFrame:CGRectMake(20, 8, 24, 22)];
    callImg.image=[UIImage imageNamed:@"DetailsPage_btn_kehu"];
    [btnCall addSubview:callImg];
    UILabel *_label=[[UILabel alloc]initWithFrame:CGRectMake(callImg.frame.origin.x, callImg.frame.size.height+callImg.frame.origin.y+5,callImg.frame.size.width, 10)];
    _label.text=@"客服";
    _label.font=[UIFont boldSystemFontOfSize:10];
    _label.backgroundColor=[UIColor clearColor];
    _label.textColor =RGB(128, 128, 128);
    _label.numberOfLines=1;
    _label.textAlignment=NSTextAlignmentCenter;
    
    [btnCall addSubview:_label];

    
    //收藏
    UIButton*shoucangBtn=[UIButton buttonWithType:0];
    shoucangBtn.frame=CGRectMake(btnCall.frame.size.width+btnCall.frame.origin.x, 0, btnCall.width, view_bar.height);
    shoucangBtn.userInteractionEnabled=YES;
    shoucangBtn.backgroundColor=[UIColor clearColor];
    [shoucangBtn addTarget:self action:@selector(shoucang:) forControlEvents:UIControlEventTouchUpInside];
//    [shoucangBtn setImage:BundleImage(@"shopbt_02_.png") forState:0];
    [view_bar addSubview:shoucangBtn];
    UIImageView *scImg=[[UrlImageView alloc]initWithFrame:CGRectMake(20, 8, 24, 22)];
    scImg.image=[UIImage imageNamed:@"DetailsPage_btn_shouchang"];
    [shoucangBtn addSubview:scImg];
    UILabel *scLbl=[[UILabel alloc]initWithFrame:CGRectMake(scImg.frame.origin.x, scImg.frame.size.height+scImg.frame.origin.y+5,scImg.frame.size.width, 10)];
    scLbl.text=@"收藏";
    scLbl.font=[UIFont boldSystemFontOfSize:10];
    scLbl.backgroundColor=[UIColor clearColor];
    scLbl.textColor =RGB(128, 128, 128);
    scLbl.numberOfLines=1;
    scLbl.textAlignment=NSTextAlignmentCenter;
    
    [shoucangBtn addSubview:scLbl];
    
    //购物车
    UIButton *carBtn=[UIButton buttonWithType:0];
    carBtn.frame=CGRectMake(shoucangBtn.width+shoucangBtn.left, 0,shoucangBtn.width, shoucangBtn.height);
    carBtn.backgroundColor=[UIColor clearColor];
    carBtn.userInteractionEnabled=YES;
    [carBtn addTarget:self action:@selector(myShopCar:) forControlEvents:UIControlEventTouchUpInside];
//    [carBtn setImage:BundleImage(@"icon_Order") forState:0];
    [view_bar addSubview:carBtn];
    UIImageView *gwcImg=[[UrlImageView alloc]initWithFrame:CGRectMake(20, 8, 24, 22)];
    gwcImg.image=[UIImage imageNamed:@"TabBar_icon_Cart"];//icon_Order
    [carBtn addSubview:gwcImg];
    UILabel *gwcLbl=[[UILabel alloc]initWithFrame:CGRectMake(gwcImg.frame.origin.x-4, gwcImg.frame.size.height+gwcImg.frame.origin.y+6,gwcImg.frame.size.width+10, 10)];
    gwcLbl.text=@"购物车";
    gwcLbl.font=[UIFont boldSystemFontOfSize:10];
    gwcLbl.backgroundColor=[UIColor clearColor];
    gwcLbl.textColor =RGB(128, 128, 128);
    gwcLbl.numberOfLines=1;
    gwcLbl.textAlignment=NSTextAlignmentCenter;
    
    [carBtn addSubview:gwcLbl];

    //加入购物车
    UIButton*btnShop=[UIButton buttonWithType:0];
    btnShop.frame=CGRectMake(carBtn.width+carBtn.left, 0,view_bar.width-carBtn.width-carBtn.left, shoucangBtn.height);
    btnShop.userInteractionEnabled=YES;
    btnShop.backgroundColor=[UIColor clearColor];
    [btnShop addTarget:self action:@selector(addShopCar:) forControlEvents:UIControlEventTouchUpInside];
    [btnShop setImage:BundleImage(@"加入购物车_") forState:0];
    [view_bar addSubview:btnShop];
    
    
    
    return view_bar;
}
#pragma mark分享
-(void)btnShare:(id)sender
{
    NSString *ss=[NSString stringWithFormat:@"%@:\n 配夸网，淘全球，真无忧！\nhttp://www.peikua.com/?m=goods&g=detail&id=%@",self.goods.title,self.goods.id];
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UmengAppkey
                                          shareText:ss
                                         shareImage:nil
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms,UMShareToEmail,nil]
                                           delegate:nil];
    
    
}
#pragma mark添加购物车
-(void)addShopCar:(id)sender
{
    ChooseSizeViewController *chooseSizeViewController=[[ChooseSizeViewController alloc]init];
    //    chooseSizeViewController
    chooseSizeViewController.goods_attr=self.goods_attr;
    chooseSizeViewController.goods=self.goods;
    chooseSizeViewController.delegate=self;
    chooseSizeViewController.numCount=@"1";
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController pushViewController:chooseSizeViewController animated:YES];

}
#pragma mark 联系卖家
-(void)call:(id)sender
{
    ChatViewController *chat=[ChatViewController shareChat];
    chat.isHome=YES;
    [chat mechat];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil  action:nil]];
    [self.navigationController pushViewController:chat.viewController animated:YES];
    
}
#pragma mark 收藏
-(void)shoucang:(id)sender{
    NSDictionary *parameters = @{@"goods_id":self.goods.id};
    NSString* url =[NSString stringWithFormat:@"%@&f=addFav&m=user",requestUrl]
    ;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"addFav"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];

}
#pragma mark 接受数据
-(void) didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app stopLoading];
//    NSString *s_app_id=[dictemp objectForKey:@"s_app_id"];
//    NSString *status=[dictemp objectForKey:@"status"];
    //    if(![status isEqualToString:@"1"]){
    ////        [self showMessage:message];
    ////        return ;
    //    }
    if([urlname isEqualToString:@"addFav"]){
        ShowMessage(@"收藏成功");
    }
    
    if([urlname isEqualToString:@"getGoodsParityList"]){
        NSArray *dataArr=[dictemp objectForKey:@"data"];
        bijiaArr=[[NSMutableArray alloc]initWithCapacity:dataArr.count];
        for (NSDictionary *dic in dataArr) {
            BiJiaModel *biJiaModel= [BiJiaModel objectWithKeyValues:dic] ;
            [bijiaArr addObject:biJiaModel];
        }
        if(bijiaArr.count>0){
            [bijiaBtn setHidden:false];
//            [self showBijia];
        }else{
//            ShowMessage(@"暂无此类商品数据");
        }
    }
    if([urlname isEqualToString:@"getOneBrandGoods"]){
        NSArray *dataArr=[dictemp objectForKey:@"data"];
        tuijianGoods =[[NSMutableArray alloc]initWithCapacity:4];
        for (NSDictionary *dic in dataArr) {
            New_Goods *newsGoods=[New_Goods objectWithKeyValues:dic];
            [tuijianGoods addObject:newsGoods];
        }
        //显示推荐商品
        if(tuijianGoods.count>0){
            [self showTuijianShop];
        }
        
    }
    if([urlname isEqualToString:@"getGoodsDetail"]){
        NSDictionary *dataDic=[dictemp objectForKey:@"data"];
        NSDictionary *goods_detail=[dataDic objectForKey:@"goods_detail"];
        NSDictionary *goods_ext=[dataDic objectForKey:@"goods_ext"];
        NSArray *goods_image=[dataDic objectForKey:@"goods_image"];
        NSDictionary *goods_attr=[dataDic objectForKey:@"goods_attr"];
        //        NSArray *priceArr=[goods_attr objectForKey:@"price"];
        //        NSArray *attr_infoArr=[goods_attr objectForKey:@"attr_info"];
        NSArray *goods_parity=[dataDic objectForKey:@"goods_parity"];
        New_Goods *newGoods = [New_Goods objectWithKeyValues:goods_detail] ;
        Goods_Ext *goodsExt=[Goods_Ext objectWithKeyValues:goods_ext];
        //        NSDictionary *menuIndexDic=[dataDic objectForKey:@"cat_index"];
        HTGoodDetailsViewController *htGoodDetailsViewController=[[HTGoodDetailsViewController alloc]init];
        htGoodDetailsViewController.goods_parity=goods_parity;
        htGoodDetailsViewController.goods=newGoods;
        htGoodDetailsViewController.goods_attr=goods_attr;
        htGoodDetailsViewController.goodsExt=goodsExt;
        htGoodDetailsViewController.goods_image=goods_image;
        AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.navigationController pushViewController:htGoodDetailsViewController animated:YES];
        
    }

}
#pragma mark 比价
-(void)showBijia{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [_bgView setTag:99999];
    [_bgView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]];
    [_bgView setAlpha:1.0];
    
    [self.view addSubview:_bgView];
    rulerView = [[BiJiaView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH-50,SCREEN_HEIGHT)withBiJia:bijiaArr withGoods:self.goods];
    rulerView.tag = 100000;
    //    rulerView.menuDelegate = self;
    rulerView.backgroundColor=RGB(237,237,237);
    [_bgView addSubview:rulerView];
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:rulerView cache:NO];
    rulerView.frame= CGRectMake(50, 0, SCREEN_WIDTH-50, SCREEN_HEIGHT);
    UIImageView*_imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 6)];
    _imageView.image=BundleImage(@"ic_pull_shadow.png");
    [_bgView addSubview:_imageView];
    [UIView commitAnimations];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0 ,0, 50, SCREEN_HEIGHT);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(SetViewDisappear:) forControlEvents:UIControlEventTouchDown];
    [_bgView insertSubview:button aboveSubview:_bgView];
    button.backgroundColor=[UIColor clearColor];
}
//立即购买消失按钮
-(void)SetViewDisappear:(id)sender
{
    if (_bgView)
    {
        _bgView.backgroundColor=[UIColor clearColor];
        [UIView animateWithDuration:.5
                         animations:^{
                             
                             rulerView.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
                             _bgView.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
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
#pragma mark 我的购物车
-(void)myShopCar:(id)sender
{
    
    HTShopStoreCarViewController *shopStoreCarViewController=[[HTShopStoreCarViewController alloc]initWithTabbar:false];
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController pushViewController:shopStoreCarViewController animated:YES];
}


#pragma mark - 选择颜色尺寸
-(void)yansechicunBtn:(UrlImageButton *)sendid{
    ChooseSizeViewController *chooseSizeViewController=[[ChooseSizeViewController alloc]init];
//    chooseSizeViewController
    chooseSizeViewController.goods_attr=self.goods_attr;
    chooseSizeViewController.goods=self.goods;
    chooseSizeViewController.delegate=self;
    chooseSizeViewController.ischange=false;
    chooseSizeViewController.numCount=@"1";
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController pushViewController:chooseSizeViewController animated:YES];
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //若已经加载完成，则显示webView并return
//    if(isLoadingFinished)
//    {
//        [webView1 setHidden:NO];
//        
//        return;
//    }
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect webViewFrame = webView.frame;
    webViewFrame.size.height = actualSize.height;
    webView.frame = webViewFrame;
    
    [_scrollView setContentSize:CGSizeMake(self.view.width, webView.frame.size.height+webView.frame.origin.y+10)];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '70%'"];//修改百分比即可
    
    
    [self getShopEvaluation];
    
    
}
#pragma mark - 商品评价等
-(void)getShopEvaluation{
    //评论
//    pingjiaView=[[UIView alloc]initWithFrame:CGRectMake(0, webView1.frame.size.height+webView1.frame.origin.y+10, self.view.frame.size.width,80 )];
    pingjiaView=[[UIView alloc]initWithFrame:CGRectMake(0, webView1.frame.size.height+webView1.frame.origin.y, self.view.frame.size.width,80 )];
    pingjiaView.backgroundColor=[UIColor whiteColor];
//    [_scrollView addSubview:pingjiaView];
    
    UILabel *pingjiaLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
    pingjiaLbl.text=@"商品评价";
    pingjiaLbl.font=[UIFont boldSystemFontOfSize:14];
    pingjiaLbl.backgroundColor=[UIColor clearColor];
    pingjiaLbl.textColor =RGB(51, 51, 51);
    pingjiaLbl.textAlignment=0;
    [pingjiaView addSubview:pingjiaLbl];
    UILabel *pingjiaCountLbl=[[UILabel alloc]initWithFrame:CGRectMake(pingjiaLbl.left+pingjiaLbl.width, 10, 150, 20)];
    pingjiaCountLbl.text=[NSString stringWithFormat:@"(%@)",@"1212"];
    pingjiaCountLbl.font=[UIFont systemFontOfSize:14];
    pingjiaCountLbl.backgroundColor=[UIColor clearColor];
    pingjiaCountLbl.textColor =[UIColor redColor];
    pingjiaCountLbl.textAlignment=0;
    [pingjiaView addSubview:pingjiaCountLbl];
    UILabel *pingjiajianju=[[UILabel alloc] initWithFrame:CGRectMake(20, pingjiaCountLbl.top+pingjiaCountLbl.height+10, pingjiaView.width-40, 0.5)];
    pingjiajianju.backgroundColor=RGB(237, 237, 237);
    [pingjiaView addSubview:pingjiajianju];
    
    //评价方式
    UILabel *pingjiatypeLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, pingjiajianju.top+pingjiajianju.height+10, 80, 20)];
    pingjiatypeLbl.text=[NSString stringWithFormat:@"%@评价",@"默默"];
    pingjiatypeLbl.font=[UIFont systemFontOfSize:12];
    pingjiatypeLbl.backgroundColor=[UIColor clearColor];
    pingjiatypeLbl.textColor =  RGB(179, 179, 179);
    pingjiatypeLbl.textAlignment=0;
    [pingjiaView addSubview:pingjiatypeLbl];
    
    //评价内容
    UILabel *pingjiaContentLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, pingjiatypeLbl.top+pingjiatypeLbl.height+12, pingjiaView.width-20, 20)];
    pingjiaContentLbl.text=@"真心不错,好用的，下次再来买！";
    pingjiaContentLbl.font=[UIFont systemFontOfSize:12];
    pingjiaContentLbl.backgroundColor=[UIColor clearColor];
    pingjiaContentLbl.textColor =  RGB(128, 128, 128) ;
    pingjiaContentLbl.textAlignment=0;
    [pingjiaView addSubview:pingjiaContentLbl];
    
    
    //评价时间和评价人
    UILabel *pingjiatimeLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, pingjiaContentLbl.top+pingjiaContentLbl.height+12, 80, 20)];
    pingjiatimeLbl.text=@"2015-06-01";
    pingjiatimeLbl.font=[UIFont systemFontOfSize:12];
    pingjiatimeLbl.backgroundColor=[UIColor clearColor];
    pingjiatimeLbl.textColor =  RGB(237,237,237)  ;
    pingjiatimeLbl.textAlignment=0;
    [pingjiaView addSubview:pingjiatimeLbl];
    
    UILabel *pingjiarenLbl=[[UILabel alloc]initWithFrame:CGRectMake(pingjiatimeLbl.left+pingjiatimeLbl.width+12, pingjiatimeLbl.top, 80, 20)];
    pingjiarenLbl.text=@"白色乳霜";
    pingjiarenLbl.font=[UIFont systemFontOfSize:12];
    pingjiarenLbl.backgroundColor=[UIColor clearColor];
    pingjiarenLbl.textColor = RGB(255, 13, 94)  ;
    pingjiarenLbl.textAlignment=0;
    [pingjiaView addSubview:pingjiarenLbl];
    //线
    UILabel *pingjiajianju1=[[UILabel alloc] initWithFrame:CGRectMake(20, pingjiarenLbl.top+pingjiarenLbl.height+10, pingjiaView.width-40, 0.5)];
    pingjiajianju1.backgroundColor=RGB(237, 237, 237);
    [pingjiaView addSubview:pingjiajianju1];
    //查看更多
    UIButton *pingjiaMore=[UIButton buttonWithType:UIButtonTypeCustom];
    pingjiaMore.userInteractionEnabled=true;
    pingjiaMore.backgroundColor=[UIColor clearColor];
    pingjiaMore.frame =CGRectMake(pingjiaView.width/2-50, pingjiajianju1.frame.origin.y+pingjiajianju1.frame.size.height+10, 100, 30);
    [pingjiaMore setTitle:@"查看更多评论" forState:UIControlStateNormal];
    pingjiaMore.titleLabel.font = [UIFont systemFontOfSize:15];
    [pingjiaMore setTitleColor:hexColor(@"#18b112") forState:UIControlStateNormal];
//    [pingjiaMore addTarget:self action:@selector(quanqiubijia:) forControlEvents:UIControlEventTouchUpInside];
    [pingjiaView addSubview:pingjiaMore];
//    pingjiaView.height=pingjiaMore.height+pingjiaMore.top+10;
    pingjiaView.height=0;
    //购物流程QA
    gouwuQAView=[[UIView alloc]initWithFrame:CGRectMake(0, pingjiaView.frame.size.height+pingjiaView.frame.origin.y+10, self.view.frame.size.width,80 )];
    gouwuQAView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:gouwuQAView];
    
    UILabel *gouwuTitleLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
    gouwuTitleLbl.text=@"购物流程";
    gouwuTitleLbl.font=[UIFont boldSystemFontOfSize:14];
    gouwuTitleLbl.backgroundColor=[UIColor clearColor];
    gouwuTitleLbl.textColor =RGB(51, 51, 51);
    gouwuTitleLbl.textAlignment=0;
    [gouwuQAView addSubview:gouwuTitleLbl];
    UIImageView *gouwuliuchengImg=[[UIImageView alloc]initWithFrame:CGRectMake(0,gouwuTitleLbl.frame.size.height+gouwuTitleLbl.frame.origin.y,SCREEN_WIDTH,158)];
    
    [gouwuliuchengImg setContentMode:UIViewContentModeScaleAspectFill];
    gouwuliuchengImg.image=BundleImage(@"DetailsPage_img_gouwuliucheng");
    [gouwuliuchengImg setContentMode:UIViewContentModeScaleAspectFit];
    [gouwuQAView addSubview:gouwuliuchengImg];
    
     UILabel *jianju=[[UILabel alloc]initWithFrame:CGRectMake(0, gouwuliuchengImg.top+gouwuliuchengImg.height, SCREEN_WIDTH, 10)];
    jianju.backgroundColor=[UIColor colorWithRed:.98 green:.98 blue:.98 alpha:1.0];
    [gouwuQAView addSubview:jianju];

    
    //QA
    UILabel *qaTitleLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, gouwuliuchengImg.top+gouwuliuchengImg.height+18, 80, 20)];
    qaTitleLbl.text=@"常见Q&A";
    qaTitleLbl.font=[UIFont boldSystemFontOfSize:15];
    qaTitleLbl.backgroundColor=[UIColor clearColor];
    qaTitleLbl.textColor =hexColor(@"#18b112");
    qaTitleLbl.textAlignment=0;
    [gouwuQAView addSubview:qaTitleLbl];
    //线
    CGRect lastQAframe=qaTitleLbl.frame;
    for (int i=0; i<1; i++) {
        UIView *qaCounteView=[[UIView alloc]initWithFrame:CGRectMake(0, lastQAframe.origin.y+lastQAframe.size.height+10, gouwuQAView.width, 100)];
        [gouwuQAView addSubview:qaCounteView];
        UILabel *qaLine=[[UILabel alloc] initWithFrame:CGRectMake(20, 1, pingjiaView.width-40, 0.5)];
        qaLine.backgroundColor=RGB(237, 237, 237);
        [qaCounteView addSubview:qaLine];
        //问题标题
        UILabel *titleQA=[[UILabel alloc]initWithFrame:CGRectMake(10, 10,190, 10)];
        titleQA.text=@"购买的海淘商品，要多久到货？";
        titleQA.font=[UIFont boldSystemFontOfSize:11];
        titleQA.backgroundColor=[UIColor clearColor];
        titleQA.textColor =RGB(51, 51, 51);
        titleQA.textAlignment=0;
        [qaCounteView addSubview:titleQA];
        //具体内容
        UILabel *countentQA=[[UILabel alloc]initWithFrame:CGRectMake(10, titleQA.top+titleQA.height+10,qaCounteView.width-20, 10)];
        countentQA.text=@"    海淘购物，需要经过跨国运输、海关清关等环节。这和国内快递不同，一是手续相对繁杂、且运输环节较多，而且还存在着海关严查及其他不可抗力的情况。 鉴于此配夸网与国际和国内优质物流服务商达成合作，确保商品按时到达用户手中。日本发货商品一般为商城发货后3~5个工作日到货；美国发货商品一般为商城发货后10~17个工作日到货。";
        countentQA.font=[UIFont systemFontOfSize:11];
        countentQA.backgroundColor=[UIColor clearColor];
        countentQA.textColor = RGB(179, 179, 179);
        countentQA.textAlignment=0;
        countentQA.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
        countentQA.lineBreakMode=UILineBreakModeWordWrap;
        //高度固定不折行，根据字的多少计算label的宽度
        
        CGSize size = [countentQA.text sizeWithFont:countentQA.font
                                           constrainedToSize:CGSizeMake(countentQA.width, MAXFLOAT)
                                               lineBreakMode:NSLineBreakByWordWrapping];
        //        NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
        //根据计算结果重新设置UILabel的尺寸
        countentQA.height=size.height;

        [qaCounteView addSubview:countentQA];
        qaCounteView.height=countentQA.height+countentQA.top+10;
        lastQAframe=qaCounteView.frame;

    }
    //线
    UILabel *qaLine1=[[UILabel alloc] initWithFrame:CGRectMake(20, lastQAframe.origin.y+lastQAframe.size.height+10, gouwuQAView.width-40, 0.5)];
    qaLine1.backgroundColor=RGB(237, 237, 237);
    [gouwuQAView addSubview:qaLine1];
    //查看更多
    UIButton *gouwuxuzhiMore=[UIButton buttonWithType:UIButtonTypeCustom];
    gouwuxuzhiMore.userInteractionEnabled=true;
    gouwuxuzhiMore.backgroundColor=[UIColor clearColor];
    gouwuxuzhiMore.frame =CGRectMake(gouwuQAView.width/2-50, qaLine1.frame.origin.y+qaLine1.frame.size.height+10, 100, 30);
    [gouwuxuzhiMore setTitle:@"查看更多" forState:UIControlStateNormal];
    gouwuxuzhiMore.titleLabel.font = [UIFont systemFontOfSize:15];
    [gouwuxuzhiMore setTitleColor:hexColor(@"#18b112") forState:UIControlStateNormal];
    [gouwuxuzhiMore addTarget:self action:@selector(gouwuxuzhiMore:) forControlEvents:UIControlEventTouchUpInside];
    [gouwuQAView addSubview:gouwuxuzhiMore];
    
    gouwuQAView.height=gouwuxuzhiMore.height+gouwuxuzhiMore.top+10;
    
   
    [_scrollView setContentSize:CGSizeMake(320, gouwuQAView.frame.size.height+gouwuQAView.frame.origin.y+70)];
    //获取商品推荐
    [self getshopTuijianData];
    
}
#pragma mark 购物须知

-(void)gouwuxuzhiMore:(id)sender{
    
    QAViewController *gouWuXuZhiViewController=[[QAViewController alloc]init];
//    [self presentViewController:gouWuXuZhiViewController animated:YES completion:^{
//        
//    }];
    [self.navigationController pushViewController:gouWuXuZhiViewController animated:YES];
}
#pragma mark 获取商品推荐
- (void)getshopTuijianData{
    // "brand_id":"类别ID"
//    "per":"记录数 单品详情页面一般传4就可以"
    //    NSDictionary *parameters = @{@"id":@"626"};
    NSDictionary *parameters = @{@"brand_id":self.goods.brand_id,@"per":@"4"};
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getOneBrandGoods",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getOneBrandGoods"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
}
#pragma mark 显示推荐商品

-(void)showTuijianShop{
    tuijianView=[[UIView alloc]initWithFrame:CGRectMake(0, gouwuQAView.frame.size.height+gouwuQAView.frame.origin.y+10, self.view.frame.size.width,80 )];
    tuijianView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:tuijianView];
    //标题
    UILabel *tuijianTitleLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
    tuijianTitleLbl.text=@"商品推荐";
    tuijianTitleLbl.font=[UIFont boldSystemFontOfSize:14];
    tuijianTitleLbl.backgroundColor=[UIColor clearColor];
    tuijianTitleLbl.textColor =RGB(51, 51, 51);
    tuijianTitleLbl.textAlignment=0;
    [tuijianView addSubview:tuijianTitleLbl];
    
    CGRect lastFrame;
    for (int i =0; i<tuijianGoods.count; i++)
    {
        New_Goods *new_Goods=tuijianGoods[i];
        GoodImageButton *gbBtn=[[GoodImageButton alloc]initWithFrame:CGRectMake((i%2)*((SCREEN_WIDTH-20)/2-5+10)+10, floor(i/2)*190+10+40, (SCREEN_WIDTH-20)/2-5, 180)];
        gbBtn.userInteractionEnabled=YES;
        gbBtn.backgroundColor=[UIColor whiteColor];
        //            imageV.userInteractionEnabled=YES;
        //            btn.layer.shadowOffset = CGSizeMake(1,1);
        //            btn.layer.shadowOpacity = 0.2f;
        //            btn.layer.shadowRadius = 3.0;
        gbBtn.layer.borderWidth=0.5;//描边
        gbBtn.layer.cornerRadius=4;//圆角
        gbBtn.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
        gbBtn.goods=new_Goods;
        gbBtn.backgroundColor=[UIColor whiteColor];
        [gbBtn addTarget:self action:@selector(goodContentTouch:) forControlEvents:UIControlEventTouchUpInside];
        [tuijianView addSubview:gbBtn];
        
        UrlImageView*btn1=[[UrlImageView alloc]initWithFrame:CGRectMake((gbBtn.width/3/2), 10, gbBtn.frame.size.width*2/3, gbBtn.frame.size.width*2/3)];
        [btn1 setContentMode:UIViewContentModeScaleAspectFill];
        //            btn.userInteractionEnabled=YES;
        //            btn.layer.borderWidth=1;//描边
        //            btn.layer.cornerRadius=4;//圆角
        //            btn.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
        btn1.backgroundColor=RGBA(237, 237, 237, 1);
        
        NSString *urlStr=new_Goods.img_260;
        if((urlStr==nil)||[urlStr isEqualToString:@""]){
            btn1.image=BundleImage(@"df_04_.png");
            
        }else{
            NSURL *imgUrl=[NSURL URLWithString:urlStr];
            [btn1 setImageWithURL:imgUrl];
        }
        
        //            [btn addTarget:self action:@selector(goodContentTouch:) forControlEvents:UIControlEventTouchUpInside];
        //            [imageV addSubview:btn];
        //商店名
        [gbBtn addSubview:btn1];
        UILabel *_label=[[UILabel alloc]initWithFrame:CGRectMake(0, btn1.frame.size.width+5+btn1.frame.origin.y, gbBtn.width, 10)];
        _label.text=new_Goods.shop_name;
        _label.font=[UIFont boldSystemFontOfSize:10];
        _label.backgroundColor=[UIColor clearColor];
        _label.textColor =hexColor(@"#b3b3b3");
        _label.numberOfLines=1;
        _label.textAlignment=NSTextAlignmentCenter;
        
        [gbBtn addSubview:_label];
        //商品名
        UILabel *_label1=[[UILabel alloc]initWithFrame:CGRectMake(10, _label.frame.size.height+_label.frame.origin.y+1, gbBtn.frame.size.width-10-10, 30)];
        _label1.text=new_Goods.title;
        _label1.font=[UIFont boldSystemFontOfSize:11];
        _label1.backgroundColor=[UIColor clearColor];
        _label1.textColor =hexColor(@"#333333");
        _label1.lineBreakMode = UILineBreakModeWordWrap;
        _label1.numberOfLines=2;
        _label1.textAlignment=NSTextAlignmentCenter;
        
        [gbBtn addSubview:_label1];
        
        
        
        
        UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(0, _label1.frame.size.height+_label1.frame.origin.y+1 ,gbBtn.frame.size.width, 20)];
        title_label.text=[NSString stringWithFormat:@"￥%.2f",new_Goods.price_cn];
        
        title_label.font=[UIFont boldSystemFontOfSize:14];
        title_label.backgroundColor=[UIColor clearColor];
        title_label.textColor =hexColor(@"#ff0d5e");
        title_label.textAlignment=NSTextAlignmentCenter;
        
        //
        [gbBtn addSubview:title_label];
        lastFrame =gbBtn.frame;
        
    }
    tuijianView.height=lastFrame.size.height+lastFrame.origin.y;
    //    lastFrameForPage=xinpinContentView.frame;
    [_scrollView setContentSize:CGSizeMake(320, tuijianView.size.height+tuijianView.origin.y+70)];
}
#pragma mark 获取商品详情
- (void)goodContentTouchDo:(GoodImageButton *)sender
{
    New_Goods *goods=sender.goods;
    //    NSDictionary *parameters = @{@"id":@"626"};
    NSDictionary *parameters = @{@"id":goods.id};
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsDetail",requestUrl]
    ;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getGoodsDetail"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
}

-(void)goodContentTouch:(GoodImageButton *)sender{
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(goodContentTouchDo:) object:sender];
    [self performSelector:@selector(goodContentTouchDo:) withObject:sender afterDelay:0.2f];
}
#pragma mark 商品专区
- (void)shopquQuery:(id)sender{
    CFContentForDicKeyViewController *contentForDicKeyViewController=[[CFContentForDicKeyViewController alloc]init];
    NSDictionary *dic=@{@"shop":self.goods.shop_id,@"need_cat_index":@1};
    contentForDicKeyViewController.keyDic=dic;
    contentForDicKeyViewController.topTitle=self.goods.shop_name;
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController pushViewController:contentForDicKeyViewController animated:YES];
}
#pragma mark 品牌专区
- (void)brandQuQuery:(id)sender{
    CFContentForDicKeyViewController *contentForDicKeyViewController=[[CFContentForDicKeyViewController alloc]init];
    NSDictionary *dic=@{@"brand":self.goods.brand_id,@"need_cat_index":@1};
    contentForDicKeyViewController.keyDic=dic;
    contentForDicKeyViewController.topTitle=self.goods.brand_name;

    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController pushViewController:contentForDicKeyViewController animated:YES];
}
#pragma mark 全球比价查询
- (void)queryBiJia{
    NSDictionary *parameters = @{@"id":self.goods.id};
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsParityList",requestUrl]
    ;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getGoodsParityList"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];

}
#pragma mark 全球比价
- (void)quanqiubijia:(id)sender{
    //    NSDictionary *parameters = @{@"id":@"626"};
    if(bijiaArr.count>0){
        [self showBijia];
    }else{
        NSDictionary *parameters = @{@"id":self.goods.id};
        NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsParityList",requestUrl]
        ;
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app startLoading];
        HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getGoodsParityList"];
        httpController.delegate = self;
        [httpController onSearchForPostJson];
    }
    
}
- (void)addShopCarFinsh:(NSDictionary *)dic{
    ShowMessage(@"添加成功");
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
