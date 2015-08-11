//
//  SpecialContentViewController.m
//  haitao
//
//  Created by SEM on 15/7/25.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//
#define kWindowHeight                       ([[UIScreen mainScreen] bounds].size.height)
#import "SpecialContentViewController.h"
#import "SpecialModel.h"
#import "New_Goods.h"
#import "ScreenViewController.h"
#import "GoodImageButton.h"
#import "Goods_Ext.h"
#import "HTGoodDetailsViewController.h"
#import "ShaiXuanBtn.h"
@interface SpecialContentViewController ()
{
    UITableView                 *_tableView;
    UrlImageView *imageV;
    SpecialModel *specialModel;
    UIView *view_bar1;
    ShaiXuanBtn*btnItem1; //上部五个按钮
    ShaiXuanBtn*btnItem2;
    ShaiXuanBtn*btnItem3;
    ShaiXuanBtn*btnItem4;
    ShaiXuanBtn*btnItem5;
    UIImageView*  tabBarArrow;//上部桔红线条
}

@end

@implementation SpecialContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *naviView=(UIView*) [self getNavigationBar];
    _tableView =[[UITableView alloc]initWithFrame:(CGRect){0,naviView.frame.size.height+1,self.view.frame.size.width,kWindowHeight-naviView.frame.size.height} style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorColor=[UIColor clearColor];
    _refresh=[[DJRefresh alloc] initWithScrollView:_tableView delegate:self];
    _refresh.topEnabled=YES;
    //    _tableView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:_tableView];
    NSArray *goodArr=[self.spcDic objectForKey:@"goods"];
    specialModel=[self.spcDic objectForKey:@"detail"];
    listArr=[[NSMutableArray alloc]init];
    [self getGoodlist:goodArr];
    // Do any additional setup after loading the view.
}
-(UIView*)getNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    view_bar1 =[[UIView alloc]init];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>6.1)
    {
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width, 44+20);
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 44+20)];
        imageV.backgroundColor=RGB(255, 13, 94);
        [view_bar1 addSubview:imageV];
        
        
    }else{
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width,44);
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,44)];
        imageV.backgroundColor=RGB(255, 13, 94);
        [view_bar1 addSubview:imageV];
        
    }
    view_bar1.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:view_bar1];
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(65, view_bar1.frame.size.height-44, self.view.frame.size.width-130, 44)];
    title_label.text=@"专题";
    title_label.font=[UIFont boldSystemFontOfSize:20];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =[UIColor whiteColor];
    title_label.textAlignment=1;
    [view_bar1 addSubview:title_label];
    UIButton*btnBack=[UIButton buttonWithType:0];
    btnBack.frame=CGRectMake(0, view_bar1.frame.size.height-34, 47, 34);
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
#pragma mark置顶按钮栏
-(UIView*)getToolBar
{
    UIView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,45 )];
    imageView.backgroundColor=[UIColor clearColor];
    imageView.userInteractionEnabled=YES;
    [self.view addSubview:imageView];
    if(!btnItem1){
        btnItem1 = [ShaiXuanBtn buttonWithType:UIButtonTypeCustom];
        [btnItem1 setFrame:CGRectMake(0, 0, self.view.width/5, 45)];
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
        [btnItem2 setFrame:CGRectMake(self.view.width/5*1, 0, self.view.width/5, 45)];
        
        btnItem2.exclusiveTouch=YES;
        btnItem2.tag = 101;
        btnItem2.isup=true;
        [btnItem2 setImage:[UIImage imageNamed:@"filter_btn_xiaoliang_default"] forState:UIControlStateNormal];
        [btnItem2 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [imageView addSubview:btnItem2];
    if(!btnItem3){
        btnItem3 = [ShaiXuanBtn buttonWithType:UIButtonTypeCustom];
        [btnItem3 setFrame:CGRectMake(self.view.width/5*2, 0, self.view.width/5, 45)];
        btnItem3.exclusiveTouch=YES;
        btnItem3.tag = 102;
        btnItem3.isup=true;
        [btnItem3 setImage:[UIImage imageNamed:@"filter_btn_zhekou_default"] forState:UIControlStateNormal];
        [btnItem3 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [imageView addSubview:btnItem3];
    if(!btnItem4){
        btnItem4 = [ShaiXuanBtn buttonWithType:UIButtonTypeCustom];
        [btnItem4 setFrame:CGRectMake(self.view.width/5*3, 0, self.view.width/5, 45)];
        btnItem4.exclusiveTouch=YES;
        btnItem4.tag = 103;
        btnItem4.isup=true;
        [btnItem4 setImage:[UIImage imageNamed:@"filter_btn_jiage_default"] forState:UIControlStateNormal];
        
        [btnItem4 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [imageView addSubview:btnItem4];
    if(!btnItem5){
        btnItem5 = [ShaiXuanBtn buttonWithType:UIButtonTypeCustom];
        [btnItem5 setFrame:CGRectMake(self.view.width/5*4, 0, self.view.width/5,45)];
        btnItem5.exclusiveTouch=YES;
        btnItem5.tag = 104;
        [btnItem5 setImage: [UIImage imageNamed:@"filter_btn_shaixuan_default"] forState:UIControlStateNormal];
        [btnItem5 setImage:[UIImage imageNamed:@"filter_btn_shaixuan_selected"] forState:UIControlStateSelected];
        [btnItem5 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [imageView addSubview:btnItem5];
    
    
    return  imageView;
}

- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
    CGFloat tabItemWidth = self.view.frame.size.width/5;
    return (tabIndex * tabItemWidth+ tabItemWidth/5-4);
}
#pragma mark5个按钮事件
-(void)change:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    
    [UIView beginAnimations:Nil context:Nil];
    [UIView setAnimationDuration:0.2];
    CGRect frame=tabBarArrow.frame;
    frame.origin.x=[self horizontalLocationFor:btn.tag-100];
    tabBarArrow.frame=frame;
    [UIView commitAnimations];
    
    if (btn.tag==100)
    {
        [btnItem1 setTitleColor:[UIColor colorWithRed:1.0 green:.23 blue:.49 alpha:1.0] forState:0]   ;
        btnItem1.backgroundColor=[UIColor whiteColor];
        [btnItem2 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem2.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem3 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem3.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem4 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem4.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem5 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem5.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        
        
    }else if(btn.tag==101)
    {
        [btnItem2 setTitleColor:[UIColor colorWithRed:1.0 green:.23 blue:.49 alpha:1.0] forState:0]   ;
        [btnItem1 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem1.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        btnItem2.backgroundColor=[UIColor whiteColor];
        [btnItem3 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem3.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem4 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem4.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem5 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem5.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        
    }
    else if(btn.tag==102)
    {
        [btnItem3 setTitleColor:[UIColor colorWithRed:1.0 green:.23 blue:.49 alpha:1.0] forState:0]   ;
        btnItem3.backgroundColor=[UIColor whiteColor];
        [btnItem1 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem1.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem2 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem2.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem4 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem4.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem5 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem5.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        
    }
    else if(btn.tag==103)
    {
        [btnItem4 setTitleColor:[UIColor colorWithRed:1.0 green:.23 blue:.49 alpha:1.0] forState:0]   ;
        btnItem4.backgroundColor=[UIColor whiteColor];
        [btnItem1 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem1.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem2 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem2.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem3 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem3.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem5 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem5.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        
    }
    else if(btn.tag==104)
    {
        ScreenViewController *screenViewController=[[ScreenViewController alloc]init];
        screenViewController.indexDic=nil;
        AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.navigationController pushViewController:screenViewController animated:YES];
//        [btnItem5 setTitleColor:[UIColor colorWithRed:1.0 green:.23 blue:.49 alpha:1.0] forState:0]   ;
//        btnItem5.backgroundColor=[UIColor whiteColor];
//        [btnItem1 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
//        btnItem1.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
//        [btnItem2 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
//        btnItem2.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
//        [btnItem4 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
//        btnItem4.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
//        [btnItem3 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
//        btnItem3.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        
    }
    
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
    if(section==0){
        return 1;
    }else{
        return listArr.count;
    }
//    return spcList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
        return 0;
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if(section==1){
//        return  [self getToolBar];
//    }
    UIView * uiview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)] ;
    uiview.backgroundColor=[UIColor clearColor];
    return uiview;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        static NSString *contet_cell = @"contet_cell";
        
        UITableViewCell *cell =nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contet_cell] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
            cell.backgroundColor=[UIColor whiteColor];
        }
        UrlImageButton *urlImageView=[[UrlImageButton alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
        NSURL *url =[NSURL URLWithString:specialModel.img];
        [urlImageView setImageWithURL:url];
        urlImageView.backgroundColor=[UIColor clearColor];
        [cell addSubview:urlImageView ];

        return cell;
    }else{
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
            UILabel *_label=[[UILabel alloc]initWithFrame:CGRectMake(0, btn1.frame.size.width+btn1.top+10, gbBtn.width, 10)];
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
        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(0, 0);
        cellFrame.size.width=SCREEN_WIDTH;
        cellFrame.size.height=lastFrame.size.height+10;
        [cell setFrame:cellFrame];
        
        
        
        return cell;

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 120;
    }
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
#pragma mark 接受数据
-(void) didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    //    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //    [app stopLoading];
    NSString *s_app_id=[dictemp objectForKey:@"s_app_id"];
    NSString *status=[dictemp objectForKey:@"status"];
   
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
#pragma mark 排序
-(void)paixu:(NSString *)soryKey{
    NSDictionary *parameters = @{@"f_cat":self.menuModel.id,@"need_cat_index":@1,@"sort":soryKey};
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsList",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getGoodsList"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
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

#pragma mark  下拉刷新
- (void)addDataWithDirection:(DJRefreshDirection)direction{
    
    if (direction==DJRefreshDirectionTop) {
//        [self getSpecialData];
    }
    [_refresh finishRefreshingDirection:direction animation:YES];
    
    
    
}
#pragma mark  下拉刷新
- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addDataWithDirection:direction];
    });
    
}
@end
