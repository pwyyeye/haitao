//
//  AddressListController.m
//  haitao
//
//  Created by pwy on 15/7/19.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "AddressListController.h"
#import "AddressListCell.h"
#import "AddAddressStep1.h"
#import "AddressModel.h"
#import "LoginViewController.h"
#import "UpdateAddress.h"


@interface AddressListController ()

@end

@implementation AddressListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //是否显示navigationBar
    [self.navigationController setNavigationBarHidden:NO];
    //navigationBar 背景色
    self.navigationController.navigationBar.barTintColor=RGB(255, 13, 94);
    //若为yesnavigationBar背景 会有50％的透明
    self.navigationController.navigationBar.translucent = NO;
    
    //返回值
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(gotoBack)];
//    
    //返回的颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //navigationBar的标题
    //self.navigationItem.title=@"登录";
    self.title=@"管理收获地址";
    
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    
    
    
    
    UINib *nib=[UINib nibWithNibName:@"AddressListCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"addressListCell"];
    
//    _data=@[@"hello",@"word"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:@"noticeToReload" object:nil];
    
    [self initData];
    self.tableView.backgroundColor=RGB(237, 237, 237);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//无分割线
    self.tableView.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-40-64);

}
-(void)gotoBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];

    
}
-(void)initData{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    NSLog(@"----pass-app%@---",app.s_app_id);
    _selfRequestURL=[NSString stringWithFormat:@"%@&f=getAddress&m=user",requestUrl];

    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_getAddress withType:POSTURL withUrlName:@"addressList"];
    
    
    
    httpController.delegate = self;
    [httpController onSearch];
    

}

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    if ([urlname isEqual:@"addressList"]) {
        if ([[dictemp objectForKey:@"status"] integerValue] ==1) {
            NSArray *list=[dictemp objectForKey:@"data"];
            
//            NSMutableArray *marray=[[NSMutableArray alloc] init];
//            for (NSDictionary *obj in list) {
//                AddressModel *model=[AddressModel objectWithKeyValues:obj];
//                [marray addObject:model];
//            }
//            _data=[marray copy];
            _data=[[AddressModel objectArrayWithKeyValuesArray:list] copy];
            [self reloadData];
        }else{
            id array=[dictemp objectForKey:@"msg"];
            if ([array isKindOfClass:[NSString class]]) {
                ShowMessage(array);
            }else if([array isKindOfClass:[NSArray class]]){
                ShowMessage([array objectAtIndex:0]);
            }
            ShowMessage([array objectAtIndex:0]);
        }

    }
    

}

-(void)reloadData{
    if (_data.count==0) {
        if (_emptyView==nil) {
            _emptyView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
            UILabel *emptyLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80, SCREEN_HEIGHT/2-45, 160, 30)];
            emptyLabel.font=[UIFont systemFontOfSize:12.0];
            emptyLabel.text=@"暂无收获人地址，请添加创建";
            
            UIButton *emptyButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
            emptyButton.backgroundColor=[UIColor whiteColor];
            emptyButton.titleLabel.font=[UIFont systemFontOfSize:13.0];
            [emptyButton setTitleColor:RGB(255, 13, 94) forState:UIControlStateNormal];
            [emptyButton setTitle:@"+添加收货人地址" forState:UIControlStateNormal];
            // [emptyButton setTintColor:[UIColor redColor]];
            
            [emptyButton addTarget:self action:@selector(gotoAddAddress) forControlEvents:UIControlEventTouchUpInside];
            [_emptyView addSubview:emptyLabel];
            [_emptyView addSubview:emptyButton];
            
            [self.view addSubview:_emptyView];
            
            self.tableView.separatorColor=[UIColor clearColor];
            
        }
        
    }else{
        
        [_emptyView removeFromSuperview];
        //添加新增地址按钮
        
        UIButton *nextButton=[[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40-64, SCREEN_WIDTH, 40)];
        nextButton.backgroundColor=RGB(255, 13, 94);
        
        [nextButton setTitle:@"+添加收货人地址" forState:UIControlStateNormal];
        nextButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [nextButton addTarget:self action:@selector(gotoAddAddress) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nextButton];
        [self.tableView reloadData];
        
    }

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noticeToReload" object:nil];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressListCell" forIndexPath:indexPath];
    AddressModel *model=_data[indexPath.item];
    cell.username.text=model.consignee;
//    cell.textLabel.text=@"12312312312312321313";
//    cell.detailTextLabel.text=@"sdfasdfadsfasdfasfasdfsadfasfasdfasd";
    
    NSString *address=[NSString stringWithFormat:@"%@%@",model.province,model.address];
    cell.address.text=address;
    cell.telephone.text=model.mobile;
    if([model.is_default integerValue]==1){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }

    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    UpdateAddress *detailViewController=[[UpdateAddress alloc] initWithNibName:@"UpdateAddress" bundle:nil];
    detailViewController.addressModel=_data[indexPath.item];
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - custom Methods

-(void)gotoAddAddress{
    
    NSLog(@"----pass gotoAddAddress%@---",@"test");
    
    UIViewController *detailViewController =[[AddAddressStep1 alloc] initWithNibName:@"AddAddressStep1" bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil  action:nil]];
//    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
