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


@interface AddressListController ()

@end

@implementation AddressListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UINib *nib=[UINib nibWithNibName:@"AddressListCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"addressListCell"];
    
//    _data=@[@"hello",@"word"];
    
    _selfRequestURL=[NSString stringWithFormat:@"%@&f=getAddress&m=user",requestUrl];
    
    
    
}

-(void)initData{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    NSDictionary *parameters ;
    NSString *s_app_id=[USER_DEFAULT objectForKey:@"s_app_id"];
    if (![MyUtil isEmptyString:s_app_id]) {
        parameters = @{@"s_app_id":s_app_id};
    }else{
        parameters=nil;
    }
   
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:[NSString stringWithFormat:@"%@&f=getAddress&m=user",requestUrl] withType:POSTURL withPam:parameters withUrlName:@"addressList"];
    
    
    
    httpController.delegate = self;
    [httpController onSearch];


}

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    if ([urlname isEqual:@"addressList"]) {
        if ([[dictemp objectForKey:@"status"] integerValue] ==1) {
            NSDictionary *dic=[dictemp objectForKey:@"data"];
            
            NSArray *list=[dic objectForKey:@"list"];
            NSMutableArray *marray=[[NSMutableArray alloc] init];
            for (NSDictionary *obj in list) {
                AddressModel *model=[AddressModel objectWithKeyValues:obj];
                [marray addObject:model];
            }
            _data=[marray copy];
            [self reloadData];
        }else{
            NSArray *array=[dictemp objectForKey:@"msg"];
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
            
            UIButton *emptyButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 40)];
            emptyButton.backgroundColor=[UIColor redColor];
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
        [self.tableView reloadData];
        
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [self initData];

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
    cell.textLabel.text=@"12312312312312321313";
    cell.detailTextLabel.text=@"sdfasdfadsfasdfasfasdfsadfasfasdfasd";
    cell.accessoryType=UITableViewCellAccessoryCheckmark;

    // Configure the cell...
    
    return cell;
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
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
