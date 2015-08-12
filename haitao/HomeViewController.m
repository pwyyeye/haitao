//
//  HomeViewController.m
//  haitao
//
//  Created by SEM on 15/7/17.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "HomeViewController.h"
#import"EScrollerView.h"
#import "Toolkit.h"
#import "UrlImageButton.h"
#import "HTGoodDetailsViewController.h"
#import "App_Home_Bigegg.h"
#import "New_Goods.h"
#import "SVPullToRefresh.h"
#import "CFImageButton.h"
#import "GoodImageButton.h"
#import "SpecialContentViewController.h"
#import "SpecialModel.h"
@interface HomeViewController ()
{
    UrlImageButton *btn;
    UILabel *label1;
    UrlImageButton *fourBtn;
    UILabel *fourLab;
    UIView *_view;
    UILabel *label2;
    UILabel *label3;
    UIView *qiangouContentView;
    UIView *jingpinContentView;
    UIView *guojimingpinContentView;
    UIView *xinpinContentView;
    EScrollerView *scroller;
    NSArray *topMenuArr;
    NSMutableArray *jingpinPageArr;
    NSMutableArray *jingpinArr;
    
}
@property (nonatomic,strong)DJRefresh *refresh;
@end

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self._scrollView triggerPullToRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    app_home_bigegg=[[NSMutableArray alloc]init] ;//首页通栏即广告栏
    app_home_grab=[[NSMutableArray alloc]init];//手机端抢购
    app_home_command=[[NSMutableArray alloc]init];//手机端精品推荐
    app_home_brand=[[NSMutableArray alloc]init];//手机端国际名品
    new_goods=[[NSMutableArray alloc]init];//手机端国际名品
    NSDictionary *dic1=@{@"img":@"jingpintuijian_icon_topbar_xsfm_",@"title":@"孝敬父母"};
    NSDictionary *dic2=@{@"img":@"jingpintuijian_icon_topbar_dsxn_",@"title":@"都市型男"};
    NSDictionary *dic3=@{@"img":@"jingpintuijian_icon_topbar_cxz_",@"title":@"尝鲜者"};
    NSDictionary *dic4=@{@"img":@"jingpintuijian_icon_topbar_scmp_",@"title":@"奢侈名牌"};
    topMenuArr=@[dic1,dic2,dic3,dic4];
    jingpinPageArr=[[NSMutableArray alloc]initWithArray:@[@"home_img_jingpintuijian_leftup",@"home_img_jingpintuijian_rightup",@"home_img_jingpintuijian_leftdown",@"home_img_jingpintuijian_rightdown"]];
    
    nowpage = @"0";
    new_goods_pageDic=[[NSMutableDictionary alloc]init];
    self._scrollView=[[UIScrollView alloc]initWithFrame:self.mainFrame];
    if (IS_IPHONE_5) {
        
        [self._scrollView setContentSize:CGSizeMake(320, self.view.frame.size.height+100)];
    }else{
        [self._scrollView setContentSize:CGSizeMake(320, self.view.frame.size.height+120)];
    }
    self._scrollView.showsVerticalScrollIndicator=NO;
   self._scrollView.backgroundColor=RGB(237,237,237);
    [self.view addSubview:self._scrollView];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _refresh=[[DJRefresh alloc] initWithScrollView:self._scrollView delegate:self];
    _refresh.topEnabled=YES;
    _refresh.bottomEnabled=YES;
    
    if (_type==eRefreshTypeProgress) {
        [_refresh registerClassForTopView:[DJRefreshProgressView class]];
    }
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topButton setFrame:CGRectMake(self._scrollView.width-60, self._scrollView.top+self._scrollView.height-40, 40, 40)];
    topButton.userInteractionEnabled=YES;
    
    
    [topButton setBackgroundImage:[UIImage imageNamed:@"home_btn_top_"] forState:UIControlStateNormal];
    [topButton addTarget:self action:@selector(topButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:topButton];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self reloadAll];
//    isfirst=true;
//    [_refresh startRefreshingDirection:DJRefreshDirectionTop animation:YES];
//    __weak HomeViewController *weakSelf = self;
    /*
    [self._scrollView addPullToRefreshWithActionHandler:^{
//        [weakSelf insertRowAtTop];
        [weakSelf reloadAll];
        
    }];
    
    // setup infinite scrolling
    [self._scrollView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf insertRowAtBottom];
        int pageCount= [new_goods_pageDic allKeys].count;
        int nowPageCount=nowpage.intValue;
        if(nowPageCount>=pageCount){
            
        }else{
            nowPageCount =nowpage.intValue+1;
            nowpage=[NSString stringWithFormat:@"%d",nowPageCount];
            [weakSelf reloadDeals];
            
        }
    }];
    
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _scrollView;
    _header.delegate = self;
    
    // 4.3行集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _scrollView;
    _footer.delegate = self;
    [_header endRefreshing];
    [_footer endRefreshing];
    [self getMenuData];
    */
    // Do any additional setup after loading the view.
}
#pragma mark - 下拉刷新页面
-(void)reloadAll{
    for(UIView *view in [self._scrollView subviews])
    {
        [view removeFromSuperview];
        
    }
    [app_home_bigegg removeAllObjects] ;//首页通栏即广告栏
    [app_home_grab removeAllObjects];//手机端抢购
    [app_home_command removeAllObjects];//手机端精品推荐
    [app_home_brand removeAllObjects];//手机端国际名品
    [new_goods removeAllObjects];//手机端国际名品
    [new_goods_pageDic removeAllObjects];
    nowpage =@"0";
    [self._scrollView.pullToRefreshView stopAnimating];
    
    [self getMenuData];
}
- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction{
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * USEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addDataWithDirection:direction];
        });
    
    
    
}
- (void)addDataWithDirection:(DJRefreshDirection)direction{
    
    if (direction==DJRefreshDirectionTop) {
        [self reloadAll];
    }else{
        int pageCount= (int)[new_goods_pageDic allKeys].count;
        int nowPageCount=nowpage.intValue;
        if(nowPageCount>=pageCount){
            
        }else{
            nowPageCount =nowpage.intValue+1;
            nowpage=[NSString stringWithFormat:@"%d",nowPageCount];
            [self reloadDeals];
            
        }

    }
    

    
    [_refresh finishRefreshingDirection:direction animation:YES];
    
    
    
}
/*
#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _header)
    { // 下拉刷新
       
    }
    else if(refreshView == _footer)
    {
        
    }
}
 */
#pragma mark

#pragma mark
- (void)reloadDeals
{
    [self getNewGoods];
//    [self._scrollView.pullToRefreshView stopAnimating];
//    [_footer endRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self._scrollView){
        self._scrollView.frame=self.mainFrame;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)drawViewRect
{
    

    
    //
//    [imagePathArray addObject:[dic objectForKey:@"ititle"]];
//    [titleArray addObject:[dic objectForKey:@"mainHeading"]];
//    [idArray addObject:[dic objectForKey:@"id"]];
    NSMutableArray *bigArr=[[NSMutableArray alloc]init];
    for (App_Home_Bigegg *bigTemp in app_home_bigegg) {
        NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
        [dicTemp setObject:bigTemp.img_url forKey:@"ititle"];
        [dicTemp setObject:bigTemp.content forKey:@"mainHeading"];
        [bigArr addObject:dicTemp];
    }
    scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, 320, 160)
                                                          scrolArray:[NSArray arrayWithArray:bigArr] needTitile:YES];
    
    scroller.delegate=self;
    scroller.backgroundColor=[UIColor clearColor];
    [self._scrollView addSubview:scroller];
    //手机端抢购title
    UIView *qiangouTitleView=[[UIView alloc]initWithFrame:CGRectMake(0,scroller.frame.size.height+scroller.frame.origin.y+10, self.view.frame.size.width, 43)];
    qiangouTitleView.backgroundColor=[UIColor whiteColor];
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"QiangGuoView" owner:nil options:nil];
    UIView *qianggouView= [nibView objectAtIndex:0];
    qianggouView.clipsToBounds = YES;
    qianggouView.frame = CGRectMake(55, 7, 127, 25);
    [qiangouTitleView addSubview:qianggouView];
    //色条
    UIImageView *hongLine=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 3, qiangouTitleView.height)];
    hongLine.backgroundColor=RGB(255, 13, 94);
    [qiangouTitleView addSubview:hongLine];
    
    //标题
    UILabel *qiangouLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 23/2, 40, 20)];
    qiangouLbl.text=@"抢购";
    qiangouLbl.textColor=RGB(51, 51, 51);
    qiangouLbl.font=[UIFont boldSystemFontOfSize:14];
    qiangouLbl.textAlignment=0;
    qiangouLbl.backgroundColor=[UIColor clearColor];
    [qiangouTitleView addSubview:qiangouLbl];
    
    //更多
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [moreButton setFrame:CGRectMake(qiangouTitleView.width-15-50, 13, 40, 15)];
    moreButton.userInteractionEnabled=YES;

    
    [moreButton setBackgroundImage:[UIImage imageNamed:@"home_icon_qianggou_more_"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
   
    [qiangouTitleView addSubview:moreButton];
    
    [self._scrollView addSubview:qiangouTitleView];
//    CGRect maxFrame = {0,0,0,0};
    //具体内容
    qiangouContentView=[[UIView alloc]initWithFrame:CGRectMake(0,qiangouTitleView.frame.size.height+qiangouTitleView.frame.origin.y,self._scrollView.width , 43)];
    qiangouContentView.backgroundColor=[UIColor whiteColor];
    [self._scrollView addSubview:qiangouContentView];
    for (int i =0; i<app_home_grab.count; i++)
    {
        App_Home_Bigegg *grabModel=app_home_grab[i];
        btn=[[UrlImageButton alloc]initWithFrame:CGRectMake(20+i*(self._scrollView.width-80)/3+i*20, 10, (self._scrollView.width-80)/3, (self._scrollView.width-80)/3)];
        NSURL *imgUrl=[NSURL URLWithString:grabModel.img_url];
        [btn setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"default_02.png"]];
        btn.tag=i;
//        [btn setImage:[UIImage imageNamed:@"default_02.png"] forState:0];
//        - (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
        [qiangouContentView addSubview:btn];
        [btn addTarget:self action:@selector(qianggouAct:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor=[UIColor clearColor];
        
        label1=[[UILabel alloc]initWithFrame:CGRectMake(btn.left, btn.frame.size.height+btn.frame.origin.y+3, btn.width, 15)];
        label1.text=grabModel.content;
        label1.textColor =hexColor(@"#333333");
        label1.font=[UIFont systemFontOfSize:11];
        label1.textAlignment=1;
        label1.backgroundColor=[UIColor clearColor];
//        label1.lineBreakMode = UILineBreakModeWordWrap;
        label1.numberOfLines = 1;
//        CGRect txtFrame = label1.frame;
        [qiangouContentView addSubview:label1];
        
        label2=[[UILabel alloc]initWithFrame:CGRectMake(label1.left, label1.frame.size.height+label1.frame.origin.y, label1.width, 20)];
        label2.text=[NSString stringWithFormat:@"￥%.2f",grabModel.price];
        label2.font=[UIFont boldSystemFontOfSize:14];
        label2.backgroundColor=[UIColor clearColor];
        label2.textColor =hexColor(@"#ff0d5e");
        label2.textAlignment=1;
        label2.backgroundColor=[UIColor clearColor];
//        if(maxFrame.origin.y<label2.frame.origin.y){
//            maxFrame=label2.frame;
//        }
        [qiangouContentView addSubview:label2];
        
    }
    qiangouContentView.height=label2.height+label2.origin.y+10;
    //手机端精品推荐
    //手机端抢购title
    UIView *jingpintuijianTitleView=[[UIView alloc]initWithFrame:CGRectMake(0,qiangouContentView.height+qiangouContentView.frame.origin.y+10, self.view.frame.size.width, 43)];
    jingpintuijianTitleView.backgroundColor=[UIColor whiteColor];
    //色条
    UIImageView *huangLine=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 3, qiangouTitleView.height)];
    huangLine.backgroundColor=RGB(255, 228, 157);
    [jingpintuijianTitleView addSubview:huangLine];

    
    //标题
    UILabel *jingpintuijianLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 23/2, 140, 20)];
    jingpintuijianLbl.text=@"精品推荐";
    jingpintuijianLbl.textColor=RGB(51, 51, 51);
    jingpintuijianLbl.font=[UIFont boldSystemFontOfSize:14];
    jingpintuijianLbl.textAlignment=0;
    jingpintuijianLbl.backgroundColor=[UIColor clearColor];
    [jingpintuijianTitleView addSubview:jingpintuijianLbl];
    
    [self._scrollView addSubview:jingpintuijianTitleView];
    
    jingpinContentView=[[UIView alloc]initWithFrame:CGRectMake(0,jingpintuijianTitleView.height+jingpintuijianTitleView.frame.origin.y, jingpintuijianTitleView.width, 100)];
    jingpinContentView.backgroundColor=[UIColor whiteColor];
    [self._scrollView addSubview:jingpinContentView];
    CGRect lastFram1;
    for (int i =0; i<topMenuArr.count; i++)
    {
        NSDictionary *menuTemp=topMenuArr[i];
        NSString *imgname=[menuTemp objectForKey:@"img"];
        NSString *menutitle=[menuTemp objectForKey:@"title"];
        CFImageButton *btnNine=[[CFImageButton alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4)];
        //            [btnNine setImage:[UIImage imageNamed:topMenuArr[i]] forState:0];
        
        btnNine.backgroundColor=[UIColor clearColor];
        [btnNine addTarget:self action:@selector(jingpinMenu:) forControlEvents:UIControlEventTouchUpInside];
        btnNine.tag=i;
        [jingpinContentView addSubview:btnNine];
        
        UrlImageView*image=[[UrlImageView alloc]initWithFrame:CGRectMake(btnNine.frame.size.width*0.3125, btnNine.frame.size.height*0.2125, btnNine.frame.size.width*0.375, btnNine.frame.size.width*0.375)];
        [btnNine addSubview:image];
        [image setContentMode:UIViewContentModeScaleAspectFill];
        [image setImage:[UIImage imageNamed:imgname]];
        image.layer.borderWidth=1;
        image.layer.cornerRadius = 4;
        image.layer.borderColor = [[UIColor clearColor] CGColor];
        image.backgroundColor=[UIColor clearColor];
        
        //            UILabel *labelLine=[[UILabel alloc]initWithFrame:CGRectMake(2, 50+10, 70-4, 1)];
        //            labelLine.backgroundColor=[UIColor grayColor];
        //            [btnNine addSubview:labelLine];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, image.frame.size.height+image.frame.origin.y+btnNine.frame.size.height/10, btnNine.frame.size.width, 10)];
        label.font = [UIFont boldSystemFontOfSize:10.0f];  //UILabel的字体大小
        label.numberOfLines = 1;  //必须定义这个属性，否则UILabel不会换行
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;  //文本对齐方式
        [label setBackgroundColor:[UIColor whiteColor]];
        label.text=menutitle;
        lastFram1=btnNine.frame;
        [btnNine addSubview:label];
    }
    CGRect lastFram;
    for (int i=0; i<jingpinPageArr.count; i++) {
        CFImageButton *btnNine=[[CFImageButton alloc]initWithFrame:CGRectMake(20+(jingpinContentView.width-40-123)*(i%2), floor(i/2)*123+10+lastFram1.origin.y+lastFram1.size.height, 123, 123)];
//        (i%2)*123+20+(jingpinContentView.width-40-123*2)*(i%2)
        btnNine.backgroundColor=[UIColor clearColor];
        [btnNine addTarget:self action:@selector(btnFenlei:) forControlEvents:UIControlEventTouchUpInside];
        btnNine.tag=i;
        [btnNine setImage:[UIImage imageNamed:jingpinPageArr[i]] forState:0];
        lastFram=btnNine.frame;
        [jingpinContentView addSubview:btnNine];
    }
    jingpinContentView.height=lastFram.size.height+2+lastFram.origin.y;
//    for (int i =0; i<app_home_command.count; i++)
//    {
//        App_Home_Bigegg *grabModel=app_home_command[i];
//        fourBtn=[[UrlImageButton alloc]initWithFrame:CGRectMake(12+i*75, jingpintuijianTitleView.frame.size.height+jingpintuijianTitleView.frame.origin.y+8, 70, 70)];
//        [fourBtn addTarget:self action:@selector(btnShopStore:) forControlEvents:UIControlEventTouchUpInside];
//        [self._scrollView addSubview:fourBtn];
//        [fourBtn setBackgroundImage: [UIImage imageNamed:@"default_02.png"] forState:0];
//         NSURL *imgUrl=[NSURL URLWithString:grabModel.img_url];
//        [fourBtn setImageWithURL:imgUrl];
//        fourLab=[[UILabel alloc]initWithFrame:CGRectMake(12+i*75, fourBtn.frame.size.height+fourBtn.frame.origin.y+8, 70, 20)];
//        fourLab.text=grabModel.content;
//        fourLab.textColor=[UIColor grayColor];
//        fourLab.font=[UIFont boldSystemFontOfSize:10];
//        fourLab.textAlignment=1;
//        fourLab.backgroundColor=[UIColor clearColor];
//        [self._scrollView addSubview:fourLab];
//        
//    }
    
    
    //手机端国际名品
    UIView *guojimingpinTitleView=[[UIView alloc]initWithFrame:CGRectMake(0,jingpinContentView.height+jingpinContentView.frame.origin.y+10, self.view.frame.size.width, 43)];
    guojimingpinTitleView.backgroundColor=[UIColor whiteColor];
    //色条
    UIImageView *langLine=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 3, guojimingpinTitleView.height)];
    langLine.backgroundColor=RGB(156, 249, 255);
    [guojimingpinTitleView addSubview:langLine];
    
    
    //标题
    UILabel *guojiLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 23/2, 140, 20)];
    guojiLbl.text=@"国际名品";
    guojiLbl.textColor=RGB(51, 51, 51);
    guojiLbl.font=[UIFont boldSystemFontOfSize:14];
    guojiLbl.textAlignment=0;
    guojiLbl.backgroundColor=[UIColor clearColor];
    [guojimingpinTitleView addSubview:guojiLbl];
    
    [self._scrollView addSubview:guojimingpinTitleView];
    //国际名品内容
    guojimingpinContentView=[[UIView alloc]initWithFrame:CGRectMake(0,guojimingpinTitleView.height+guojimingpinTitleView.frame.origin.y, guojimingpinTitleView.width, 154)];
    guojimingpinContentView.backgroundColor=[UIColor whiteColor];
    [self._scrollView addSubview:guojimingpinContentView];
//    for (int i =0; i<app_home_brand.count; i++)
//    {
//        App_Home_Bigegg *grabModel=app_home_brand[i];
//        
//        
//    }
    UrlImageButton *gjmp_left=[[UrlImageButton alloc]initWithFrame:CGRectMake(30,0, 149, 149)];
    //        (i%2)*123+20+(jingpinContentView.width-40-123*2)*(i%2)
    gjmp_left.backgroundColor=[UIColor clearColor];
    [gjmp_left addTarget:self action:@selector(btnFenlei:) forControlEvents:UIControlEventTouchUpInside];
    gjmp_left.tag=0;
//    [gjmp_left setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"home_bg_guojimingpin_shangpin_datu_zhong"]];
    [gjmp_left setImage:[UIImage imageNamed:@"home_bg_guojimingpin_shangpin_datu_zhong"] forState:0];
    [guojimingpinContentView addSubview:gjmp_left];
    
    UrlImageButton *rightUp=[[UrlImageButton alloc]initWithFrame:CGRectMake(guojimingpinContentView.width-72-10-20,0, 72, 72)];
    //        (i%2)*123+20+(jingpinContentView.width-40-123*2)*(i%2)
    rightUp.backgroundColor=[UIColor clearColor];
    [rightUp addTarget:self action:@selector(btnFenlei:) forControlEvents:UIControlEventTouchUpInside];
    rightUp.tag=1;
//    [rightUp setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"home_bg_guojimingpin_shangpin_xiaotu_zhong"]];
    [rightUp setImage:[UIImage imageNamed:@"home_bg_guojimingpin_shangpin_xiaotu_zhong"] forState:0];
    [guojimingpinContentView addSubview:rightUp];
    
    UrlImageButton *rightdown=[[UrlImageButton alloc]initWithFrame:CGRectMake(guojimingpinContentView.width-72-10-20,149-72, 72, 72)];
    //        (i%2)*123+20+(jingpinContentView.width-40-123*2)*(i%2)
    rightdown.backgroundColor=[UIColor clearColor];
    [rightdown setImage:[UIImage imageNamed:@"home_bg_guojimingpin_shangpin_xiaotu"] forState:0];

    [rightdown addTarget:self action:@selector(btnFenlei:) forControlEvents:UIControlEventTouchUpInside];
    rightdown.tag=2;
//    [rightdown setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"home_bg_guojimingpin_shangpin_xiaotu"]];
    [guojimingpinContentView addSubview:rightdown];
    
    //新品推荐
    UIView *xinpintuijianTitleView=[[UIView alloc]initWithFrame:CGRectMake(0,guojimingpinContentView.height+guojimingpinContentView.frame.origin.y+10, self.view.frame.size.width, 43)];
    xinpintuijianTitleView.backgroundColor=[UIColor whiteColor];
    //色条
    UIImageView *tuhuangLine=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 3, xinpintuijianTitleView.height)];
    tuhuangLine.backgroundColor=RGB(251, 187, 155);
    [xinpintuijianTitleView addSubview:tuhuangLine];
    
    
    //标题
    UILabel *xinpinLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 23/2, 140, 20)];
    xinpinLbl.text=@"新品推荐";
    xinpinLbl.textColor=RGB(51, 51, 51);
    xinpinLbl.font=[UIFont boldSystemFontOfSize:14];
    xinpinLbl.textAlignment=0;
    xinpinLbl.backgroundColor=[UIColor clearColor];
    [xinpintuijianTitleView addSubview:xinpinLbl];
    
    [self._scrollView addSubview:xinpintuijianTitleView];
    //新品推荐内容
    xinpinContentView=[[UIView alloc]initWithFrame:CGRectMake(0,xinpintuijianTitleView.height+xinpintuijianTitleView.frame.origin.y, xinpintuijianTitleView.width, 154)];
    xinpinContentView.backgroundColor=[UIColor whiteColor];
    [self._scrollView addSubview:xinpinContentView];
    GoodImageButton *gbBtn;
    CGRect lastFrame;
    NSArray *goodsPageArr=[new_goods_pageDic objectForKey:nowpage];
    for (int i =0; i<goodsPageArr.count; i++)
    {
        New_Goods *new_Goods=goodsPageArr[i];
        gbBtn=[[GoodImageButton alloc]initWithFrame:CGRectMake((i%2)*((xinpinContentView.width-20)/2-5+10)+10, floor(i/2)*190+10, (xinpinContentView.width-20)/2-5, 180)];
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
        [xinpinContentView addSubview:gbBtn];
        
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
        lastFrameForPage=gbBtn.frame;
    }
    xinpinContentView.height=lastFrame.size.height+lastFrame.origin.y;
//    lastFrameForPage=xinpinContentView.frame;
    [self._scrollView setContentSize:CGSizeMake(320, xinpinContentView.size.height+xinpinContentView.origin.y+10)];
    
   
    
}
-(void)getNewGoods{

    NSArray *goodsPageArr=[new_goods_pageDic objectForKey:nowpage];
    GoodImageButton *gbBtn;
    for (int i =0; i<goodsPageArr.count; i++)
    {
        New_Goods *new_Goods=goodsPageArr[i];
        gbBtn=[[GoodImageButton alloc]initWithFrame:CGRectMake((i%2)*((xinpinContentView.width-20)/2-5+10)+10, floor(i/2)*190+lastFrameForPage.origin.y+lastFrameForPage.size.height+10, (xinpinContentView.width-20)/2-5, 180)];
        gbBtn.userInteractionEnabled=YES;
        gbBtn.backgroundColor=[UIColor whiteColor];
        //            imageV.userInteractionEnabled=YES;
        //            btn.layer.shadowOffset = CGSizeMake(1,1);
        //            btn.layer.shadowOpacity = 0.2f;
        //            btn.layer.shadowRadius = 3.0;
        gbBtn.layer.borderWidth=1;//描边
        gbBtn.layer.cornerRadius=4;//圆角
        gbBtn.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
        gbBtn.goods=new_Goods;
        gbBtn.backgroundColor=[UIColor whiteColor];
        [gbBtn addTarget:self action:@selector(goodContentTouch:) forControlEvents:UIControlEventTouchUpInside];
        [xinpinContentView addSubview:gbBtn];
        
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
    }
    lastFrameForPage=gbBtn.frame;
    xinpinContentView.height=gbBtn.height+10+gbBtn.top;
    [self._scrollView setContentSize:CGSizeMake(320, xinpinContentView.height+xinpinContentView.top+10)];
}
-(void)btnTouch:(id)sender{
    
}
-(void)getMenuData{
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [app startLoading];
    //    http://www.peikua.com/app.php?app.php?m=home&a=app&f=getHomeData
    NSString* url =[NSString stringWithFormat:@"%@&m=home&f=getHomeData",requestUrl]
    ;
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:GETURL withUrlName:@"getHomeData"];
    httpController.delegate = self;
    [httpController onSearch];
}

//获取数据
-(void) didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [app stopLoading];
    NSString *s_app_id=[dictemp objectForKey:@"s_app_id"];
    NSString *status=[dictemp objectForKey:@"status"];
    //    if(![status isEqualToString:@"1"]){
    ////        [self showMessage:message];
    ////        return ;
    //    }
    if([urlname isEqualToString:@"getHomeData"]){
         NSDictionary *dic=[dictemp objectForKey:@"data"];
        if ((NSNull *)dic == [NSNull null]) {
            showMessage(@"暂无数据!");
            //            [self showMessage:@"暂无数据!"];
            return;
            
        }
//        app_home_bigegg=[[NSMutableArray alloc]init] ;//首页通栏即广告栏
//        app_home_grab=[[NSMutableArray alloc]init];//手机端抢购
//        app_home_command=[[NSMutableArray alloc]init];//手机端精品推荐
//        app_home_brand=[[NSMutableArray alloc]init];//手机端国际名品
//        new_goods=[[NSMutableArray alloc]init];//新品推荐
        NSDictionary *ad_infoDic=[dic objectForKey:@"ad_info"];
       //首页通栏即广告栏
        NSArray *app_home_bigeggArr= [ad_infoDic objectForKey:@"app_home_bigegg"];
        for (NSDictionary *bigeggDic in app_home_bigeggArr) {
            App_Home_Bigegg *app_Home_Bigegg= [App_Home_Bigegg objectWithKeyValues:bigeggDic] ;
            [app_home_bigegg addObject:app_Home_Bigegg];
        }
        //手机端抢购
        NSArray *app_home_grabArr= [ad_infoDic objectForKey:@"app_home_grab"];
        for (NSDictionary *grabDic in app_home_grabArr) {
            App_Home_Bigegg *app_Home_Bigegg= [App_Home_Bigegg objectWithKeyValues:grabDic] ;
            [app_home_grab addObject:app_Home_Bigegg];
        }
        //手机端精品推荐
        NSArray *app_home_commandArr= [ad_infoDic objectForKey:@"app_home_command"];
        for (NSDictionary *commandDic in app_home_commandArr) {
            App_Home_Bigegg *app_Home_Bigegg= [App_Home_Bigegg objectWithKeyValues:commandDic] ;
            [app_home_command addObject:app_Home_Bigegg];
        }
        //手机端国际名品
        NSArray *app_home_brandArr= [ad_infoDic objectForKey:@"app_home_brand"];
        for (NSDictionary *brandDic in app_home_brandArr) {
            App_Home_Bigegg *app_Home_Bigegg= [App_Home_Bigegg objectWithKeyValues:brandDic] ;
            [app_home_brand addObject:app_Home_Bigegg];
        }
        //新品推荐
        NSDictionary *new_goodsDic= [dic objectForKey:@"new_goods"];
        NSArray *new_goodsArr= [new_goodsDic objectForKey:@"list"];
        for (NSDictionary *goodsDic in new_goodsArr) {
            New_Goods *new_Goods= [New_Goods objectWithKeyValues:goodsDic] ;
            [new_goods addObject:new_Goods];
        }
        int pageKey=0;
        int nowCount=1;
        NSMutableArray *pageArr=[[NSMutableArray alloc]initWithCapacity:6];
        for (int i=0; i<new_goods.count; i++) {
            New_Goods *new_Goods= new_goods[i];
            
            if(nowCount%6==0){
                [pageArr addObject:new_Goods];
                NSString *key = [NSString stringWithFormat:@"%d",pageKey];
                [new_goods_pageDic setValue:pageArr forKey:key];
                pageKey++;
               pageArr=[[NSMutableArray alloc]initWithCapacity:6];
            }else{
                [pageArr addObject:new_Goods];
                if(i==new_goods.count-1){
                    NSString *key = [NSString stringWithFormat:@"%d",pageKey];
                    [new_goods_pageDic setValue:pageArr forKey:key];
                }
            }
            nowCount++;
        }
        [self drawViewRect];
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
    //专题
    if([urlname isEqualToString:@"getSubjectInfo"]){
        NSDictionary *dataDic=[dictemp objectForKey:@"data"];
        NSDictionary *detailDic=[dataDic objectForKey:@"detail"];
        NSArray *goodsArr=[dataDic objectForKey:@"goods"];
        SpecialModel *specialModel= [SpecialModel objectWithKeyValues:detailDic] ;
        NSMutableArray *goodsModelArr=[[NSMutableArray alloc]init];
        for (NSDictionary *dic in goodsArr) {
            New_Goods *goodsModel = [New_Goods objectWithKeyValues:dic] ;
            [goodsModelArr addObject:goodsModel];
        }
        NSDictionary *spdic=@{@"detail":specialModel,@"goods":goodsModelArr};
        SpecialContentViewController *specialContentViewController=[[SpecialContentViewController alloc]init];
        specialContentViewController.spcDic=spdic;
        AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.navigationController pushViewController:specialContentViewController animated:YES];
    }
}
-(void)EScrollerViewDidClicked:(NSUInteger)index{
//    NSLog([NSString stringWithFormat:@"第几个%ld",index]);
    App_Home_Bigegg *bigegg=app_home_bigegg[index];
    int adType=bigegg.ad_type;
    if(adType==2){
    //商品
        NSDictionary *parameters = @{@"id":bigegg.goods_id};
        NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsDetail",requestUrl]
        ;
        
        HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getGoodsDetail"];
        httpController.delegate = self;
        [httpController onSearchForPostJson];
    }else if (adType==3){
        //专题
        NSDictionary *parameters = @{@"id":bigegg.subject_id};
        NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getSubjectInfo",requestUrl]
        ;
        
        HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getSubjectInfo"];
        httpController.delegate = self;
        [httpController onSearchForPostJson];
    }else if (adType==4){
        
    }else if (adType==5){
        
    }
}
#pragma mark 获取商品详情
-(void)goodContentTouch:(GoodImageButton *)sender{
    New_Goods *goods=sender.goods;
    //    NSDictionary *parameters = @{@"id":@"626"};
    NSDictionary *parameters = @{@"id":goods.id};
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsDetail",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getGoodsDetail"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
}
-(void)qianggouAct:(UrlImageButton *)sender{
    App_Home_Bigegg *grabModel=app_home_grab[sender.tag];
    NSDictionary *parameters = @{@"id":grabModel.goods_id};
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsDetail",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getGoodsDetail"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];

}
-(void)btnFenlei:(id)sender{

}
-(void)btnShopStore:(id)sender
{
    
    //
}

#pragma mark 更多
-(void)moreButtonClicked:(id)button{
    ShowMessage(@"暂无更多内容");
}

#pragma mark 回到顶部
-(void)topButtonClicked:(id)button{
    [self._scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark 精品菜单
-(void)jingpinMenu:(id)button{
    
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
