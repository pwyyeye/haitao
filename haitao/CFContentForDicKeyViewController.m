//
//  CFContentForDicKeyViewController.m
//  haitao
//
//  Created by SEM on 15/8/12.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "CFContentForDicKeyViewController.h"
#import "New_Goods.h"
#import "ScreenViewController.h"
#import "GoodImageButton.h"
#import "Goods_Ext.h"
#import "HTGoodDetailsViewController.h"
#import "ShaiXuanBtn.h"
@interface CFContentForDicKeyViewController ()
{
    UITableView                 *_tableView;
    UrlImageView *imageV;
    UIView *view_bar1;
    ShaiXuanBtn*btnItem1; //上部五个按钮
    ShaiXuanBtn*btnItem2;
    ShaiXuanBtn*btnItem3;
    ShaiXuanBtn*btnItem4;
    ShaiXuanBtn*btnItem5;
    
    UIImageView*  tabBarArrow;//上部桔红线条
    UITextField *fromPriceText;//价格
    UITextField *toPriceText;
    UIButton*zhiyouBtn;
    UIButton*zhuanyunBtn;
    UIView *nullview;
}
@end

@implementation CFContentForDicKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageCount=@"1";
    UIView *naviView=(UIView*) [self getNavigationBar];
    _tableView =[[UITableView alloc]initWithFrame:(CGRect){0,naviView.frame.size.height,self.view.frame.size.width,kWindowHeight-naviView.frame.size.height} style:UITableViewStylePlain];
    nullview=[[UIView alloc]initWithFrame:(CGRect){0,naviView.frame.size.height,self.view.frame.size.width,kWindowHeight-naviView.frame.size.height}];
    nullview.backgroundColor=RGB(237,237,237);
    nullview.hidden=true;
    [self addView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorColor=[UIColor clearColor];
    _refresh=[[DJRefresh alloc] initWithScrollView:_tableView delegate:self];
    _refresh.bottomEnabled=YES;
    //    _tableView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:_tableView];
    [self.view addSubview:nullview];
    listArr =[[NSMutableArray alloc]init];
    
    _inParameters=[self.keyDic mutableCopy];
    shaixuanDic=[self.keyDic mutableCopy];
    self.navigationController.title=[_keyDic objectForKey:@"keyword"]?[_keyDic objectForKey:@"keyword"]:self.topTitle;
    
    [self getGoodsList];
    
    
//    [self getGoodlist:self.dataList];
//    NSDictionary *parameters = @{@"s_cat":self.menuid,@"need_cat_index":@1};
//    _inParameters=[parameters mutableCopy];
    // Do any additional setup after loading the view.
}
-(void)addView{
    //没有搜到相关商品
    UIView *nosouView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, nullview.width, 200)];
    nosouView.backgroundColor=[UIColor whiteColor];
    UILabel *contentLal=[[UILabel alloc]initWithFrame:CGRectMake(0, (nosouView.height-20)/2, nosouView.width, 20)];
    contentLal.text=@"没有搜到相关商品";
    contentLal.font=[UIFont boldSystemFontOfSize:15];
    contentLal.backgroundColor=[UIColor clearColor];
    contentLal.textColor =RGB(128, 128, 128);
    contentLal.textAlignment=NSTextAlignmentCenter;
    [nosouView addSubview:contentLal];
    [nullview addSubview:nosouView];
    //你可继续
    UIView *anniuView=[[UIView alloc]initWithFrame:CGRectMake(0, nosouView.height+nosouView.top+10, nullview.width, 110)];
    
    anniuView.backgroundColor=[UIColor whiteColor];
    [nullview addSubview:anniuView];
    UILabel *jixuLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 20)];
    jixuLbl.text=@"你可继续";
    jixuLbl.font=[UIFont boldSystemFontOfSize:13];
    jixuLbl.backgroundColor=[UIColor clearColor];
    jixuLbl.textColor =RGB(51, 51, 51);
    jixuLbl.textAlignment=0;
    [anniuView addSubview:jixuLbl];
    UILabel *qaLine=[[UILabel alloc] initWithFrame:CGRectMake(20, jixuLbl.top+jixuLbl.height+5, anniuView.width-40, 0.5)];
    qaLine.backgroundColor=RGB(237, 237, 237);
    [anniuView addSubview:qaLine];
    //返回首页按钮
    UIButton *homeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"返回首页"] forState:UIControlStateNormal];
    homeBtn.userInteractionEnabled=true;
    homeBtn.backgroundColor=[UIColor clearColor];
    homeBtn.frame =CGRectMake(50,(anniuView.height-qaLine.height-qaLine.top-35)/2+qaLine.height+qaLine.top , 40, 35);
    [homeBtn addTarget:self action:@selector(backHome:) forControlEvents:UIControlEventTouchUpInside];
    [anniuView addSubview:homeBtn];
    //重新搜索
    UIButton *serchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [serchBtn setBackgroundImage:[UIImage imageNamed:@"重新搜索"] forState:UIControlStateNormal];
    serchBtn.userInteractionEnabled=true;
    serchBtn.backgroundColor=[UIColor clearColor];
    serchBtn.frame =CGRectMake(anniuView.width-50-40,(anniuView.height-qaLine.height-qaLine.top-35)/2+qaLine.height+qaLine.top , 40, 35);
    [serchBtn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [anniuView addSubview:serchBtn];
}
#pragma mark  下拉刷新
- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addDataWithDirection:direction];
    });
    
}
#pragma mark  下拉刷新
- (void)addDataWithDirection:(DJRefreshDirection)direction{
    
    if (direction==DJRefreshDirectionTop) {
        
    }else{
        [self getXialaData];
    }
    [_refresh finishRefreshingDirection:direction animation:YES];
    
    
    
}
-(void)getXialaData{
    int pageCountInt=pageCount.intValue;
    pageCountInt++;
    pageCount=[NSString stringWithFormat:@"%d",pageCountInt];
    [_inParameters removeObjectForKey:@"p"];
    [_inParameters setObject:pageCount forKey:@"p"];
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsList",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:_inParameters withUrlName:@"getGoodsListPage"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
}
-(void)backHome:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backHome" object:nil];
}
#pragma mark - Navigation
-(UIView*)getNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    view_bar1 =[[UIView alloc]init];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>6.1)
    {
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width, 44+20);
        view_bar1.backgroundColor =RGB(255, 13, 94);
        
        
    }else{
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width,44);
         view_bar1.backgroundColor =RGB(255, 13, 94);
        
    }
   
    
    [self.view addSubview:view_bar1];
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(65, (view_bar1.frame.size.height-20-44)/2+20, self.view.frame.size.width-130, 44)];
    title_label.text=self.topTitle;
    title_label.font=[UIFont boldSystemFontOfSize:20];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =[UIColor whiteColor];
    title_label.textAlignment=1;
    [view_bar1 addSubview:title_label];
    UIButton*btnBack=[UIButton buttonWithType:0];
    btnBack.frame=CGRectMake(0, (view_bar1.frame.size.height-20-34)/2+20, 47, 34);
    [btnBack setImage:BundleImage(@"btn_back") forState:0];
    [btnBack addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [view_bar1 addSubview:btnBack];
    return view_bar1;
}
#pragma mark退出
-(void)btnBack:(id)sender
{
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -根据条件获取商品信息
-(void)getGoodsList{
    pageCount=@"1";
    _inParameters=[self.keyDic mutableCopy];
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsList",requestUrl]
    ;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:self.keyDic withUrlName:@"getGoodsListForKey"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
}
#pragma mark 接受数据
-(void) didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    if([urlname isEqualToString:@"getGoodsListForKey"]){
        NSDictionary *dataDic=[dictemp objectForKey:@"data"];
        NSArray *goodsArr=[dataDic objectForKey:@"list"];
        NSMutableArray *goodsModelArr=[[NSMutableArray alloc]init];
        for (NSDictionary *dic in goodsArr) {
            New_Goods *goodsModel = [New_Goods objectWithKeyValues:dic] ;
            [goodsModelArr addObject:goodsModel];
        }
        if(goodsModelArr.count<1){
            nullview.hidden=false;
//            ShowMessage(@"无数据");
            return;
        }
        nullview.hidden=true;
        [self getGoodlist:goodsModelArr];
        
    }
    if([urlname isEqualToString:@"getGoodsListPage"]){
        NSDictionary *dataDic=[dictemp objectForKey:@"data"];
        NSArray *goodsArr=[dataDic objectForKey:@"list"];
        NSMutableArray *goodsModelArr=[[NSMutableArray alloc]init];
        for (NSDictionary *dic in goodsArr) {
            New_Goods *goodsModel = [New_Goods objectWithKeyValues:dic] ;
            [goodsModelArr addObject:goodsModel];
        }
        [self getGoodlistTwoPage:goodsModelArr];
        
        
        
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
        //        htGoodDetailsViewController.delegate=self;
        AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.navigationController pushViewController:htGoodDetailsViewController animated:YES];
        
    }
}
#pragma mark商品分页数据排2列
-(void)getGoodlistTwoPage:(NSArray *)arr{
    int nowCount=1;
    NSMutableArray *addArr=[[NSMutableArray alloc]init];
    NSMutableArray *pageArr=[[NSMutableArray alloc]initWithCapacity:2];
    int count=(int)listArr.count;
    for (int i=0; i<arr.count; i++) {
        New_Goods *new_Goods= arr[i];
        
        if(nowCount%2==0){
            [pageArr addObject:new_Goods];
            [addArr addObject:pageArr];
            [listArr addObject:pageArr];
            pageArr=[[NSMutableArray alloc]initWithCapacity:2];
        }else{
            [pageArr addObject:new_Goods];
            if(i==arr.count-1){
                [addArr addObject:pageArr];
                [listArr addObject:pageArr];
            }
        }
        nowCount++;
    }
    NSMutableArray *indexArr=[[NSMutableArray alloc]init];
    for (int i=0; i<addArr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count+i inSection:0];
        [indexArr addObject:indexPath];
    }
    [_tableView insertRowsAtIndexPaths:indexArr  withRowAnimation:UITableViewRowAnimationBottom];
}

#pragma mark 获取数据刷新
-(void)getFilterResult:(NSArray *)resultArray{
    btnItem1.selected=false;
    btnItem2.selected=false;
    btnItem3.selected=false;
    btnItem4.selected=false;
    btnItem2.isup=true;
    btnItem3.isup=true;
    btnItem4.isup=true;
    [self getGoodlist:resultArray];
}
#pragma mark获取商品数据
-(void)getGoodlist:(NSArray *)arr{
    int nowCount=1;
    [listArr removeAllObjects];
    NSMutableArray *pageArr=[[NSMutableArray alloc]initWithCapacity:2];
    for (int i=0; i<arr.count; i++) {
        New_Goods *new_Goods= arr[i];
        
        if(nowCount%2==0){
            [pageArr addObject:new_Goods];
            [listArr addObject:pageArr];
            pageArr=[[NSMutableArray alloc]initWithCapacity:2];
        }else{
            [pageArr addObject:new_Goods];
            if(i==arr.count-1){
                [listArr addObject:pageArr];
            }
        }
        nowCount++;
    }
    [_tableView reloadData];
}

#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArr.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 33;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return  [self getToolBar];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cate_cell";
    
    UITableViewCell *cell =nil;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
        
    }
    CGRect lastFrame;
    NSArray *arrTemp=listArr[indexPath.row];
    
    for (int i =0; i<arrTemp.count; i++)
    {
        New_Goods *new_Goods=arrTemp[i];
        
        
        GoodImageButton *gbBtn=[[GoodImageButton alloc]initWithFrame:CGRectMake((i%2)*((SCREEN_WIDTH-20)/2-5+10)+10, floor(i/2)*190+10, (SCREEN_WIDTH-20)/2-5, 180)];
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
        [cell addSubview:gbBtn];
        
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
        _label.font=[UIFont boldSystemFontOfSize:9];
        _label.backgroundColor=[UIColor clearColor];
        _label.textColor =hexColor(@"#b3b3b3");
        _label.numberOfLines=1;
        _label.textAlignment=NSTextAlignmentCenter;
        
        [gbBtn addSubview:_label];
        //商品名
        UILabel *_label1=[[UILabel alloc]initWithFrame:CGRectMake(10, _label.frame.size.height+_label.frame.origin.y+1, gbBtn.frame.size.width-10-10, 30)];
        _label1.text=new_Goods.title;
        _label1.font=[UIFont boldSystemFontOfSize:10];
        _label1.backgroundColor=[UIColor clearColor];
        _label1.textColor =RGB(51, 51, 51);
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
    CGRect cellFrame = [cell frame];
    cellFrame.origin=CGPointMake(0, 0);
    cellFrame.size.width=SCREEN_WIDTH;
    cellFrame.size.height=lastFrame.size.height+10;
    
    [cell setFrame:cellFrame];
    
    
    
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    
    //    TMThirdClassViewController *goods=[[TMThirdClassViewController alloc]init];
    //
    //    [delegate.navigationController pushViewController:goods animated:YES];
}
#pragma mark置顶按钮栏
-(UIView*)getToolBar
{
    UIView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,33 )];
    imageView.backgroundColor=[UIColor clearColor];
    imageView.userInteractionEnabled=YES;
    //    [self.view addSubview:imageView];
    if(!btnItem1){
        btnItem1 = [ShaiXuanBtn buttonWithType:UIButtonTypeCustom];
        [btnItem1 setFrame:CGRectMake(0, 0, imageView.width/5, imageView.height)];
        btnItem1.exclusiveTouch=YES;
        btnItem1.tag = 100;
        [btnItem1 setImage:[UIImage imageNamed:@"filter_btn_moren_default"] forState:UIControlStateNormal];
        [btnItem1 setImage:[UIImage imageNamed:@"filter_btn_moren_selected"] forState:UIControlStateSelected];
        btnItem1.selected=true;
        btnItem1.backgroundColor=[UIColor whiteColor];
        [btnItem1 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [imageView addSubview:btnItem1];
    if(!btnItem2){
        btnItem2 = [ShaiXuanBtn buttonWithType:UIButtonTypeCustom];
        [btnItem2 setFrame:CGRectMake(self.view.width/5*1, 0, imageView.width/5, imageView.height)];
        
        btnItem2.exclusiveTouch=YES;
        btnItem2.tag = 101;
        btnItem2.isup=true;
        [btnItem2 setImage:[UIImage imageNamed:@"filter_btn_xiaoliang_default"] forState:UIControlStateNormal];
        [btnItem2 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [imageView addSubview:btnItem2];
    if(!btnItem3){
        btnItem3 = [ShaiXuanBtn buttonWithType:UIButtonTypeCustom];
        [btnItem3 setFrame:CGRectMake(self.view.width/5*2, 0, imageView.width/5, imageView.height)];
        btnItem3.exclusiveTouch=YES;
        btnItem3.tag = 102;
        btnItem3.isup=true;
        [btnItem3 setImage:[UIImage imageNamed:@"filter_btn_zhekou_default"] forState:UIControlStateNormal];
        [btnItem3 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [imageView addSubview:btnItem3];
    if(!btnItem4){
        btnItem4 = [ShaiXuanBtn buttonWithType:UIButtonTypeCustom];
        [btnItem4 setFrame:CGRectMake(self.view.width/5*3, 0, imageView.width/5, imageView.height)];
        btnItem4.exclusiveTouch=YES;
        btnItem4.tag = 103;
        btnItem4.isup=true;
        [btnItem4 setImage:[UIImage imageNamed:@"filter_btn_jiage_default"] forState:UIControlStateNormal];
        
        [btnItem4 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [imageView addSubview:btnItem4];
    if(!btnItem5){
        btnItem5 = [ShaiXuanBtn buttonWithType:UIButtonTypeCustom];
        [btnItem5 setFrame:CGRectMake(self.view.width/5*4, 0, imageView.width/5, imageView.height)];
        btnItem5.exclusiveTouch=YES;
        btnItem5.tag = 104;
        [btnItem5 setImage: [UIImage imageNamed:@"filter_btn_shaixuan_default"] forState:UIControlStateNormal];
        [btnItem5 setImage:[UIImage imageNamed:@"filter_btn_shaixuan_selected"] forState:UIControlStateSelected];
        [btnItem5 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [imageView addSubview:btnItem5];
    
    
    return  imageView;
}
#pragma mark5个按钮事件
-(void)change:(id)sender
{
    ShaiXuanBtn *btn=(ShaiXuanBtn*)sender;
    
    [UIView beginAnimations:Nil context:Nil];
    [UIView setAnimationDuration:0.2];
    CGRect frame=tabBarArrow.frame;
    frame.origin.x=[self horizontalLocationFor:btn.tag-100];
    tabBarArrow.frame=frame;
    [UIView commitAnimations];
    NSString *sortkey=@"";
    if (btn.tag==100)
    {
        btnItem1.selected=true;
        btnItem2.selected=false;
        btnItem3.selected=false;
        btnItem4.selected=false;
        btnItem2.isup=true;
        btnItem3.isup=true;
        btnItem4.isup=true;
        sortkey=@"price_cn-asc";
    }else if(btn.tag==101)
    {
        btnItem1.selected=false;
        if(btnItem2.selected){
            btnItem2.isup=!btnItem2.isup;
            
        }
        if(!btnItem2.isup){
            [btnItem2 setImage:[UIImage imageNamed:@"filter_btn_xiaoliang_selected_shang"] forState:UIControlStateSelected];
            sortkey=@"order_num-asc";
        }else{
            [btnItem2 setImage:[UIImage imageNamed:@"filter_btn_xiaoliang_selected_shang_xia"] forState:UIControlStateSelected];
            sortkey=@"order_num-desc";
        }
        btnItem2.selected=true;
        btnItem3.selected=false;
        btnItem4.selected=false;
        btnItem3.isup=true;
        btnItem4.isup=true;
        
    }
    else if(btn.tag==102)
    {
        btnItem1.selected=false;
        if(btnItem3.selected){
            btnItem3.isup=!btnItem3.isup;
            
        }
        if(!btnItem3.isup){
            [btnItem3 setImage:[UIImage imageNamed:@"filter_btn_zhekou_selected_shang"] forState:UIControlStateSelected];
            sortkey=@"discount-asc";
        }else{
            [btnItem3 setImage:[UIImage imageNamed:@"filter_btn_zhekou_selected_xia"] forState:UIControlStateSelected];
            sortkey=@"discount-desc";
        }
        
        btnItem3.selected=true;
        btnItem2.selected=false;
        btnItem2.isup=true;
        btnItem4.selected=false;
        btnItem4.isup=true;
        
        
    }
    else if(btn.tag==103)
    {
        btnItem1.selected=false;
        if(btnItem4.selected){
            btnItem4.isup=!btnItem4.isup;
            
        }
        if(btnItem4.isup){
            [btnItem4 setImage:[UIImage imageNamed:@"filter_btn_jiage_selected_shang"] forState:UIControlStateSelected];
            sortkey=@"price_cn-asc";
        }else{
            [btnItem4 setImage:[UIImage imageNamed:@"filter_btn_jiage_selected_xia"] forState:UIControlStateSelected];
            sortkey=@"price_cn-desc";
        }
        btnItem4.selected=true;
        btnItem2.selected=false;
        btnItem2.isup=true;
        btnItem3.selected=false;
        btnItem3.isup=true;
        
    }
    else if(btn.tag==104)
    {
        
        FilterViewController *filterViewController=[[FilterViewController alloc]initWithNibName:@"FilterViewController" bundle:nil andFilterType:[[_inParameters allKeys] containsObject:@"brand"]? FilterViewControllTypeBrand:FilterViewControllTypeShop andParameter: _inParameters];
        filterViewController.delegate=self;
        filterViewController.pamCategoryName=self.topTitle;
        //        filterViewController.categoryImageUrl=分类图片地址
        AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.navigationController pushViewController:filterViewController animated:YES];
        
        
    }
    [self paixu:sortkey];
}
#pragma mark 排序
-(void)paixu:(NSString *)soryKey{
    pageCount=@"1";
    [_inParameters removeObjectForKey:@"p"];
    [_inParameters setObject:pageCount forKey:@"p"];
    [_inParameters removeObjectForKey:@"sort"];
    [_inParameters setObject:soryKey forKey:@"sort"];
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsList",requestUrl]
    ;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:_inParameters withUrlName:@"getGoodsListForKey"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
}
#pragma mark 商品详细信息
-(void)goodContentTouch:(GoodImageButton *)sender{
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(goodContentTouchDo:) object:sender];
    [self performSelector:@selector(goodContentTouchDo:) withObject:sender afterDelay:0.2f];

    
    
    
}
-(void)goodContentTouchDo:(GoodImageButton *)sender{
    
    New_Goods *goods=sender.goods;
    //    NSDictionary *parameters = @{@"id":@"626"};
    NSDictionary *parameters = @{@"id":goods.id};//goods.id
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsDetail",requestUrl]
    ;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getGoodsDetail"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
    
}
-(void)returnInParameters:(NSDictionary *)inParameterss{
    _inParameters=[[NSMutableDictionary alloc]initWithDictionary:inParameterss];
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
