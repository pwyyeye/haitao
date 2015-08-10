//
//  LogisticsViewController.m
//  haitao
//
//  Created by pwy on 15/8/7.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LogisticsViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OrderListCell.h"
#import "Order_goods.h"
#import "Order_goodsAttr.h"
#import "LogisticsCell.h"
@interface LogisticsViewController ()

@end

@implementation LogisticsViewController

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
    self.title=@"物流详情";
    
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    _goodsTable.dataSource = self;
    _goodsTable.delegate=self;
    
    _logisticsTable.delegate=self;
    _logisticsTable.dataSource=self;
    
    self.goodsTable.tableFooterView=[[UIView alloc]init];
    
    //    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    self.tableView.tableFooterView=[[UIView alloc]init];
//    [self initData];
    
    _shipType.text=_packageModel.package_info.ship_name;
    _shipNumber.text=[NSString stringWithFormat:@"物流单号：%@",_packageModel.package_info.logistic_number]; ;
    _shipStatus.text=[NSString stringWithFormat:@"物流状态：%@",@"???"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.viewWidth.constant=SCREEN_WIDTH;
    
    //tableView的高度时header＋footer＋cell高度*cell个数
    self.tableHeight.constant=38+80*_packageModel.package_info.goods.count-1;
    
    self.tableHeight2.constant=38+50*_packageModel.package_info.logistic_info.count-1;
    
    //自身高度＝tableview的y坐标＋tableView的高度＋coll的高度*个数＋coll展开view的最大高度
    self.viewHeight.constant=self.goodsTable.frame.origin.y+self.tableHeight.constant+self.tableHeight2.constant + 200;
    
    if (self.viewHeight.constant<SCREEN_HEIGHT) {
        self.viewHeight.constant=SCREEN_HEIGHT;
    }
    
}

//-(void)initData{
//    if (_package_id==nil) {
//        return;
//    }
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [app startLoading];
//    
//    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_getPackageDetail withType:GETURL withPam:@{@"package_id":_package_id} withUrlName:@"getPackageDetail"];
//    httpController.delegate = self;
//    [httpController onSearch];
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView==_logisticsTable) {
        //内层header
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
        
        //包裹
        UILabel *head=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 38)];
        head.text=[NSString stringWithFormat:@"物流信息"];
        if (_packageModel.package_info.logistic_info.count==0) {
            head.text=[NSString stringWithFormat:@"暂无物流信息"];
        }
        head.font =[UIFont  boldSystemFontOfSize:12];//加粗字体
        head.textColor=RGB(51, 51, 51);
        [view addSubview:head];
        
        view.backgroundColor=[UIColor whiteColor];
        
        UILabel *jianju=[[UILabel alloc] initWithFrame:CGRectMake(0, 37, SCREEN_WIDTH, 0.5)];
        jianju.backgroundColor=RGB(237, 237, 237);
        [view addSubview:jianju];
        
        return view;

    }else{
        //内层header
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
        
        //包裹
        UILabel *head=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 38)];
        head.text=[NSString stringWithFormat:@"包裹商品"];
        head.font =[UIFont  boldSystemFontOfSize:12];//加粗字体
        head.textColor=RGB(51, 51, 51);
        [view addSubview:head];
        
        
        //订单编号
        UILabel *orderNum=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 0, 80, 38)];
        orderNum.text=[NSString stringWithFormat:@"订单编号：%@",_packageModel.order.id] ;
        orderNum.font =[UIFont  boldSystemFontOfSize:11];
        orderNum.textColor=RGB(51, 51, 51);
        orderNum.textAlignment=UITextAlignmentRight;
        [view addSubview:orderNum];
        
        
        
        UILabel *jianju=[[UILabel alloc] initWithFrame:CGRectMake(0, 37, SCREEN_WIDTH, 0.5)];
        jianju.backgroundColor=RGB(237, 237, 237);
        [view addSubview:jianju];
        
        view.backgroundColor=[UIColor whiteColor];
        return view;

    }
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==_logisticsTable) {
        return _packageModel.package_info.logistic_info.count;
    }else{
        return _packageModel.package_info.goods.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_logisticsTable) {
        return 50;
    }else{
        return 80;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==_logisticsTable) {
        NSArray *array= _packageModel.package_info.logistic_info;
        NSDictionary *dic=array[indexPath.row];
        LogisticsCell *cell = [[LogisticsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"logiccell"];
        if (indexPath.row==0) {
            cell.isFirst=YES;
            cell.imageView.image=[UIImage imageNamed:@"WuLiu_Qidian"];
        }else{
            cell.imageView.image=[UIImage imageNamed:@"WuLiu_hm"];
            if (indexPath.row==array.count-1) {
                cell.isLast=YES;
            }
        }
        
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        cell.lianjiexian=[[UIImageView alloc] init];
        cell.lianjiexian.image=[UIImage imageNamed:@"WuLiu_line"];
        [cell.lianjiexian setContentMode:UIViewContentModeScaleAspectFill];
        [cell.contentView addSubview:cell.lianjiexian];
        
        [cell.contentView bringSubviewToFront:cell.imageView];
        
        cell.textLabel.text=[dic objectForKey:@"info"];
        cell.textLabel.font= [UIFont boldSystemFontOfSize:11];
        cell.textLabel.textColor=RGB(51, 51, 51);
        
        cell.detailTextLabel.text=[dic objectForKey:@"date"];
        cell.detailTextLabel.font= [UIFont systemFontOfSize:10];
        cell.detailTextLabel.textColor=RGB(51, 51, 51);
        return cell;
    }else{
        OrderListCell *cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色
        
        Order_goods *goods=[_packageModel.package_info.goods objectAtIndex:indexPath.row];
        cell.textLabel.text = goods.goods_name;
        cell.textLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:11];
        cell.textLabel.textColor=RGB(51, 51, 51);
        cell.textLabel.numberOfLines=2;
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
        UILabel *goodnum=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, cell.frame.origin.y+60, 70, 20)];
        goodnum.text=[NSString stringWithFormat:@"x %d",goods.buy_num];
        goodnum.textAlignment=NSTextAlignmentRight;
        goodnum.font =[UIFont  boldSystemFontOfSize:11];
        goodnum.textColor=RGB(128, 128, 128);
        [cell.contentView addSubview:goodnum];
        
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:goods.img_url] placeholderImage:[UIImage imageNamed:@"default_04.png"]];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;

    }
    
    
    
}
@end
