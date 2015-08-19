//
//  OrderListController.m
//  haitao
//
//  Created by pwy on 15/8/2.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "OrderListController.h"
#import "OrderModel.h"
#import "Order_package.h"
#import "Order_goods.h"
#import "OrderListCell.h"
#import "Order_goodsAttr.h"
#import "PackageDetailController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OrderSuccessController.h"
#import "ChoosePayController.h"
#import "AlipayOrder.h"
#import "New_Goods.h"
#import "Goods_Ext.h"
#import "HTGoodDetailsViewController.h"
@interface OrderListController ()

@end

@implementation OrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //是否显示navigationBar
    [self.navigationController setNavigationBarHidden:NO];
    //navigationBar 背景色
    self.navigationController.navigationBar.barTintColor=RGB(255, 13, 94);
    //若为yesnavigationBar背景 会有50％的透明
    self.navigationController.navigationBar.translucent = NO;
    
    //返回值
    
    //    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)]];
    //
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];
    
    //返回的颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //navigationBar的标题
    //self.navigationItem.title=@"登录";
    self.title=@"我的订单";
    
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    
//    NSArray *segmentedArray = @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价"];
    NSArray *segmentedArray = @[@"全部",@"待付款",@"待发货",@"待收货",@"已完成"];

    
    _seg=[[UISegmentedControl alloc] initWithItems:segmentedArray];
    
    _seg.frame=CGRectMake(0, 0, (SCREEN_WIDTH/4)*4, 34);
    _seg.selectedSegmentIndex = 0;//设置默认选择项索引
    
    //清除原有格式颜色
    _seg.tintColor=[UIColor clearColor];
    //设置背景色
    [_seg setBackgroundColor:RGB(237, 237, 237)];
    //设置字体样式
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                             NSForegroundColorAttributeName: RGB(255, 13, 94)};
    [_seg setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                               NSForegroundColorAttributeName: [UIColor colorWithWhite:0.6 alpha:1]};
    [_seg setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    
    // 使用颜色创建UIImage//未选中颜色
    CGSize imageSize = CGSizeMake((SCREEN_WIDTH/4), 34);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [RGB(237, 237, 237) set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *normalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //设置未选中背景色
    [_seg setBackgroundImage:normalImg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // 使用颜色创建UIImage //选中颜色
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[UIColor whiteColor] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *selectedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //设置选中背景色
    [_seg setBackgroundImage:selectedImg forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    
    [self.view addSubview:_seg];
    
    [_seg addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
    
    [self initData];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, SCREEN_HEIGHT-98)];
        
        tableView.dataSource = self;
        tableView.delegate=self;
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:tableView];
        tableView;
    });
    self.tableView.tableFooterView=[[UIView alloc]init];
    [self.tableView setBackgroundColor:RGB(237, 237, 237)];
    
    self.tableView.bounces=NO;//遇到边框不反弹
//    self.tableView.tableHeaderView=[[UIView alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initData{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_getOrderList withType:GETURL withPam:nil withUrlName:@"getOrderList"];
    httpController.delegate = self;
    [httpController onSearch];
    
}

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    //返回原来界面
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
        
        if ([urlname isEqualToString:@"getOrderList"]) {
            
            NSDictionary *dic=[dictemp objectForKey:@"data"];
            
            if (dic.count==0) {
                _order_array=@[];
                [self segmentAction:_seg];
                return;
            }
            
            _order_array=[OrderModel objectArrayWithKeyValuesArray:[dic objectForKey:@"list"]];
            
            NSLog(@"----pass-order_array%@---",_order_array);
            
            for (OrderModel *orderModel in _order_array) {
                for (int i=0; i<orderModel.package_info.count; i++) {
                    Order_package *package=orderModel.package_info[i];
                    package.No=i+1;
                }
            }
            
            _result_array=_order_array;
            
            
            
//            [_tableView reloadData];
            [self segmentAction:_seg];
            
            
            
        }else if([urlname isEqualToString:@"cancelOrder"]){
            
            [self initData];
            NSLog(@"----pass-cancelOrder%@---",dictemp);
            
            ShowMessage(@"取消成功！");
            
        }else if([urlname isEqualToString:@"delOrder"]){
            
            [self initData];
            NSLog(@"----pass-cancelOrder%@---",dictemp);
            
            ShowMessage(@"删除成功！");
            _selectedOrderNo=nil;
            
        }
        [self showEmptyView];
        
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

-(void)gotoBack{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

    [self showEmptyView];
}

-(void)showEmptyView{
    [_empty_view removeFromSuperview];
    if (_result_array.count>0) {
        _empty_view=nil;
        
    }else if(_result_array.count==0){
        _empty_view=[[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, SCREEN_HEIGHT - 34)];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-100, 200, 20)];
        label.text=@"暂无订单信息";
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=RGB(51, 51, 51);
        [_empty_view addSubview:label];
        label.textAlignment = UITextAlignmentCenter;
        self.empty_view.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_empty_view];
    }
    
    
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    NSLog(@"Index %i", Index);
    
        static NSString *prediStr1 = @"order_status LIKE '*'";
    
        //    1）.等于查询
        //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", "Ansel"];
        //    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
        //
        //    2）.模糊查询
        //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", @"A"]; //predicate只能是对象
        //    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
    
        switch (Index) {
            case 0:{
    
                prediStr1 = @"order_status LIKE '*'";
    
            }
                break;
            case 1:{
    
                prediStr1 = [NSString stringWithFormat:@"order_status=='%d'", 1];//未付款
            }
                break;
            case 2:{
    
                prediStr1 = [NSString stringWithFormat:@"order_status=='%d'", 2];//待发货
    
            }
                break;
            case 3:{
                
                prediStr1 = [NSString stringWithFormat:@"order_status=='%d'", 3];//待收货
                
            }
                break;
            case 4:{
                
                prediStr1 = [NSString stringWithFormat:@"order_status=='%d'", 8];//已完成
                
            }
                break;
        
            default:
                break;
        }
    
        NSLog(@"----pass-prediStr1%@---",[NSString stringWithFormat:@"%@",prediStr1]);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@",prediStr1]];
        NSArray *orderlist=self.order_array;
        self.result_array = [orderlist filteredArrayUsingPredicate:predicate];
    [self.subTableView reloadData];
        [self.tableView reloadData];
        [self showEmptyView];
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
    if (_tableView==tableView) {//最外层 header
        
        OrderModel *order=_result_array[section];
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
        UILabel *head=[[UILabel alloc] initWithFrame:CGRectMake(10, 3.5, SCREEN_WIDTH/2, 17)];
        head.font =[UIFont systemFontOfSize:10];
        head.text=[NSString stringWithFormat:@"订单编号：%@",order.id] ;
        head.textColor=RGB(128, 128, 128);
        [view addSubview:head];
        
        UILabel *head_right=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 3.5, SCREEN_WIDTH/2-10, 17)];
        head_right.font =[UIFont systemFontOfSize:10];
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:[order.ct longLongValue]];
        head_right.text=[NSString stringWithFormat:@"下单时间：%@",[MyUtil getFormatDate:date]];
        head_right.textColor=RGB(128, 128, 128);
        [view addSubview:head_right];
        
        //分割线
        UILabel *jianju=[[UILabel alloc] initWithFrame:CGRectMake(0, 24, SCREEN_WIDTH, 0.5)];
        jianju.backgroundColor=RGB(237, 237, 237);
        [view addSubview:jianju];
        
        view.backgroundColor=[UIColor whiteColor];
      
        return view;
    }else{//内层header
//        OrderModel *order=_result_array[section];
        Order_package *selectedPackage;

      
        for (OrderModel *orderModel in _result_array) {
            NSArray *array=orderModel.package_info;
            for (Order_package *package in array) {
                if ([package.id integerValue]==tableView.tag) {
                    selectedPackage=package;
                }
            }
        }
        
        
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
        
        //包裹
        UILabel *head=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 38)];
        head.text=[NSString stringWithFormat:@"包裹%d",selectedPackage.No];
        head.font =[UIFont  boldSystemFontOfSize:11];//加粗字体
        head.textColor=RGB(255, 13, 94);
        [view addSubview:head];
        
        //国家icon
        UIImageView *country=[[UIImageView alloc] initWithFrame:CGRectMake(70, 9, 20, 20)];
        [country setImageWithURL:[NSURL URLWithString:selectedPackage.country_flag_url] placeholderImage:[UIImage imageNamed:@"default_04.png"]];
        [view addSubview:country];
        
        //商城名称
        UILabel *shopname=[[UILabel alloc] initWithFrame:CGRectMake(105, 0, 70, 38)];
        shopname.text=selectedPackage.shop_name;
        shopname.font =[UIFont  systemFontOfSize:10];
        shopname.textColor=RGB(179, 179, 179);
        [view addSubview:shopname];
        
        //直邮转运
        UILabel *ship=[[UILabel alloc] initWithFrame:CGRectMake(170, 0, 30, 38)];
        ship.text=selectedPackage.ship_name;
        ship.font =[UIFont  boldSystemFontOfSize:11];
        ship.textColor=RGB(51, 51, 51);
        [view addSubview:ship];
        
        //包裹详情
        UIButton *packageDetail=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 4, 60, 30)];
        [packageDetail setTitle:@"包裹详情" forState:UIControlStateNormal];
        [packageDetail setTitleColor:RGB(24, 177, 18) forState:UIControlStateNormal];
        packageDetail.titleLabel.font =[UIFont  systemFontOfSize:11];//加粗字体
        packageDetail.tag=[selectedPackage.id integerValue];
        [packageDetail addTarget:self action:@selector(gotoPackageDetail:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:packageDetail];
        
        UILabel *jianju=[[UILabel alloc] initWithFrame:CGRectMake(0, 37, SCREEN_WIDTH, 0.5)];
        jianju.backgroundColor=RGB(237, 237, 237);
        [view addSubview:jianju];
        
        view.backgroundColor=[UIColor whiteColor];
        return view;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (_tableView==tableView) {
        //最外层 footer
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 71)];
        OrderModel *orderModel= _result_array[section];
        NSArray *packages=orderModel.package_info;
  
        UILabel *head=[[UILabel alloc] initWithFrame:CGRectMake(10, 3, SCREEN_WIDTH/2, 18)];
        head.text=[NSString stringWithFormat:@"共 %lu个包裹,%d件商品",(unsigned long)packages.count,orderModel.buy_num];
        head.font=[UIFont boldSystemFontOfSize:11];
        head.textColor=RGB(128, 128, 128);
        [view addSubview:head];
        
        
        //总计金额
        UILabel *total_amout=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 3, 70, 18)];
        total_amout.text=[NSString stringWithFormat:@"¥%.2f",orderModel.order_amount];
        total_amout.textAlignment=NSTextAlignmentRight;
        total_amout.font =[UIFont  boldSystemFontOfSize:11];
        total_amout.textColor=RGB(255, 13, 94);
        [view addSubview:total_amout];
        
        
        UILabel *total_jianju=[[UILabel alloc] initWithFrame:CGRectMake(0, 24, SCREEN_WIDTH, 0.5)];
        total_jianju.backgroundColor=RGB(237, 237, 237);
        [view addSubview:total_jianju];
        //1、刚录入订单 2、订单已支付  8、订单完成 用户已确认 9、取消订单
        if ([orderModel.order_status integerValue]==1) {
            //付款按钮
            UIButton *btnPay=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 29, 80, 24)];
            [btnPay setTitle:@"付款" forState:UIControlStateNormal];
            [btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnPay.titleLabel.font =[UIFont  systemFontOfSize:11];
            btnPay.backgroundColor=RGB(255, 13, 94);
            btnPay.layer.masksToBounds=YES;
            btnPay.layer.cornerRadius=3;
            
            btnPay.tag=[orderModel.id integerValue];
            [btnPay addTarget:self action:@selector(gotoPay:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btnPay];
            
            //取消订单按钮
            UIButton *btnCancel=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-180, 29, 80, 24)];
            [btnCancel setTitle:@"取消订单" forState:UIControlStateNormal];
            [btnCancel setTitleColor:RGB(128, 128, 128) forState:UIControlStateNormal];
            btnCancel.titleLabel.font =[UIFont  systemFontOfSize:11];
            btnCancel.backgroundColor=[UIColor whiteColor];
            btnCancel.layer.masksToBounds=YES;
            btnCancel.layer.borderWidth=0.5;
            btnCancel.layer.borderColor=RGB(179, 179, 179).CGColor;
            btnCancel.layer.cornerRadius=3;
            btnCancel.tag=[orderModel.id integerValue];
            [btnCancel addTarget:self action:@selector(gotoCancelOrder:) forControlEvents:UIControlEventTouchUpInside];

            
            [view addSubview:btnCancel];
        }else if(([orderModel.order_status integerValue]==2)){//已付款，待发货
            UIButton *btnPay=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-85, 29, 80, 24)];
            [btnPay setTitle:@"等待卖家发货" forState:UIControlStateNormal];
            [btnPay setTitleColor:RGB(128, 128, 128) forState:UIControlStateNormal];
            btnPay.titleLabel.font =[UIFont  systemFontOfSize:11];
//            btnPay.titleLabel.textAlignment=NSTextAlignmentRight;
            btnPay.backgroundColor=[UIColor whiteColor];
            [view addSubview:btnPay];
            
        }else if(([orderModel.order_status integerValue]==3)){//待收货
            UIButton *btnPay=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-85, 29, 80, 24)];
            [btnPay setTitle:@"卖家已发货" forState:UIControlStateNormal];
            [btnPay setTitleColor:RGB(128, 128, 128) forState:UIControlStateNormal];
            btnPay.titleLabel.font =[UIFont  systemFontOfSize:11];
            //            btnPay.titleLabel.textAlignment=NSTextAlignmentRight;
            btnPay.backgroundColor=[UIColor whiteColor];
            [view addSubview:btnPay];
            
        }else if([orderModel.order_status integerValue]==8 || [orderModel.order_status integerValue]==9){//订单完成和取消状态
            
            //付款按钮
//            UIButton *btnPay=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 29, 80, 24)];
//            [btnPay setTitle:@"确认收货" forState:UIControlStateNormal];
//            [btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            btnPay.titleLabel.font =[UIFont  systemFontOfSize:11];
//            btnPay.backgroundColor=RGB(255, 13, 94);
//            btnPay.layer.masksToBounds=YES;
//            btnPay.layer.cornerRadius=3;
//            [view addSubview:btnPay];;
            //删除订单按钮
            UIButton *btnDel=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 29, 80, 24)];
            [btnDel setTitle:@"删除订单" forState:UIControlStateNormal];
            [btnDel setTitleColor:RGB(128, 128, 128) forState:UIControlStateNormal];
            btnDel.titleLabel.font =[UIFont  systemFontOfSize:11];
            btnDel.backgroundColor=[UIColor whiteColor];
            btnDel.layer.masksToBounds=YES;
            btnDel.layer.borderWidth=0.5;
            btnDel.layer.borderColor=RGB(179, 179, 179).CGColor;
            btnDel.layer.cornerRadius=3;
            btnDel.tag=[orderModel.id integerValue];
            [btnDel addTarget:self action:@selector(gotoDelOrder:) forControlEvents:UIControlEventTouchUpInside];
            

            [view addSubview:btnDel];

            
        }else if([orderModel.order_status integerValue]==7){//订单完成和取消状态
            
            //删除订单按钮
            UIButton *btnDel=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 29, 80, 24)];
            [btnDel setTitle:@"我要评价" forState:UIControlStateNormal];
            [btnDel setTitleColor:RGB(128, 128, 128) forState:UIControlStateNormal];
            btnDel.titleLabel.font =[UIFont  systemFontOfSize:11];
            btnDel.backgroundColor=[UIColor whiteColor];
            btnDel.layer.masksToBounds=YES;
            btnDel.layer.borderWidth=0.5;
            btnDel.layer.borderColor=RGB(179, 179, 179).CGColor;
            btnDel.layer.cornerRadius=3;
            btnDel.tag=[orderModel.id integerValue];
            [btnDel addTarget:self action:@selector(gotoDelOrder:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [view addSubview:btnDel];
            
        }
        
        if (_result_array.count!=section+1) {
            //给底部footer 加13个像素间距
            UILabel *jianju=[[UILabel alloc] initWithFrame:CGRectMake(0, 58, SCREEN_WIDTH, 13)];
            jianju.backgroundColor=RGB(237, 237, 237);
            [view addSubview:jianju];
        }
        
        
        
        view.backgroundColor=[UIColor whiteColor];
        return view;
    }else{
        //内层footer
        Order_package *selectedPackage;
        for (OrderModel *orderModel in _result_array) {
            NSArray *array=orderModel.package_info;
            for (Order_package *package in array) {
                if ([package.id integerValue]==tableView.tag) {
                    selectedPackage=package;
                }
            }
        }
        
        
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 72)];
        
        //运费
        UILabel *head=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH/2, 20)];
        head.text=@"运费:";
        head.font=[UIFont boldSystemFontOfSize:11];
        head.textColor=RGB(51, 51, 51);
        [view addSubview:head];
        
        //运费金额
        UILabel *ship=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 5, 70, 20)];
        ship.text=[NSString stringWithFormat:@"¥%.2f",selectedPackage.shipping_amount];
        ship.textAlignment=NSTextAlignmentRight;
        ship.font =[UIFont  boldSystemFontOfSize:11];
        ship.textColor=RGB(255, 13, 94);
        [view addSubview:ship];
        
        //预付税费 transport_amount
        UILabel *transport=[[UILabel alloc] initWithFrame:CGRectMake(10, 28, SCREEN_WIDTH/2, 20)];
        transport.text=@"预估税费:";
        transport.textColor=RGB(51, 51, 51);
        transport.font=[UIFont boldSystemFontOfSize:11];
        [view addSubview:transport];
        
        //预付税费金额
        UILabel *transport_amout=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 28, 70, 20)];
        transport_amout.text=[NSString stringWithFormat:@"¥%.2f",selectedPackage.transport_amount];
        transport_amout.textAlignment=NSTextAlignmentRight;
        transport_amout.font =[UIFont  boldSystemFontOfSize:11];
        transport_amout.textColor=RGB(255, 13, 94);
        [view addSubview:transport_amout];
        
        //小计
        UILabel *subTotal=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH/2, 20)];
//        subTotal.text=@"小计:";
        subTotal.text=[NSString stringWithFormat:@"共 %d 件商品",selectedPackage.buy_num];
        subTotal.font=[UIFont systemFontOfSize:11];
        subTotal.textColor=RGB(128, 128, 128);
        [view addSubview:subTotal];
        
        //小计金额
        UILabel *subTotal_amout=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 50, 70, 20)];
        subTotal_amout.text=[NSString stringWithFormat:@"¥%.2f",selectedPackage.package_amount];
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
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==_tableView) {
        return 25;
    }else{
        return 38;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView==_tableView) {
        return 71;//本身距离加间距
    }else{
        return 72;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableView) {
        return _goods_arrayForSubView.count*80+125;//＋120头尾高度
    }else{
        return 80;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==_tableView) {
        return self.result_array.count;
    }else{
        return 1;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==_tableView) {
        OrderModel *orderModel=_result_array[section];
        return orderModel.package_info.count;
    }else{
        Order_package *selectedPackage;
        for (OrderModel *orderModel in _result_array) {
            NSArray *array=orderModel.package_info;
            for (Order_package *package in array) {
                if ([package.id integerValue]==tableView.tag) {
                    selectedPackage=package;
                }
            }
        }
        
        return selectedPackage.goods.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    

    if (tableView == _tableView)
    {
        static NSString *CellIdentifier = @"OrderListCell";
        OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //出列可重用的cell
        if (cell == nil) {
            cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OrderListCell"];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色
        
        OrderModel *orderModel=_result_array[indexPath.section];

        _package=orderModel.package_info[indexPath.row];
        
        _goods_arrayForSubView=_package.goods;
        
        _subTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _goods_arrayForSubView.count*80+112)];
        _subTableView.delegate = self;
        _subTableView.dataSource = self;
        _subTableView.scrollEnabled = NO;
        _subTableView.tag=[_package.id integerValue];
        [cell.contentView addSubview:_subTableView];
//        cell.textLabel.text =[NSString stringWithFormat:@"rootTableView section=%ld item=%ld",(long)indexPath.section,(long)indexPath.row];
        
        cell.backgroundColor=[UIColor whiteColor];
        
        return cell;
    }else
    {
        static NSString *CellIdentifier2 = @"OrderListCell2";
        OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2]; //出列可重用的cell
        if (cell == nil) {
            cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier2];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色
        
        Order_package *selectedPackage;
        for (OrderModel *orderModel in _result_array) {
            NSArray *array=orderModel.package_info;
            for (Order_package *package in array) {
                if ([package.id integerValue]==tableView.tag) {
                    selectedPackage=package;
                }
            }
        }
        
        Order_goods *goods=[selectedPackage.goods objectAtIndex:indexPath.row];
        //图片
        [cell.imageView setImageWithURL:[NSURL URLWithString:goods.img_url] placeholderImage:[UIImage imageNamed:@"default_04.png"]];
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        cell.textLabel.text =[MyUtil trim:goods.goods_name] ;
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
        
//        cell.detailTextLabel.text=[NSString stringWithFormat:@"¥%.2f", goods.goods_price];
//        cell.detailTextLabel.textColor=RGB(255, 13, 94);
//        cell.detailTextLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:13];
        
        

        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }

    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView != _tableView){
        Order_package *selectedPackage;
        for (OrderModel *orderModel in _result_array) {
            NSArray *array=orderModel.package_info;
            for (Order_package *package in array) {
                if ([package.id integerValue]==tableView.tag) {
                    selectedPackage=package;
                }
            }
        }
        
        Order_goods *goods=[selectedPackage.goods objectAtIndex:indexPath.row];
        [self gotoGoodsDetail:goods.goods_id];
    }

}

#pragma mark - button Action

-(void)gotoPackageDetail:(UIButton *)sender{
    NSLog(@"----pass-gotoPackageDetail %@---",@"test");
    if (sender.tag==0) {
        return;
    }
    PackageDetailController *detailViewController =[[PackageDetailController alloc] init];
    
    detailViewController.package_id=[NSString stringWithFormat:@"%d", sender.tag];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
}
    
-(void)gotoPay:(UIButton *)sender{
    //订单号
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id=='%d'",sender.tag]];
    
    OrderModel *orderModel = [self.order_array filteredArrayUsingPredicate:predicate][0];
    
//    AlipayOrder *order=[[AlipayOrder alloc] init];
//    
//    order.tradeNO = orderModel.id; //订单ID（由商家自行制定）
//    _selectedOrderNo=orderModel.id;
//    order.productName = @"海淘商品标题"; //商品标题
//    order.productDescription = @"商品描述"; //商品描述
//    order.amount = [NSString stringWithFormat:@"%.2f",0.01];
//    _selectAmount=orderModel.pay_amount;
//    
//    SingletonAlipay *alipay=[SingletonAlipay singletonAlipay];
//    alipay.delegate=self;
//    [alipay payOrder:order];
    
    ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
    detailViewController.orderNo=orderModel.id;
    detailViewController.payAmount=orderModel.pay_amount;
    Order_package *package=orderModel.package_info[0];
    Order_goods *shop = package.goods[0];
    detailViewController.productName=shop.goods_name;
    detailViewController.productDescription=@"暂无";
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.navigationController pushViewController:detailViewController animated:YES];

    
}


-(void)gotoCancelOrder:(UIButton *)sender{
    //订单号
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_cancelOrder withType:POSTURL withPam:@{@"order_id":[NSString stringWithFormat:@"%d",sender.tag]} withUrlName:@"cancelOrder"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
//    OrderSuccessController *detailViewController =[[OrderSuccessController alloc] initWithNibName:@"OrderSuccessController" bundle:nil];
//    detailViewController.orderNoString=_selectedOrderNo;
//    detailViewController.payAmountString=[NSString stringWithFormat:@"%.2f",_selectAmount];
//    
//    _selectAmount=0;
//    _selectedOrderNo=nil;
//    
//    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    
//    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

-(void)gotoDelOrder:(UIButton *)sender{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"是否确认删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
    _selectedOrderNo=[NSString stringWithFormat:@"%d",sender.tag] ;
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"----pass-alert%d---",buttonIndex);
    if (buttonIndex==1) {
        //订单号
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app startLoading];
        
        HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_delOrder withType:POSTURL withPam:@{@"order_id":_selectedOrderNo} withUrlName:@"delOrder"];
        httpController.delegate = self;
        [httpController onSearchForPostJson];
    }else{
        _selectedOrderNo=nil;
    }
    
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
#pragma mark - alipay delegate
//-(void)callBack:(NSDictionary *)resultDic{
//    if (resultDic.count==0) {
//        ShowMessage(@"支付订单失败，如果您确定已经付款成功，请及时联系客服！");
//        return;
//        
//    }
//    //9000订单支付成功 且 success＝＝true
//    if ([[resultDic objectForKey:@"partner"] rangeOfString:@"success=\"true\""].location == NSNotFound) {
//        ShowMessage(@"支付订单失败，如果您确定已经付款成功，请及时联系客服！");
//        return;
//    }
//    if ([[resultDic objectForKey:@"resultStatus"] longLongValue]==9000) {
//        OrderSuccessController *detailViewController =[[OrderSuccessController alloc] initWithNibName:@"OrderSuccessController" bundle:nil];
//        detailViewController.orderNoString=_selectedOrderNo;
//        detailViewController.payAmountString=[NSString stringWithFormat:@"%.2f",_selectAmount];
//        
//        _selectAmount=0;
//        _selectedOrderNo=nil;
//        
//        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//        
//        [self.navigationController pushViewController:detailViewController animated:YES];
//    }else{
//    
////        ShowMessage(@"支付订单出现异常，如果您确定已经付款成功，请及时联系客服！");
////        return;
//    }
//    
//
//}
@end
