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
    
    
    [_refresh startRefreshingDirection:DJRefreshDirectionTop animation:YES];
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
    qianggouView.frame = CGRectMake(55, 7, 127, 29);
    [qiangouTitleView addSubview:qianggouView];
    //色条
    UIImageView *hongLine=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 3, qiangouTitleView.height)];
    hongLine.backgroundColor=RGB(255, 13, 94);
    [qiangouTitleView addSubview:hongLine];
    
    //标题
    UILabel *qiangouLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 23/2, 40, 20)];
    qiangouLbl.text=@"抢购";
    qiangouLbl.textColor=RGB(128, 128, 128);
    qiangouLbl.font=[UIFont boldSystemFontOfSize:14];
    qiangouLbl.textAlignment=0;
    qiangouLbl.backgroundColor=[UIColor clearColor];
    [qiangouTitleView addSubview:qiangouLbl];
    
    //更多
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [moreButton setFrame:CGRectMake(qiangouTitleView.width-15-50, 10, 40, 20)];
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
//        [btn setImage:[UIImage imageNamed:@"default_02.png"] forState:0];
//        - (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
        [qiangouContentView addSubview:btn];
        [btn addTarget:self action:@selector(btnGoodsList:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor=[UIColor clearColor];
        
        label1=[[UILabel alloc]initWithFrame:CGRectMake(btn.left, btn.frame.size.height+btn.frame.origin.y+3, btn.width, 20)];
        label1.text=grabModel.content;
        label1.textColor =hexColor(@"#333333");
        label1.font=[UIFont systemFontOfSize:11];
        label1.textAlignment=1;
        label1.backgroundColor=[UIColor clearColor];
//        label1.lineBreakMode = UILineBreakModeWordWrap;
        label1.numberOfLines = 1;
//        CGRect txtFrame = label1.frame;
        [qiangouContentView addSubview:label1];
        
        label2=[[UILabel alloc]initWithFrame:CGRectMake(label1.left, label1.frame.size.height+label1.frame.origin.y+3, label1.width, 20)];
        label2.text=[NSString stringWithFormat:@"￥%.f",grabModel.price];
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
    jingpintuijianLbl.textColor=RGB(128, 128, 128);
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
        [btnNine addTarget:self action:@selector(btnFenlei:) forControlEvents:UIControlEventTouchUpInside];
        btnNine.tag=i;
        [jingpinContentView addSubview:btnNine];
        
        UrlImageView*image=[[UrlImageView alloc]initWithFrame:CGRectMake(btnNine.frame.size.width*0.3125, btnNine.frame.size.height*0.2125, btnNine.frame.size.width*0.375, btnNine.frame.size.width*0.375)];
        [btnNine addSubview:image];
        
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
    UIImageView *img2=[[UIImageView alloc]initWithFrame:CGRectMake(0,jingpinContentView.frame.size.height+jingpinContentView.frame.origin.y+10 , self.view.frame.size.width, 33)];
    img2.image=BundleImage(@"titlebar.png");
    img2.backgroundColor=[UIColor clearColor];
    [self._scrollView addSubview:img2];
    for (int i =0; i<app_home_brand.count; i++)
    {
        App_Home_Bigegg *grabModel=app_home_brand[i];
        fourBtn=[[UrlImageButton alloc]initWithFrame:CGRectMake(12+i*75, img2.frame.size.height+img2.frame.origin.y+8, 90, 90)];
        [fourBtn addTarget:self action:@selector(btnShopStore:) forControlEvents:UIControlEventTouchUpInside];
        [self._scrollView addSubview:fourBtn];
        [fourBtn setBackgroundImage: [UIImage imageNamed:@"default_02.png"] forState:0];
        NSURL *imgUrl=[NSURL URLWithString:grabModel.img_url];
        [fourBtn setImageWithURL:imgUrl];
        fourLab=[[UILabel alloc]initWithFrame:CGRectMake(12+i*75, fourBtn.frame.size.height+fourBtn.frame.origin.y+8, 70, 20)];
        fourLab.text=grabModel.content;
        fourLab.textColor=[UIColor grayColor];
        fourLab.font=[UIFont boldSystemFontOfSize:10];
        fourLab.textAlignment=1;
        fourLab.backgroundColor=[UIColor clearColor];
        [self._scrollView addSubview:fourLab];
        
    }
    //新品推荐
    UIImageView *img3=[[UIImageView alloc]initWithFrame:CGRectMake(0,fourLab.frame.size.height+fourLab.frame.origin.y+6 , self.view.frame.size.width, 33)];
    img3.image=BundleImage(@"titlebar.png");
    img3.backgroundColor=[UIColor clearColor];
    [self._scrollView addSubview:img3];
    UrlImageView *imageV;
    CGRect lastFrame;
    NSArray *goodsPageArr=[new_goods_pageDic objectForKey:nowpage];
    for (int i =0; i<goodsPageArr.count; i++)
    {
        New_Goods *new_Goods=goodsPageArr[i];
        imageV=[[UrlImageView alloc]initWithFrame:CGRectMake((i%2)*153+13, floor(i/2)*200+10+img3.frame.size.height+img3.frame.origin.y, 140, 140)];
        imageV.backgroundColor=[UIColor redColor];
        imageV.userInteractionEnabled=YES;
        //            btn.layer.shadowOffset = CGSizeMake(1,1);
        //            btn.layer.shadowOpacity = 0.2f;
        //            btn.layer.shadowRadius = 3.0;
        imageV.layer.borderWidth=1;//描边
        imageV.layer.cornerRadius=4;//圆角
        imageV.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
        imageV.backgroundColor=[UIColor whiteColor];
        lastFrameForPage=imageV.frame;
        [self._scrollView addSubview:imageV];
        
        UrlImageButton*btn=[[UrlImageButton alloc]initWithFrame:CGRectMake(2, 2, 140-4, 140-4)];
        btn.userInteractionEnabled=YES;
        btn.layer.borderWidth=1;//描边
        btn.layer.cornerRadius=4;//圆角
        btn.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
        btn.backgroundColor=[UIColor whiteColor];
        
        NSString *urlStr=new_Goods.img_190;
        if(![urlStr isEqualToString:@""]){
            [btn setBackgroundImage:BundleImage(@"df_04_.png") forState:0];
        }else{
            NSURL *imgUrl=[NSURL URLWithString:urlStr];
            [btn setImageWithURL:imgUrl];
        }
       
        [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
        //            [imageV addSubview:btn];
        [imageV insertSubview:btn aboveSubview:imageV];
        
        UILabel *_label=[[UILabel alloc]initWithFrame:CGRectMake((i%2)*153+13, floor(i/2)*200+10+140+img3.frame.size.height+img3.frame.origin.y, 140, 40)];
        _label.text=new_Goods.title;
        _label.font=[UIFont boldSystemFontOfSize:14];
        _label.backgroundColor=[UIColor clearColor];
        _label.textColor =[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
        _label.numberOfLines=2;
        _label.textAlignment=0;
        
        [self._scrollView addSubview:_label];
        
        
        //            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 20, 15)];
        //            label.font = [UIFont boldSystemFontOfSize:10.0f];  //UILabel的字体大小
        //            label.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
        //            label.textColor = [UIColor grayColor];
        //            label.textAlignment = NSTextAlignmentCenter;  //文本对齐方式
        //            [label setBackgroundColor:[UIColor whiteColor]];
        //
        //            //高度固定不折行，根据字的多少计算label的宽度
        //            NSString *str = @"高度";
        //            CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, label.frame.size.height)];
        //            //        NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
        //            //根据计算结果重新设置UILabel的尺寸
        //            [label setFrame:CGRectMake((70-size.width)/2, 52, size.width+4, 15)];
        //            label.text = str;
        
        
        UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake((i%2)*153+13, floor(i/2)*200+140+10+_label.frame.size.height+img3.frame.size.height+img3.frame.origin.y, 65, 20)];
        title_label.text=[NSString stringWithFormat:@"%f",new_Goods.price];
        
        title_label.font=[UIFont systemFontOfSize:12];
        title_label.backgroundColor=[UIColor clearColor];
        title_label.textColor =hongShe;
        title_label.textAlignment=0;
        lastFrame=title_label.frame;
        //
        [self._scrollView addSubview:title_label];
        
        UILabel *title_label1=[[UILabel alloc]initWithFrame:CGRectMake((i%2)*153+13+title_label.frame.size.width, floor(i/2)*200+140+10+_label.frame.size.height+img3.frame.size.height+img3.frame.origin.y, 65, 20)];
        title_label1.text=@"199.70";
        title_label1.font=[UIFont systemFontOfSize:10];
        title_label1.backgroundColor=[UIColor clearColor];
        title_label1.textColor =[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1.0];
        title_label1.textAlignment=0;
        
        [self._scrollView addSubview:title_label1];
        
        //高度固定不折行，根据字的多少计算label的宽度
        NSString *str = title_label1.text;
        CGSize size = [str sizeWithFont:title_label.font constrainedToSize:CGSizeMake(MAXFLOAT, title_label.frame.size.height)];
        //                     NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
        //根据计算结果重新设置UILabel的尺寸
        
        
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, title_label1.frame.size.height/2, size.width, 1)];
        line.image=BundleImage(@"line_01_.png");
        [title_label1 addSubview:line];
        
    }
    [self._scrollView setContentSize:CGSizeMake(320, lastFrame.size.height+lastFrame.origin.y+10)];
    
   
    
}
-(void)getNewGoods{
    UrlImageView *imageV;
    CGRect lastFrame;
    NSArray *goodsPageArr=[new_goods_pageDic objectForKey:nowpage];
    for (int i =0; i<goodsPageArr.count; i++)
    {
        New_Goods *new_Goods=goodsPageArr[i];
        imageV=[[UrlImageView alloc]initWithFrame:CGRectMake((i%2)*153+13, floor(i/2)*200+10+lastFrameForPage.origin.y+200, 140, 140)];
        imageV.backgroundColor=[UIColor redColor];
        imageV.userInteractionEnabled=YES;
        //            btn.layer.shadowOffset = CGSizeMake(1,1);
        //            btn.layer.shadowOpacity = 0.2f;
        //            btn.layer.shadowRadius = 3.0;
        imageV.layer.borderWidth=1;//描边
        imageV.layer.cornerRadius=4;//圆角
        imageV.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
        imageV.backgroundColor=[UIColor whiteColor];
        
        [self._scrollView addSubview:imageV];
        
        UrlImageButton*btn=[[UrlImageButton alloc]initWithFrame:CGRectMake(2, 2, 140-4, 140-4)];
        btn.userInteractionEnabled=YES;
        btn.layer.borderWidth=1;//描边
        btn.layer.cornerRadius=4;//圆角
        btn.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
        btn.backgroundColor=[UIColor whiteColor];
        
        NSString *urlStr=new_Goods.img_190;
        if(![urlStr isEqualToString:@""]){
            [btn setBackgroundImage:BundleImage(@"df_04_.png") forState:0];
        }else{
            NSURL *imgUrl=[NSURL URLWithString:urlStr];
            [btn setImageWithURL:imgUrl];
        }
        
        [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
        //            [imageV addSubview:btn];
        [imageV insertSubview:btn aboveSubview:imageV];
        
        UILabel *_label=[[UILabel alloc]initWithFrame:CGRectMake((i%2)*153+13, floor(i/2)*200+10+140+lastFrameForPage.origin.y+200, 140, 40)];
        _label.text=new_Goods.title;
        _label.font=[UIFont boldSystemFontOfSize:14];
        _label.backgroundColor=[UIColor clearColor];
        _label.textColor =[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
        _label.numberOfLines=2;
        _label.textAlignment=0;
        
        [self._scrollView addSubview:_label];
        
        
      
        
        
        UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake((i%2)*153+13, floor(i/2)*200+140+10+_label.frame.size.height+lastFrameForPage.origin.y+200, 65, 20)];
        title_label.text=[NSString stringWithFormat:@"%f",new_Goods.price];
        
        title_label.font=[UIFont systemFontOfSize:12];
        title_label.backgroundColor=[UIColor clearColor];
        title_label.textColor =hongShe;
        title_label.textAlignment=0;
        lastFrame=title_label.frame;
        //
        [self._scrollView addSubview:title_label];
        
        UILabel *title_label1=[[UILabel alloc]initWithFrame:CGRectMake((i%2)*153+13+title_label.frame.size.width, floor(i/2)*200+140+10+_label.frame.size.height+lastFrameForPage.origin.y+200, 65, 20)];
        title_label1.text=@"199.70";
        title_label1.font=[UIFont systemFontOfSize:10];
        title_label1.backgroundColor=[UIColor clearColor];
        title_label1.textColor =[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1.0];
        title_label1.textAlignment=0;
        
        [self._scrollView addSubview:title_label1];
        
        //高度固定不折行，根据字的多少计算label的宽度
        NSString *str = title_label1.text;
        CGSize size = [str sizeWithFont:title_label.font constrainedToSize:CGSizeMake(MAXFLOAT, title_label.frame.size.height)];
        //                     NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
        //根据计算结果重新设置UILabel的尺寸
        
        
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, title_label1.frame.size.height/2, size.width, 1)];
        line.image=BundleImage(@"line_01_.png");
        [title_label1 addSubview:line];
        
    }
    lastFrameForPage=imageV.frame;
    [self._scrollView setContentSize:CGSizeMake(320, lastFrame.size.height+lastFrame.origin.y+10)];
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
    
    
}
-(void)EScrollerViewDidClicked:(NSUInteger)index{
    NSLog([NSString stringWithFormat:@"第几个%ld",index]);
}
-(void)btnShopStore:(id)sender
{
    
    //
}
-(void)btnGoodsList:(id)sender
{
    HTGoodDetailsViewController *shop=[[HTGoodDetailsViewController alloc]init];
    AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.navigationController pushViewController:shop animated:YES];
    //HTGoodsDetailsViewController
}
#pragma mark 更多
-(void)moreButtonClicked:(id)button{
    
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
