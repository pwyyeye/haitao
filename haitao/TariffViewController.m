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
    
    NSArray *segmentedArray = @[@"全部",@"已付关税",@"未付关税"];
    
    UISegmentedControl *seg=[[UISegmentedControl alloc] initWithItems:segmentedArray];
    
    seg.frame=CGRectMake(0, 0, (SCREEN_WIDTH/4)*4, 34);
    seg.selectedSegmentIndex = 0;//设置默认选择项索引
    
    //清除原有格式颜色
    seg.tintColor=[UIColor clearColor];
    //设置背景色
    [seg setBackgroundColor:RGB(237, 237, 237)];
    //设置字体样式
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                             NSForegroundColorAttributeName: RGB(255, 13, 94)};
    [seg setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                               NSForegroundColorAttributeName: [UIColor colorWithWhite:0.6 alpha:1]};
    [seg setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    
    // 使用颜色创建UIImage//未选中颜色
    CGSize imageSize = CGSizeMake((SCREEN_WIDTH/4), 34);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [RGB(237, 237, 237) set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *normalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //设置未选中背景色
    [seg setBackgroundImage:normalImg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // 使用颜色创建UIImage //选中颜色
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[UIColor whiteColor] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *selectedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //设置选中背景色
    [seg setBackgroundImage:selectedImg forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    
    [self.view addSubview:seg];
    
    [seg addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
    
    
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
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_getPackageDetail withType:GETURL withPam:@{@"package_id":@"144"} withUrlName:@"getPackageDetail"];
    httpController.delegate = self;
    [httpController onSearch];
    
}

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    //返回原来界面
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
        NSDictionary *dic=[dictemp objectForKey:@"data"];

        if ([urlname isEqualToString:@"getOrderList"]) {
            if (dic.count==0) {
                [_tableView reloadData];
                return;
                
            }
        }
    }
}

-(void)gotoBack{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showEmptyView];
}

-(void)showEmptyView{
     [_empty_view removeFromSuperview];
    if(_result_array.count==0){
        _empty_view=[[UIView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-164, 200, 20)];
        label.text=@"暂无关税信息";
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=RGB(51, 51, 51);
        [_empty_view addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:_empty_view];
    }
    
    
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    NSLog(@"Index %i", Index);
    
    //    static NSString *prediStr1 = @"cat_name LIKE '*'";
    //
    //    //    1）.等于查询
    //    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", "Ansel"];
    //    //    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
    //    //
    //    //    2）.模糊查询
    //    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", @"A"]; //predicate只能是对象
    //    //    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
    //
    //    switch (Index) {
    //        case 0:{
    //
    //            prediStr1 = @"status LIKE '*'";
    //
    //        }
    //            break;
    //        case 1:{
    //
    //            prediStr1 = [NSString stringWithFormat:@"status=='%d'", 1];
    //        }
    //            break;
    //        case 2:{
    //
    //            prediStr1 = [NSString stringWithFormat:@"status=='%d'", 0];
    //
    //        }
    //            break;
    //
    //        default:
    //            break;
    //    }
    //
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@",prediStr1]];
    //    
    //    self.result_array = [self.Coupons_array filteredArrayUsingPredicate:predicate];
    //    [self.tableView reloadData];
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
    head.font=[UIFont boldSystemFontOfSize:11];
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
    transport.text=[_packageModel.package_info.ship_type integerValue]==1?@"预收税费":@"预估税费";
    transport.textColor=RGB(51, 51, 51);
    transport.font=[UIFont boldSystemFontOfSize:11];
    [view addSubview:transport];
    
    //预付税费金额
    UILabel *transport_amout=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 28, 70, 20)];
    transport_amout.text=[NSString stringWithFormat:@"%.2f", [_packageModel.package_info.ship_type integerValue]==1?_packageModel.package_info.direct_amount:_packageModel.package_info.transport_amount];
    transport_amout.textAlignment=NSTextAlignmentRight;
    transport_amout.font =[UIFont  boldSystemFontOfSize:11];
    transport_amout.textColor=RGB(255, 13, 94);
    [view addSubview:transport_amout];
    
    //小计
    UILabel *subTotal=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH/2, 20)];
    //        subTotal.text=@"小计:";
    subTotal.text=[NSString stringWithFormat:@"实付款"];
    subTotal.font=[UIFont boldSystemFontOfSize:11];
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
//    Order_goods *goods=[_packageModel.package_info.goods objectAtIndex:indexPath.row];
//    [self gotoGoodsDetail:goods.goods_id];
}

@end
