//
//  TariffViewController.m
//  haitao
//
//  Created by pwy on 15/8/1.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "TariffViewController.h"
#import "Order_package.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OrderListCell.h"
#import "Order_goods.h"
#import "Order_goodsAttr.h"
#import "New_Goods.h"
#import "Goods_Ext.h"
#import "HTGoodDetailsViewController.h"
#import "ChoosePayController.h"
#import "TariffDetailController.h"

@interface TariffViewController ()

@end

@implementation TariffViewController

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
    self.title=@"关税缴纳";
    
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    
    NSArray *segmentedArray = @[@"全部",@"未付关税",@"已付关税"];
    
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
    
    
    [self initData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initData{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_getOrderTaxList withType:GETURL withPam:nil withUrlName:@"getOrderTaxList"];
    httpController.delegate = self;
    [httpController onSearch];
    
}

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    //返回原来界面
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
        NSDictionary *dic=[dictemp objectForKey:@"data"];

        if ([urlname isEqualToString:@"getOrderTaxList"]) {
            if (dic.count==0) {
                _tariff_array=@[];
                [self segmentAction:_seg];
                [self showEmptyView];
                return;
                
            }
            _tariff_array=[OrderTax objectArrayWithKeyValuesArray:[dic objectForKey:@"list"]];
            _result_array=_tariff_array;

            [self segmentAction:_seg];
            
            
        }else if([urlname isEqualToString:@"delOrderTax"]){
            [self segmentAction:_seg];
            NSLog(@"----pass-cancelOrder%@---",dictemp);
            
            ShowMessage(@"删除成功！");
            
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
    if(_result_array.count==0){
        _empty_view=[[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, SCREEN_HEIGHT - 34)];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-34-64, 200, 20)];
        label.text=@"暂无关税信息";
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=RGB(51, 51, 51);
        [_empty_view addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        _empty_view.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_empty_view];
    }
    
    
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    NSLog(@"Index %i", Index);
    
    static NSString *prediStr1 = @"status LIKE '*'";
    
    //    1）.等于查询
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", "Ansel"];
    //    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
    //
    //    2）.模糊查询
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", @"A"]; //predicate只能是对象
    //    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
    
    switch (Index) {
        case 0:{
            
            prediStr1 = @"status LIKE '*'";
            
        }
            break;
        case 1:{
            
            prediStr1 = [NSString stringWithFormat:@"status=='%d'", 1];//未付款
        }
            break;
        case 2:{
            
            prediStr1 = [NSString stringWithFormat:@"status=='%d'", 2];//已付款
            
        }
            
        default:
            break;
    }
    
    NSLog(@"----pass-prediStr1%@---",[NSString stringWithFormat:@"%@",prediStr1]);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@",prediStr1]];
    NSArray *orderlist=self.tariff_array;
    self.result_array = [orderlist filteredArrayUsingPredicate:predicate];
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
    //内层header
    OrderTax *orderTax=_result_array[section];
    _packageDetail=orderTax.package_info;
    
    Order_package *package=_packageDetail.package_info;
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
    
    //包裹
    UILabel *head=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 38)];
    head.text=[NSString stringWithFormat:@"包裹商品"];
    head.font =[UIFont  boldSystemFontOfSize:13];//加粗字体
    head.textColor=RGB(51, 51, 51);
    [view addSubview:head];
    
//    //国家icon
//    UIImageView *country=[[UIImageView alloc] initWithFrame:CGRectMake(70, 9, 20, 20)];
//    [country setImageWithURL:[NSURL URLWithString:package.country_flag_url] placeholderImage:[UIImage imageNamed:@"default_04.png"]];
//    [view addSubview:country];
//    
//    //商城名称
//    UILabel *shopname=[[UILabel alloc] initWithFrame:CGRectMake(95, 0, 70, 38)];
//    shopname.text=package.shop_name;
//    shopname.font =[UIFont  systemFontOfSize:10];
//    shopname.textColor=RGB(179, 179, 179);
//    [view addSubview:shopname];
//    
//    //直邮转运
//    UILabel *ship=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 0, 80, 38)];
//    ship.text=package.ship_name;
//    ship.font =[UIFont  boldSystemFontOfSize:11];
//    ship.textColor=RGB(51, 51, 51);
//    [view addSubview:ship];
    
    //订单编号
    UILabel *orderNo=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150, 0, 140, 38)];
    orderNo.text=[NSString stringWithFormat:@"订单编号：%@",_packageDetail.order.id];
    orderNo.font =[UIFont  boldSystemFontOfSize:11];
    orderNo.textColor=RGB(179, 179, 179);
    orderNo.textAlignment=NSTextAlignmentRight;
    [view addSubview:orderNo];
    
    UILabel *jianju=[[UILabel alloc] initWithFrame:CGRectMake(0, 37, SCREEN_WIDTH, 0.5)];
    jianju.backgroundColor=RGB(237, 237, 237);
    [view addSubview:jianju];
    
    view.backgroundColor=[UIColor whiteColor];
    return view;
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    OrderTax *orderTax=_result_array[section];
    _packageDetail=orderTax.package_info;
    
    Order_package *package=_packageDetail.package_info;
    //内层footer
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 72)];
    
//    //运费
//    UILabel *head=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH/2, 20)];
//    head.text=[_packageDetail.package_info.ship_type integerValue]==1?@"直邮运费":@"转运运费";
//    head.font=[UIFont boldSystemFontOfSize:11];
//    head.textColor=RGB(51, 51, 51);
//    [view addSubview:head];
//    
//    //运费金额
//    UILabel *ship=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 5, 70, 20)];
//    ship.text=[NSString stringWithFormat:@"¥%.2f",package.shipping_amount];
//    ship.textAlignment=NSTextAlignmentRight;
//    ship.font =[UIFont  boldSystemFontOfSize:11];
//    ship.textColor=RGB(255, 13, 94);
//    [view addSubview:ship];
//    
//    //预付税费 transport_amount
//    UILabel *transport=[[UILabel alloc] initWithFrame:CGRectMake(10, 28, SCREEN_WIDTH/2, 20)];
//    transport.text=[_packageDetail.package_info.ship_type integerValue]==1?@"预收关税":@"预估关税";
//    transport.textColor=RGB(51, 51, 51);
//    transport.font=[UIFont boldSystemFontOfSize:11];
//    [view addSubview:transport];
//    
//    //预付税费金额
//    UILabel *transport_amout=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 28, 70, 20)];
//    transport_amout.text=[NSString stringWithFormat:@"%.2f", [_packageDetail.package_info.ship_type integerValue]==1?_packageDetail.package_info.direct_amount:_packageDetail.package_info.transport_amount];
//    transport_amout.textAlignment=NSTextAlignmentRight;
//    transport_amout.font =[UIFont  boldSystemFontOfSize:11];
//    transport_amout.textColor=RGB(255, 13, 94);
//    [view addSubview:transport_amout];
    
    //小计
    UILabel *subTotal=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH/2, 20)];
    //        subTotal.text=@"小计:";
    subTotal.text=[NSString stringWithFormat:@"共%d件商品",package.buy_num];
    subTotal.font=[UIFont boldSystemFontOfSize:11];
    subTotal.textColor=RGB(128, 128, 128);
    [view addSubview:subTotal];
    
    //小计金额
    UILabel *subTotal_amout=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150, 5, 140, 20)];
    NSString *totalText=[NSString stringWithFormat:@"应缴税额：¥%.2f",[orderTax.pay_amount floatValue]];
    subTotal_amout.textAlignment=NSTextAlignmentRight;
    subTotal_amout.font =[UIFont  boldSystemFontOfSize:11];
//    subTotal_amout.textColor=RGB(255, 13, 94);
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:totalText];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:RGB(255, 13, 94)
     
                          range:NSMakeRange(5, totalText.length-5)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:RGB(128, 128, 128)
     
                          range:NSMakeRange(0, 5)];
    
    subTotal_amout.attributedText=AttributedStr;
    
    [view addSubview:subTotal_amout];
    
    
    UILabel *jianju=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    jianju.backgroundColor=RGB(237, 237, 237);
    [view addSubview:jianju];
    
    UILabel *jianju_footer=[[UILabel alloc] initWithFrame:CGRectMake(0, 29.5, SCREEN_WIDTH, 0.5)];
    jianju_footer.backgroundColor=RGB(237, 237, 237);
    [view addSubview:jianju_footer];
    
    if ([orderTax.status integerValue]==1) {
        //付款按钮
        UIButton *btnPay=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 32, 80, 24)];
        [btnPay setTitle:@"立即支付" forState:UIControlStateNormal];
        [btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnPay.titleLabel.font =[UIFont  systemFontOfSize:11];
        btnPay.backgroundColor=RGB(255, 13, 94);
        btnPay.layer.masksToBounds=YES;
        btnPay.layer.cornerRadius=3;
        
        btnPay.tag=[orderTax.id integerValue];
        [btnPay addTarget:self action:@selector(gotoPay:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btnPay];

    }else{
        //取消订单按钮
        UIButton *btnCancel=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 32, 80, 24)];
        [btnCancel setTitle:@"删除" forState:UIControlStateNormal];
        [btnCancel setTitleColor:RGB(128, 128, 128) forState:UIControlStateNormal];
        btnCancel.titleLabel.font =[UIFont  systemFontOfSize:11];
        btnCancel.backgroundColor=[UIColor whiteColor];
        btnCancel.layer.masksToBounds=YES;
        btnCancel.layer.borderWidth=0.5;
        btnCancel.layer.borderColor=RGB(179, 179, 179).CGColor;
        btnCancel.layer.cornerRadius=3;
        btnCancel.tag=[orderTax.id integerValue];
        [btnCancel addTarget:self action:@selector(gotoDelOrderTax:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [view addSubview:btnCancel];
    
    }
    
    
    UILabel *jianju_footer2=[[UILabel alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 13)];
    jianju_footer2.backgroundColor=RGB(237, 237, 237);
    [view addSubview:jianju_footer2];
    
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
    
    return _result_array.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OrderTax *orderTax=_result_array[section];
    return orderTax.package_info.package_info.goods.count;
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
    OrderTax *orderTax=_result_array[indexPath.section];
    _packageDetail=orderTax.package_info;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色
    
    Order_goods *goods=[_packageDetail.package_info.goods objectAtIndex:indexPath.row];
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
    OrderTax *orderTax=_result_array[indexPath.section];
    
    TariffDetailController *vc=[[TariffDetailController alloc] initWithNibName:nil bundle:nil];
    vc.orderTax=orderTax;
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
    
//    PackageDetail *package=orderTax.package_info;
//    Order_goods *goods=[package.package_info.goods objectAtIndex:indexPath.row];
//    
//    
//    [self gotoGoodsDetail:goods.goods_id];
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


-(void)gotoPay:(UIButton *)sender{
    //订单号
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id=='%d'",sender.tag]];
    
    OrderTax *orderTax = [self.tariff_array filteredArrayUsingPredicate:predicate][0];
    
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
    detailViewController.orderNo=orderTax.pay_id;
    detailViewController.payAmount=[orderTax.pay_amount floatValue];
    Order_package *package=orderTax.package_info.package_info;
    Order_goods *shop = package.goods[0];
    detailViewController.productName=shop.goods_name;
    detailViewController.productDescription=@"暂无";
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    
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
        
        HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_delTaxOrder withType:POSTURL withPam:@{@"id":_selectedOrderNo} withUrlName:@"delTaxOrder"];
        httpController.delegate = self;
        [httpController onSearchForPostJson];
    }else{
        _selectedOrderNo=nil;
    }
    
}


@end
