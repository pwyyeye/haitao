//
//  FavoriteViewController.m
//  haitao
//
//  Created by pwy on 15/7/30.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "FavoriteViewController.h"
#import "New_Goods.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "FavoriteCell.h"
#import "New_Goods.h"
#import "Goods_Ext.h"
#import "HTGoodDetailsViewController.h"
@interface FavoriteViewController ()

@end

@implementation FavoriteViewController

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
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];
    
    //返回的颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //navigationBar的标题
    //self.navigationItem.title=@"登录";
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    
    self.title=@"收藏的宝贝";
    
    
    [self initData];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoBack{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)initData{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_getFav withType:GETURL withPam:nil withUrlName:@"getFav"];
    httpController.delegate = self;
    [httpController onSyncPostJson];

}
-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
//    NSLog(@"----pass-login%@---",dictemp);
    //返回原来界面
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
        
        if ([urlname isEqualToString:@"getFav"]) {
            //[USER_DEFAULT setObject:[dictemp objectForKey:@"s_app_id"] forKey:@"s_app_id"];
            NSDictionary *dic=[dictemp objectForKey:@"data"];
            
            
            
            
            
            NSMutableArray *array_cat=[[NSMutableArray alloc] init];
            [array_cat insertObject:@{@"id":@"",@"name":@"所有分类"} atIndex:0];
            if (dic.count!=0) {
                [array_cat addObjectsFromArray:[dic objectForKey:@"cat"]];
            }
            
            
            NSMutableArray *array_shop=[[NSMutableArray alloc] init];
            [array_shop insertObject:@{@"id":@"",@"name":@"所有商城"} atIndex:0];
            if (dic.count!=0) {
                [array_shop addObjectsFromArray:[dic objectForKey:@"shop"]];
            }
            
            NSMutableArray *array_brand=[[NSMutableArray alloc] init];
            [array_brand insertObject:@{@"id":@"",@"name":@"所有品牌"} atIndex:0];
            if (dic.count!=0) {
                [array_brand addObjectsFromArray:[dic objectForKey:@"brand"]];
            }
            
            
            _brand_data=[array_brand copy];
            
            _category_data=[array_cat copy];
            
            _shop_data=[array_shop copy];
            
            if (dic.count!=0) {
                _goodsList=[New_Goods objectArrayWithKeyValuesArray:[dic objectForKey:@"list"]];

            }
            
            _results=_goodsList;
            
            if (_menu!=nil) {
                [_menu removeFromSuperview];
            }
            
            _menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
            _menu.indicatorColor=[UIColor colorWithWhite:0.4 alpha:0.8];
            _menu.textColor=[UIColor colorWithWhite:0.4 alpha:0.8];
            //        menu.separatorColor=[UIColor redColor];
            _menu.backgroundViewColor=[UIColor colorWithWhite:0.93 alpha:1.0];
            
            
            _menu.dataSource = self;
            _menu.delegate = self;
            [self.view addSubview:_menu];
            
            self.tableView = ({
                UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
                tableView.dataSource = self;
                tableView.delegate=self;
                [self.view addSubview:tableView];
                tableView;
            });
            self.tableView.tableFooterView=[[UIView alloc]init];
            self.tableView.tableHeaderView=[[UIView alloc]init];
            
           
            
            

            
        }else if([urlname isEqualToString:@"delFav"]){
            
//            [self initData];
            NSLog(@"----pass-delFav%@---",dictemp);
            [self showEmptyView];
            ShowMessage(@"删除成功");
            
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self showEmptyView];
}

-(void)showEmptyView{
    if (_results.count>0 && ![_empty_view isEqual:[NSNull null]]) {
        [_empty_view removeFromSuperview];
        
    }else if(_results.count==0){
        _empty_view=[[UIView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-164, 200, 20)];
        label.text=@"收藏列表为空";
        [_empty_view addSubview:label];
        label.textAlignment = UITextAlignmentCenter;
        
        [self.view addSubview:_empty_view];
    }


}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 4;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column==0) {
        return 1;
    }else if(column==1){
        return _category_data.count;
    
    }
    else if(column==2){
        return _shop_data.count;
        
    }
    else if(column==3){
        return _brand_data.count;
        
    }
    return 1;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    switch (indexPath.column) {
        case 0: return @"所有收藏";
            break;
        case 1: return [self.category_data[indexPath.row] objectForKey:@"name"];
            break;
        case 2: return [self.shop_data[indexPath.row] objectForKey:@"name"];
            break;
        case 3: return [self.brand_data[indexPath.row] objectForKey:@"name"];
            break;
        default:
            return nil;
            break;
    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    NSLog(@"column:%li row:%li", (long)indexPath.column, (long)indexPath.row);
    NSLog(@"%@",[menu titleForRowAtIndexPath:indexPath]);
    NSString *title = [menu titleForRowAtIndexPath:indexPath];
    
    static NSString *prediStr1 = @"cat_name LIKE '*'",
    *prediStr2 = @"shop_name LIKE '*'",
    *prediStr3 = @"brand_name LIKE '*'";
    
    
//    1）.等于查询
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", "Ansel"];
//    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
//    
//    2）.模糊查询
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", @"A"]; //predicate只能是对象
//    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
    
    switch (indexPath.column) {
        
        case 1:{
            if (indexPath.row == 0) {
                prediStr1 = @"cat_name LIKE '*'";
            } else {
                prediStr1 = [NSString stringWithFormat:@"cat_name=='%@'", title];
            }
        }
            break;
        case 2:{
            if (indexPath.row == 0) {
                prediStr2 = @"shop_name LIKE '*'";
            } else {
                prediStr2 = [NSString stringWithFormat:@"shop_name=='%@'", title];
            }
        }
            break;
        case 3:{
            if (indexPath.row == 0) {
                prediStr3 = @"brand_name LIKE '*'";
            } else {
                prediStr3 = [NSString stringWithFormat:@"brand_name=='%@'", title];
            }
        }
            
        default:
            break;
    }
    NSString *string=[NSString stringWithFormat:@"%@ AND %@ AND %@",prediStr1,prediStr2,prediStr3];
    
    NSLog(@"----pass-bijiao%@---",string);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ AND %@ AND %@",prediStr1,prediStr2,prediStr3]];
    
    self.results = [self.goodsList filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}
#pragma table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoriteCell *cell = [[FavoriteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
//    cell.textLabel.text = self.results[indexPath.row];
    New_Goods *goods=_results[indexPath.item];
    cell.textLabel.text=goods.title;
    
    cell.textLabel.numberOfLines=2;
    
//    cell.textLabel.font=[UIFont systemFontOfSize:13];
    cell.textLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:13];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"¥%.2f", goods.price];
    cell.detailTextLabel.textColor=RGB(255, 13, 94);
    cell.detailTextLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [cell.imageView setImageWithURL:[NSURL URLWithString:goods.img_80] placeholderImage:[UIImage imageNamed:@"default_04.png"]];
    
    UILabel *shop_name=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, cell.frame.origin.y+45, 60, 20)];
    shop_name.text=goods.shop_name;
    shop_name.font=[UIFont systemFontOfSize:11.0];
    shop_name.textColor=[UIColor colorWithWhite:0.6 alpha:0.9];
    [cell.contentView addSubview:shop_name];
    
    UIImageView *shop_img=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, cell.frame.origin.y+45, 20, 20)];
    [shop_img setImageWithURL:[NSURL URLWithString:goods.country_flag_url] placeholderImage:[UIImage imageNamed:@"default_04.png"]];
    [cell.contentView addSubview:shop_img];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色

    return cell;
}
//显示删除
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//是否可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//删除行
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    New_Goods *good=_results[indexPath.item];
    NSString *fav_id=[NSString stringWithFormat:@"%@",good.fav_id];
    [self deleteFav:fav_id];
    
NSLog(@"----pass-before----%lu---",(unsigned long)_results.count);
    NSMutableArray *mut=[_results mutableCopy];
    [mut removeObjectAtIndex:indexPath.item];
    _results=[mut copy];
    
    NSLog(@"----pass-after----%lu---",(unsigned long)_results.count);
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
  
    //无法同步 执行出错 只好记录 行
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    New_Goods *goods=_results[indexPath.item];
    [self gotoGoodsDetail:goods.id];
}

-(void)gotoGoodsDetailDo:(NSString *) goods_id{
    NSDictionary *parameters = @{@"id":goods_id};
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsDetail",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getGoodsDetail"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
}
-(void)gotoGoodsDetail:(NSString *) goods_id{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(gotoGoodsDetailDo:) object:goods_id];
    [self performSelector:@selector(gotoGoodsDetailDo:) withObject:goods_id afterDelay:0.3f];
}

-(void)deleteFav:(NSString *)favid{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    NSDictionary *parameters = @{@"id":favid};

    HTTPController *httpController =[[HTTPController alloc] initWith:requestUrl_delFav withType:POSTURL withPam:parameters withUrlName:@"delFav"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];

}

@end
