//
//  MessageViewController.m
//  haitao
//
//  Created by pwy on 15/8/1.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageModel.h"
#import "MessageCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MessageDetail.h"
@interface MessageViewController ()

@end

@implementation MessageViewController

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
    self.title=@"站内信";
    
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    
    NSArray *segmentedArray = @[@"所有站内信",@"已读站内信",@"未读站内信"];
    
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
    
    [self initData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)gotoBack{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showEmptyView];
}

-(void)showEmptyView{
    if (_result_array.count>0 && ![_empty_view isEqual:[NSNull null]]) {
        [_empty_view removeFromSuperview];
        
    }else if(_result_array.count==0){
        _empty_view=[[UIView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-164, 200, 20)];
        label.text=@"暂无消息";
        [_empty_view addSubview:label];
        label.textAlignment = UITextAlignmentCenter;
        
        [self.view addSubview:_empty_view];
    }
    
    
}
-(void)initData{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_getMsg withType:GETURL withPam:nil withUrlName:@"getMsg"];
    httpController.delegate = self;
    [httpController onSyncPostJson];
    
}

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    
    NSLog(@"----pass-login%@---",dictemp);
    //返回原来界面
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
        
        if ([urlname isEqualToString:@"getMsg"]) {
            //[USER_DEFAULT setObject:[dictemp objectForKey:@"s_app_id"] forKey:@"s_app_id"];
            NSDictionary *dic=[dictemp objectForKey:@"data"];
            
            if (dic.count>0) {
                
                _message_array=[MessageModel objectArrayWithKeyValuesArray:[dic objectForKey:@"list"]];
                _result_array=_message_array;
                self.tableView = ({
                    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
                    tableView.dataSource = self;
                    tableView.delegate=self;
                    [self.view addSubview:tableView];
                    tableView;
                });
                
                self.tableView.tableFooterView=[[UIView alloc]init];
                self.tableView.tableHeaderView=[[UIView alloc]init];
                
            }
            
            
        }else if([urlname isEqualToString:@"delMsg"]){
            
            //            [self initData];
            NSLog(@"----pass-delFav%@---",dictemp);
            [self showEmptyView];
            ShowMessage(@"删除成功");
            
        }
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

-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    NSLog(@"Index %i", Index);
    
    static NSString *prediStr1 = @"cat_name LIKE '*'";
    
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
            
                prediStr1 = [NSString stringWithFormat:@"status=='%d'", 1];
        }
            break;
        case 2:{
            
                prediStr1 = [NSString stringWithFormat:@"status=='%d'", 0];
            
        }
            break;
            
        default:
            break;
    }
  
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@",prediStr1]];
    
    self.result_array = [self.message_array filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

#pragma mark -  table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.result_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    //    cell.textLabel.text = self.results[indexPath.row];
    MessageModel *message=_result_array[indexPath.item];
    cell.textLabel.text=message.title;
    
    cell.textLabel.numberOfLines=2;
    
    
    //    cell.textLabel.font=[UIFont systemFontOfSize:13];
    cell.textLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:13];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@", message.content];
    cell.detailTextLabel.textColor=[UIColor colorWithWhite:0.7 alpha:1];
    cell.detailTextLabel.font= [UIFont fontWithName:@"Helvetica" size:11];
    [cell.imageView setImageWithURL:[NSURL URLWithString:message.img] placeholderImage:[UIImage imageNamed:@"default_04.png"]];
    
    UILabel *from_user=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, cell.frame.origin.y+10, 30, 20)];
    from_user.text=message.from_user;
    from_user.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];;
    from_user.textColor=[UIColor colorWithWhite:0.9 alpha:1];
    [cell.contentView addSubview:from_user];
    
    
    //红色小角标
    if ([message.status integerValue]==0) {
        UILabel *label_red=[[UILabel alloc] initWithFrame:CGRectMake(cell.textLabel.frame.origin.x+82, cell.textLabel.frame.origin.y+12, 6, 6)];
        label_red.backgroundColor=RGB(255, 13, 94);
        label_red.layer.cornerRadius=3;
        label_red.layer.masksToBounds=YES;
        [cell addSubview:label_red];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    MessageDetail *detailViewController=[[MessageDetail alloc] initWithNibName:@"MessageDetail" bundle:nil];
    detailViewController.message=_result_array[indexPath.item];
    // Push the view controller.
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil  action:nil]];
    [self.navigationController pushViewController:detailViewController animated:YES];
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
    
//    New_Goods *good=_results[indexPath.item];
//    NSString *fav_id=[NSString stringWithFormat:@"%@",good.fav_id];
//    [self deleteFav:fav_id];
//    
//    NSLog(@"----pass-before----%lu---",(unsigned long)_results.count);
//    NSMutableArray *mut=[_results mutableCopy];
//    [mut removeObjectAtIndex:indexPath.item];
//    _results=[mut copy];
//    
//    NSLog(@"----pass-after----%lu---",(unsigned long)_results.count);
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
//    
    //无法同步 执行出错 只好记录 行
    //    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    
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
