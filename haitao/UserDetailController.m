//
//  UserDetailController.m
//  haitao
//
//  Created by pwy on 15/7/19.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "UserDetailController.h"

@interface UserDetailController ()

@end

@implementation UserDetailController

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
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)]];
    
    //返回的颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //navigationBar的标题
    //self.navigationItem.title=@"登录";
    self.title=@"个人信息";
    
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    
    
//    self.view.backgroundColor=RGB(<#r#>, <#g#>, <#b#>);
}
-(void)gotoBack
{
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
//    UIView *view = [UIView new];
//    
//    view.backgroundColor = [UIColor clearColor];
//    
//    [tableView setTableFooterView:view];
//    [tableView setTableHeaderView:view];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"%d",section);
//    if (section==0) {
//        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine ;
//    }else{
//        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    }
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 10, 60, 30)];
    label.font=[UIFont systemFontOfSize:11.0];
    
    if (indexPath.item==0) {
        label.text=@"修改头像";
        cell.imageView.image=[UIImage imageNamed:@"default_04.png"];
        
    }else{
        cell.textLabel.text=@"xxxxx";
        label.text=@"修改昵称";
    }
    [cell.contentView addSubview:label];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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

@end
