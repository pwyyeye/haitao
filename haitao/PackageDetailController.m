//
//  PackageDetailController.m
//  haitao
//
//  Created by pwy on 15/8/4.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "PackageDetailController.h"
#import "OrderModelForPackageDetail.h"
#import "Order_package.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OrderListCell.h"
#import "Order_goods.h"
#import "Order_goodsAttr.h"
#import "LogisticsViewController.h"
#import "New_Goods.h"
#import "Goods_Ext.h"
#import "HTGoodDetailsViewController.h"
#import "ChatViewController.h"
@interface PackageDetailController ()

@end

@implementation PackageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //是否显示navigationBar
    [self.navigationController setNavigationBarHidden:NO];
    //navigationBar 背景色
    self.navigationController.navigationBar.barTintColor=RGB(255, 13, 94);
    //若为yesnavigationBar背景 会有50％的透明
    self.navigationController.navigationBar.translucent = NO;
    
    //返回的颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //navigationBar的标题
    //self.navigationItem.title=@"登录";
    self.title=@"包裹详情";
    
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    _tableView.dataSource = self;
    _tableView.delegate=self;
//    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    self.tableView.tableFooterView=[[UIView alloc]init];
    [self initData];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.viewWidth.constant=SCREEN_WIDTH;
    //tableView的高度时header＋footer＋cell高度*cell个数
    self.tableViewHeight.constant=110+80*_packageModel.package_info.goods.count;
    //自身高度＝tableview的y坐标＋tableView的高度＋coll的高度*个数＋coll展开view的最大高度
    self.viewHeight.constant=self.tableView.frame.origin.y+self.tableViewHeight.constant+_coll.cellHeight*3+400;
    
    
}

-(void)initData{
    if (_package_id==nil) {
        return;
    }
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_getPackageDetail withType:GETURL withPam:@{@"package_id":_package_id} withUrlName:@"getPackageDetail"];
    httpController.delegate = self;
    [httpController onSearch];
    
}

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    //返回原来界面
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
        
        if ([urlname isEqualToString:@"getPackageDetail"]) {
            
            NSDictionary *dic=[dictemp objectForKey:@"data"];
            
            if (dic.count==0) {
                [_tableView reloadData];
                return;
                
            }
            
            _packageModel=[PackageDetail objectWithKeyValues:dic];
            
            NSLog(@"----pass-_packageModel%@---",_packageModel);
            
            
            
            _coll=[[CollapseClick alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 500)];
            _coll.CollapseClickDelegate = self;
            _coll.cellSpace=0;
            _coll.cellHeight=40;
            _coll.scrollEnabled=NO;
            [_coll reloadCollapseClick];
            //    // If you want a cell open on load, run this method:
            //展开第一个
//            [_coll openCollapseClickCellAtIndex:0 animated:NO];
            
            [self.footView addSubview:_coll];
            
            self.footView.backgroundColor=[UIColor whiteColor];
            
            
            //控制缩放
            self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
            self.mediaFocusManager.delegate = self;
            // Tells which views need to be focusable. You can put your image views in an array and give it to the focus manager.
            [self.mediaFocusManager installOnViews:self.orderImageView.subviews];
            
            //是否点击释放
            self.mediaFocusManager.isDefocusingWithTap=YES;
            //动画时间
            self.mediaFocusManager.animationDuration=0.5;
            //
            self.mediaFocusManager.gestureDisabledDuringZooming=NO;
            
            self.mediaFocusManager.defocusOnVerticalSwipe=YES;
            
            self.mediaFocusManager.zoomEnabled=YES;
//            [self.mediaFocusManager startFocusingView:_orderImageView];
            
            
            if (_footerBar!=nil) {
                [_footerBar removeFromSuperview];
            }
            
            
            //设置底部按钮
            _footerBar=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-47-64, SCREEN_WIDTH, 47)];
            self.footerBar.backgroundColor=[UIColor whiteColor];
            //分割线
            UILabel *jianju=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            jianju.backgroundColor=RGB(237, 237, 237);
            [self.footerBar addSubview:jianju];
            
            //order_status 1、刚录入订单 2、订单已支付  8、订单完成 用户已确认 9、取消订单
            //package_status 1、待发货 2、已发货 8、已确认
            if ([_packageModel.package_info.package_status intValue]==1) {
                _orderStatus.text=[NSString stringWithFormat:@"待付款"];
                
                //联系客服
                UIButton *kefu=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 30)];
                [kefu setImage:[UIImage imageNamed:@"icon_LianXiKeFu"]  forState:UIControlStateNormal];
                [kefu.imageView setContentMode:UIViewContentModeScaleAspectFill];
                
                [kefu addTarget:self action:@selector(connectKefu) forControlEvents:UIControlEventTouchUpInside];
                
                //联系客服文字
                UILabel *kefu_label=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH/2, 15)];
                kefu_label.text=@"在线客服";
                kefu_label.textColor=RGB(128, 128, 128);
                kefu_label.font=[UIFont boldSystemFontOfSize:11];
                kefu_label.textAlignment=NSTextAlignmentCenter;
                
                
                //联系电话
                UIButton *telephone=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 30)];
                [telephone setImage:[UIImage imageNamed:@"icon_BoDaDianHua"]  forState:UIControlStateNormal];
                [telephone.imageView setContentMode:UIViewContentModeScaleAspectFill];
                
                [telephone addTarget:self action:@selector(callTelephone) forControlEvents:UIControlEventTouchUpInside];
                
                //联系电话文字
                UILabel *telephone_label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 30, SCREEN_WIDTH/2, 15)];
                telephone_label.text=@"拨打电话";
                telephone_label.textColor=RGB(128, 128, 128);
                telephone_label.font=[UIFont boldSystemFontOfSize:11];
                telephone_label.textAlignment=NSTextAlignmentCenter;
                
                
                //添加进入 footerBar
                [self.footerBar addSubview:kefu];
                [self.footerBar addSubview:kefu_label];
                
                [self.footerBar addSubview:telephone];
                [self.footerBar addSubview:telephone_label];
                
                
                [self.myView addSubview:_footerBar];
                
            }else if ([_packageModel.package_info.package_status intValue]==2) {
                _orderStatus.text=[NSString stringWithFormat:@"待发货"];
                
                //联系客服
                UIButton *kefu=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 30)];
                [kefu setImage:[UIImage imageNamed:@"icon_LianXiKeFu"]  forState:UIControlStateNormal];
                [kefu.imageView setContentMode:UIViewContentModeScaleAspectFill];
                
                [kefu addTarget:self action:@selector(connectKefu) forControlEvents:UIControlEventTouchUpInside];
                
                //联系客服文字
                UILabel *kefu_label=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH/2, 15)];
                kefu_label.text=@"在线客服";
                kefu_label.textColor=RGB(128, 128, 128);
                kefu_label.font=[UIFont boldSystemFontOfSize:11];
                kefu_label.textAlignment=NSTextAlignmentCenter;
                
                
                //联系电话
                UIButton *telephone=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 30)];
                [telephone setImage:[UIImage imageNamed:@"icon_BoDaDianHua"]  forState:UIControlStateNormal];
                [telephone.imageView setContentMode:UIViewContentModeScaleAspectFill];
                
                [telephone addTarget:self action:@selector(callTelephone) forControlEvents:UIControlEventTouchUpInside];
                
                //联系电话文字
                UILabel *telephone_label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 30, SCREEN_WIDTH/2, 15)];
                telephone_label.text=@"拨打电话";
                telephone_label.textColor=RGB(128, 128, 128);
                telephone_label.font=[UIFont boldSystemFontOfSize:11];
                telephone_label.textAlignment=NSTextAlignmentCenter;
                
                
                //添加进入 footerBar
                [self.footerBar addSubview:kefu];
                [self.footerBar addSubview:kefu_label];
                
                [self.footerBar addSubview:telephone];
                [self.footerBar addSubview:telephone_label];
                
                
                [self.myView addSubview:_footerBar];
                
            } else if([_packageModel.package_info.package_status intValue]==3){
                _orderStatus.text=[NSString stringWithFormat:@"已发货"];
                //联系客服
                UIButton *kefu=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5*1.5, 30)];
                [kefu setImage:[UIImage imageNamed:@"icon_LianXiKeFu"]  forState:UIControlStateNormal];
                [kefu.imageView setContentMode:UIViewContentModeScaleAspectFill];
                [kefu addTarget:self action:@selector(connectKefu) forControlEvents:UIControlEventTouchUpInside];

                //联系客服文字
                UILabel *kefu_label=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH/5*1.5, 15)];
                kefu_label.text=@"在线客服";
                kefu_label.font=[UIFont boldSystemFontOfSize:11];
                kefu_label.textColor=RGB(128, 128, 128);
                kefu_label.textAlignment=NSTextAlignmentCenter;
//                [kefu addSubview:kefu_label];
                
                //查看物流
                UIButton *logistics=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5*1.5, 0, SCREEN_WIDTH/5*1.5, 30)];
                [logistics setImage:[UIImage imageNamed:@"icon_WuLIuChaKan"]  forState:UIControlStateNormal];
                [logistics.imageView setContentMode:UIViewContentModeScaleAspectFill];
                [logistics addTarget:self action:@selector(gotoLogistics:) forControlEvents:UIControlEventTouchUpInside];

                //查看物流文字
                UILabel *logistics_label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5*1.5, 30, SCREEN_WIDTH/5*1.5, 15)];
                logistics_label.text=@"查看物流";
                logistics_label.textColor=RGB(128, 128, 128);
                logistics_label.font=[UIFont boldSystemFontOfSize:11];
                logistics_label.textAlignment=NSTextAlignmentCenter;
//                [logistics addSubview:logistics_label];
                
                //确认收货
                UIButton *confirm=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5*3, 8, SCREEN_WIDTH/5*2,35)];
                [confirm setBackgroundImage:[UIImage imageNamed:@"order_btn_definite"]  forState:UIControlStateNormal];
                [confirm addTarget:self action:@selector(confirmPackage:) forControlEvents:UIControlEventTouchUpInside];
                [confirm.imageView setContentMode:UIViewContentModeScaleAspectFill];
                
                //添加进入 footerBar
                [self.footerBar addSubview:kefu];
                [self.footerBar addSubview:kefu_label];
                
                [self.footerBar addSubview:logistics];
                [self.footerBar addSubview:logistics_label];
                
                [self.footerBar addSubview:confirm];
                
                
                [self.myView addSubview:_footerBar];

                
            }else if([_packageModel.package_info.package_status intValue]==8){
                _orderStatus.text=[NSString stringWithFormat:@"交易成功"];
                //联系客服
                UIButton *kefu=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 30)];
                [kefu setImage:[UIImage imageNamed:@"icon_LianXiKeFu"]  forState:UIControlStateNormal];
                [kefu.imageView setContentMode:UIViewContentModeScaleAspectFill];
                [kefu addTarget:self action:@selector(connectKefu) forControlEvents:UIControlEventTouchUpInside];

                //联系客服文字
                UILabel *kefu_label=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH/3, 15)];
                kefu_label.text=@"在线客服";
                kefu_label.textColor=RGB(128, 128, 128);
                kefu_label.font=[UIFont boldSystemFontOfSize:11];
                kefu_label.textAlignment=NSTextAlignmentCenter;

                
                //联系电话
                UIButton *telephone=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 30)];
                [telephone setImage:[UIImage imageNamed:@"icon_BoDaDianHua"]  forState:UIControlStateNormal];
                [telephone.imageView setContentMode:UIViewContentModeScaleAspectFill];
                [telephone addTarget:self action:@selector(callTelephone) forControlEvents:UIControlEventTouchUpInside];

                //联系电话文字
                UILabel *telephone_label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 30, SCREEN_WIDTH/3, 15)];
                telephone_label.text=@"拨打电话";
                telephone_label.textColor=RGB(128, 128, 128);
                telephone_label.font=[UIFont boldSystemFontOfSize:11];
                telephone_label.textAlignment=NSTextAlignmentCenter;
                
                //查看物流
                UIButton *logistics=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3,30)];
                [logistics setImage:[UIImage imageNamed:@"icon_WuLIuChaKan"]  forState:UIControlStateNormal];
                
                [logistics addTarget:self action:@selector(gotoLogistics:) forControlEvents:UIControlEventTouchUpInside];
                [logistics.imageView setContentMode:UIViewContentModeScaleAspectFill];

                //查看物流文字
                UILabel *logistics_label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 30, SCREEN_WIDTH/3, 15)];
                logistics_label.text=@"物流查询";
                logistics_label.textColor=RGB(128, 128, 128);

                logistics_label.font=[UIFont boldSystemFontOfSize:11];
                logistics_label.textAlignment=NSTextAlignmentCenter;
                //添加进入 footerBar
                [self.footerBar addSubview:kefu];
                [self.footerBar addSubview:kefu_label];
                
                [self.footerBar addSubview:telephone];
                [self.footerBar addSubview:telephone_label];
                
                [self.footerBar addSubview:logistics];
                [self.footerBar addSubview:logistics_label];
                
                
                [self.myView addSubview:_footerBar];
                
                
            }else if([_packageModel.package_info.package_status intValue]==9){
                _orderStatus.text=[NSString stringWithFormat:@"交易关闭"];
                

            }
            
            _payAmount.text=[NSString stringWithFormat:@"包裹应付金额(%@): %.2f",[_packageModel.package_info.ship_type integerValue]==1?@"含商品金额，直邮运费，预收关税":@"含商品金额，转运运费",_packageModel.package_info.package_amount];
            _payAmount.numberOfLines=0;
            _shipAmount.text=[NSString stringWithFormat:@"%@: %.2f",[_packageModel.package_info.ship_type integerValue]==1?@"直邮运费":@"转运运费",_packageModel.package_info.shipping_amount];
            
            _taxAmount.text=[NSString stringWithFormat:@"%@: %.2f",[_packageModel.package_info.ship_type integerValue]==1?@"预收关税":@"预估关税",[_packageModel.package_info.ship_type integerValue]==1?_packageModel.package_info.direct_amount:_packageModel.package_info.transport_amount];
            
            _consignee.text=[NSString stringWithFormat:@"收件人: %@",_packageModel.order.consignee];
            
            _mobile.text=[NSString stringWithFormat:@"%@",_packageModel.order.mobile];
            
            _address.text= [NSString stringWithFormat:@"%@%@",_packageModel.order.province,_packageModel.order.address];;
            self.myScollView.delegate=self;
            self.myScollView.bounces=NO;//遇到边框不反弹
            
            [self updateViewConstraints];
            
            [_tableView reloadData];

            
        }
        else if([urlname isEqualToString:@"confirmPackage"]){
            ShowMessage(@"已确认收货！");
            [self initData];
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
    
}

-(void)gotoLogistics:(UIButton *)sender{

    LogisticsViewController *vc=[[LogisticsViewController alloc] initWithNibName:@"LogisticsViewController" bundle:nil];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    vc.packageModel=_packageModel;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoGoodsDetailDo:(NSString *) goods_id{
    NSDictionary *parameters = @{@"id":goods_id};
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsDetail",requestUrl]
    ;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getGoodsDetail"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
}
-(void)gotoGoodsDetail:(NSString *) goods_id{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(gotoGoodsDetailDo:) object:goods_id];
    [self performSelector:@selector(gotoGoodsDetailDo:) withObject:goods_id afterDelay:0.3f];
}

-(void)confirmPackage:(UIButton *)sender{
    //订单号
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_confirmPackage withType:POSTURL withPam:@{@"package_id":[NSString stringWithFormat:@"%@",_packageModel.package_info.id]} withUrlName:@"confirmPackage"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
}

-(void)callTelephone{
    NSString *phoneNum = @"400-892-8080";// 电话号码
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    if ( !_phoneCallWebView ) {
        
        _phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
        
    }
    
    [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

-(void)connectKefu{
    ChatViewController *chat=[ChatViewController shareChat];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil  action:nil]];
    [self.navigationController pushViewController:chat animated:YES];
    

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - tableView delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   //内层header
         Order_package *package=_packageModel.package_info;
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
        
        //包裹
        UILabel *head=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 38)];
        head.text=[NSString stringWithFormat:@"包裹%ld",(long)section+1];
        head.font =[UIFont  boldSystemFontOfSize:11];//加粗字体
        head.textColor=RGB(255, 13, 94);
        [view addSubview:head];
        
        //国家icon
        UIImageView *country=[[UIImageView alloc] initWithFrame:CGRectMake(70, 9, 20, 20)];
        [country setImageWithURL:[NSURL URLWithString:package.country_flag_url] placeholderImage:[UIImage imageNamed:@"default_04.png"]];
        [view addSubview:country];
        
        //商城名称
        UILabel *shopname=[[UILabel alloc] initWithFrame:CGRectMake(95, 0, 70, 38)];
        shopname.text=package.shop_name;
        shopname.font =[UIFont  systemFontOfSize:10];
        shopname.textColor=RGB(179, 179, 179);
        [view addSubview:shopname];
        
        //直邮转运
        UILabel *ship=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 0, 80, 38)];
        ship.text=package.ship_name;
        ship.font =[UIFont  boldSystemFontOfSize:11];
        ship.textColor=RGB(51, 51, 51);
        [view addSubview:ship];
        
    
        
        UILabel *jianju=[[UILabel alloc] initWithFrame:CGRectMake(0, 37, SCREEN_WIDTH, 0.5)];
        jianju.backgroundColor=RGB(237, 237, 237);
        [view addSubview:jianju];
        
        view.backgroundColor=[UIColor whiteColor];
        return view;

    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    Order_package *package=_packageModel.package_info;
    //内层footer
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 72)];
    
    //运费
    UILabel *head=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH/2, 20)];
    head.text=[_packageModel.package_info.ship_type integerValue]==1?@"直邮运费":@"转运运费";
    head.font=[UIFont boldSystemFontOfSize:10];
    head.textColor=RGB(51, 51, 51);
    [view addSubview:head];
    
    //运费金额
    UILabel *ship=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 5, 70, 20)];
    ship.text=[NSString stringWithFormat:@"¥%.2f",package.shipping_amount];
    ship.textAlignment=NSTextAlignmentRight;
    ship.font =[UIFont  boldSystemFontOfSize:11];
    ship.textColor=RGB(255, 13, 94);
    [view addSubview:ship];
    
    //预付税费 transport_amount
    UILabel *transport=[[UILabel alloc] initWithFrame:CGRectMake(10, 28, SCREEN_WIDTH/2, 20)];
    transport.text=[_packageModel.package_info.ship_type integerValue]==1?@"预收关税":@"预估关税";
    transport.textColor=RGB(51, 51, 51);
    transport.font=[UIFont boldSystemFontOfSize:10];
    [view addSubview:transport];
    
    //预付税费金额
    UILabel *transport_amout=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 28, 70, 20)];
    transport_amout.text=[NSString stringWithFormat:@"%.2f", [_packageModel.package_info.ship_type integerValue]==1?_packageModel.package_info.direct_amount:_packageModel.package_info.transport_amount];
    transport_amout.textAlignment=NSTextAlignmentRight;
    transport_amout.font =[UIFont  boldSystemFontOfSize:11];
    transport_amout.textColor=RGB(255, 13, 94);
    [view addSubview:transport_amout];
    
    //小计
    UILabel *subTotal=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, 250, 20)];
    //        subTotal.text=@"小计:";
    subTotal.text=[NSString stringWithFormat:@"%@",[_packageModel.package_info.ship_type integerValue]==1?@"包裹应付金额（含商品金额，直邮运费，预收关税）":@"包裹应付金额（含商品金额，转运运费）"];
    subTotal.font=[UIFont boldSystemFontOfSize:10];
    subTotal.textColor=RGB(51, 51, 51);
    [view addSubview:subTotal];
    
    //小计金额
    UILabel *subTotal_amout=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 50, 70, 20)];
    subTotal_amout.text=[NSString stringWithFormat:@"¥%.2f",package.package_amount];
    subTotal_amout.textAlignment=NSTextAlignmentRight;
    subTotal_amout.font =[UIFont  boldSystemFontOfSize:11];
    subTotal_amout.textColor=RGB(255, 13, 94);
    [view addSubview:subTotal_amout];
    
    
    UILabel *jianju=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    jianju.backgroundColor=RGB(237, 237, 237);
    [view addSubview:jianju];
    
    UILabel *jianju_footer=[[UILabel alloc] initWithFrame:CGRectMake(0, 71.5, SCREEN_WIDTH, 0.5)];
    jianju_footer.backgroundColor=RGB(237, 237, 237);
    [view addSubview:jianju_footer];
    
    
    view.backgroundColor=[UIColor whiteColor];
    return view;
 
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 38;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return 72;//本身距离加间距

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

        return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _packageModel.package_info.goods.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    OrderListCell *cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"packagecell"];

//    static NSString *CellIdentifier = @"packagecell";
//    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //出列可重用的cell
//    if (cell == nil) {
      OrderListCell *  cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"packagecell"];
//    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色

        Order_goods *goods=[_packageModel.package_info.goods objectAtIndex:indexPath.row];
        cell.textLabel.text = goods.goods_name;
        cell.textLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:11];
        cell.textLabel.textColor=RGB(51, 51, 51);
        cell.textLabel.numberOfLines=1;
        //如果有规格 展示规格 只展示2条
        if (goods.goods_attr.count>0) {
            for (int i=0; i<goods.goods_attr.count; i++) {
                if (i>1) {
                    break;
                }
                Order_goodsAttr *attr =goods.goods_attr[i];
                
//                UILabel *head=[[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x+70,i==0?cell.frame.origin.y+30:cell.frame.origin.y+50, 150, 20)];
                if (i==0) {
                    cell.option1=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 20)];
                    
                    cell.option1.text=[NSString stringWithFormat:@"%@: %@",attr.attr_name,attr.attr_val_name];
                    cell.option1.font=[UIFont boldSystemFontOfSize:11];
                    cell.option1.textColor=RGB(128, 128, 128);
                    [cell.contentView addSubview:cell.option1];
                }else{
                    
                    cell.option2=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 20)];
                    
                    cell.option2.text=[NSString stringWithFormat:@"%@: %@",attr.attr_name,attr.attr_val_name];
                    cell.option2.font=[UIFont boldSystemFontOfSize:11];
                    cell.option2.textColor=RGB(128, 128, 128);
                    [cell.contentView addSubview:cell.option2];
                }
                
                
            }
            
        }
        
        //商品价格
        UILabel *goodPrice=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, cell.frame.origin.y+10, 70, 20)];
        goodPrice.text=[NSString stringWithFormat:@"¥%.2f",goods.goods_price];
        goodPrice.textAlignment=NSTextAlignmentRight;
        goodPrice.font =[UIFont  boldSystemFontOfSize:11];
        goodPrice.textColor=RGB(255, 13, 94);
        [cell.contentView addSubview:goodPrice];
        
        //商品价格
        UILabel *goodnum=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 55, 70, 20)];
        goodnum.text=[NSString stringWithFormat:@"x %d",goods.buy_num];
        goodnum.textAlignment=NSTextAlignmentRight;
        goodnum.font =[UIFont  boldSystemFontOfSize:11];
        goodnum.textColor=RGB(128, 128, 128);
        [cell.contentView addSubview:goodnum];
    
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:goods.img_url] placeholderImage:[UIImage imageNamed:@"default_04.png"]];
        cell.backgroundColor = [UIColor whiteColor];
   
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Order_goods *goods=[_packageModel.package_info.goods objectAtIndex:indexPath.row];
    [self gotoGoodsDetail:goods.goods_id];
}

#pragma mark - Collapse Click Delegate

// Required Methods
-(int)numberOfCellsForCollapseClick {
    return 3;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    switch (index) {
        case 0:
            return @"查看运费详情";
            break;
        case 1:
            return @"查看税费详情";
            break;
        case 2:
            return @"查看订单截图";
            break;
        default:
            return @"";
            break;
    }
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {

    switch (index) {
        case 0:
        {
            _shipDetailView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
            _shipDetailView.backgroundColor=[UIColor whiteColor];
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 80)];
            label.textColor=RGB(128, 128, 128);
            label.numberOfLines=0;
            label.font=[UIFont systemFontOfSize:11];
            if ([_packageModel.package_info.ship_type integerValue]==1) {
               label.text=[NSString stringWithFormat:@"直邮：直邮运费由%@发货时直接决定运费。详情请查看帮助说明页面。",_packageModel.package_info.shop_name] ;
            }else{
                NSString *shipname=[MyUtil isEmptyString:_packageModel.package_info.logistic_name]?_packageModel.package_info.ship_name:_packageModel.package_info.logistic_name;
                
                label.text=[NSString stringWithFormat:@"转运：转运运费=商品来源官网运费 + 转运费。\n  官网征收运费：满免标准（满%@免运费），转运费：该包裹由%@转运公司提供转运服务，该公司的转运收费标准请参考帮助详情。",[MyUtil isEmptyString:_packageModel.package_info.all_transport_free_logistic]?@"0":_packageModel.package_info.all_transport_free_logistic,shipname] ;
            }
            [_shipDetailView addSubview:label];
            return _shipDetailView;
            break;
        }case 1:
        {
            _taxDetailView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
            _taxDetailView.backgroundColor=[UIColor whiteColor];
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 80)];
            label.textColor=RGB(128, 128, 128);
            label.numberOfLines=0;
            label.font=[UIFont systemFontOfSize:11];
            if ([_packageModel.package_info.ship_type integerValue]==1) {
                label.text=[NSString stringWithFormat:@"直邮商品需要预先收取关税，预收关税为%@预先代收，需要在结算时一次性缴纳，多退少不补；预收关税计入商品总价。详情请查看帮助说明页面",_packageModel.package_info.shop_name] ;
            }else{
                label.text=[NSString stringWithFormat:@"转运商品在清关时可能产生的关税，关税额即为预估关税，如果产生关税需要及时缴纳，方可顺利清关；预估关税不计入商品总价。详情请查看帮助说明页面。"] ;
            }
            [_taxDetailView addSubview:label];
            return _taxDetailView;
            break;
        }
        case 2:
        {
            _orderImageView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
            _orderImageView.backgroundColor=[UIColor whiteColor];
//            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 70, 100, 20)];
//            label.textColor=RGB(128, 128, 128);
//            label.text=@"暂无相关消息";
//            label.font=[UIFont systemFontOfSize:11];
//            [_orderImageView addSubview:label];
            _orderImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 150)];
            [_orderImage setImageWithURL:[NSURL URLWithString:_packageModel.package_info.package_img] placeholderImage:nil];            
            [_orderImage setContentMode:UIViewContentModeScaleAspectFit];
            [_orderImageView addSubview:_orderImage];
            return _orderImageView;
            break;
        }
            
    }

    return nil;
}


// Optional Methods

-(UIColor *)colorForCollapseClickTitleViewAtIndex:(int)index {
    return [UIColor whiteColor];
}


-(UIColor *)colorForTitleLabelAtIndex:(int)index {
    return RGB(128, 128, 128);
}

-(UIColor *)colorForTitleArrowAtIndex:(int)index {
    return RGB(255, 13, 94);
}

-(void)didClickCollapseClickCellAtIndex:(int)index isNowOpen:(BOOL)open {
    NSLog(@"%d and it's open:%@", index, (open ? @"YES" : @"NO"));
    
}

#pragma mark - scrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"scrollViewDidScroll");
    CGPoint point=scrollView.contentOffset;
    NSLog(@"%f,%f",point.x,point.y);
    // 从中可以读取contentOffset属性以确定其滚动到的位置。
    
    // 注意：当ContentSize属性小于Frame时，将不会出发滚动
    
    CGRect rect= self.footerBar.frame;
    self.footerBar.frame=CGRectMake(rect.origin.x, SCREEN_HEIGHT-64-47+point.y, rect.size.width, rect.size.height);
    
    
}

#pragma mark - ASMediaFocusDelegate
// Returns the view controller in which the focus controller is going to be added. This can be any view controller, full screen or not.
- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager{

     return self.parentViewController;
}
// Returns the URL where the media (image or video) is stored. The URL may be local (file://) or distant (http://).
- (NSURL *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaURLForView:(UIView *)view{
    return [NSURL URLWithString:_packageModel.package_info.package_img];

}
// Returns the title for this media view. Return nil if you don't want any title to appear.
- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager titleForView:(UIView *)view{
    return nil;
}

//- (UIImage *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager imageForView:(UIView *)view
//{
//    return ((UIImageView *)view).image;
//}

//- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameforView:(UIView *)view
//{
//    return self.parentViewController.view.bounds;
//}



@end
