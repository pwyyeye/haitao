//
//  FavoriteViewController.m
//  haitao
//
//  Created by pwy on 15/7/30.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "FavoriteViewController.h"
#import "New_Goods.h"
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
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)]];
    
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
    [httpController onSearch];

}
-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
//    NSLog(@"----pass-login%@---",dictemp);
    //返回原来界面
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
        //[USER_DEFAULT setObject:[dictemp objectForKey:@"s_app_id"] forKey:@"s_app_id"];
        NSDictionary *dic=[dictemp objectForKey:@"data"];
        
        
        _allData=@[@"所有收藏"];
        
        
       
        NSMutableArray *array_cat=[[NSMutableArray alloc] init];
        [array_cat insertObject:@{@"id":@"",@"name":@"所有分类"} atIndex:0];
        [array_cat addObjectsFromArray:[dic objectForKey:@"cat"]];

        NSMutableArray *array_shop=[[NSMutableArray alloc] init];
        [array_shop insertObject:@{@"id":@"",@"name":@"所有商城"} atIndex:0];
        [array_shop addObjectsFromArray:[dic objectForKey:@"shop"]];
        
        NSMutableArray *array_brand=[[NSMutableArray alloc] init];
        [array_brand insertObject:@{@"id":@"",@"name":@"所有品牌"} atIndex:0];
        [array_brand addObjectsFromArray:[dic objectForKey:@"brand"]];
        
        
        _brand_data=[array_brand copy];
        
        _category_data=[array_cat copy];
        
        _shop_data=[array_shop copy];
        
        _goodsList=[New_Goods objectArrayWithKeyValuesArray:[dic objectForKey:@"list"]];
        
        
//        [self.navigationController popViewControllerAnimated:YES];
 
        //判断是否有注册通知
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeToReload" object:nil];
        
        
        
        DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
        menu.indicatorColor=RGB(255, 13, 94);
        menu.textColor=[UIColor colorWithWhite:0.1 alpha:0.9];
        menu.separatorColor=[UIColor redColor];
        menu.backgroundViewColor=[UIColor colorWithWhite:0.93 alpha:1.0];
        
        
        menu.dataSource = self;
        menu.delegate = self;
        [self.view addSubview:menu];
        
        self.tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
            tableView.dataSource = self;
            [self.view addSubview:tableView];
            tableView;
        });

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
        return _brand_data.count;
        
    }
    else if(column==3){
        return _shop_data.count;
        
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
    
    static NSString *prediStr1 = @"shop_name LIKE '*'",
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
                prediStr1 = @"shop_name LIKE '*'";
            } else {
                prediStr1 = [NSString stringWithFormat:@"shop_name=='%@'", title];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.results.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    cell.textLabel.text = self.results[indexPath.row];
    return cell;
}


@end
