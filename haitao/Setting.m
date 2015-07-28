//
//  Setting.m
//  haitao
//
//  Created by pwy on 15/7/28.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "Setting.h"
#import "AboutPeiKua.h"
#import "ServiceTerms.h"
#import "ConnetPeiKua.h"
@interface Setting ()

@end

@implementation Setting

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _data=@[@"给个评价",@"清除缓存",@"联系配夸网",@"关于配夸网",@"服务条款",@"意见反馈"];
    
    
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
    self.title=@"个人设置";
    
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    
    self.tableView.backgroundColor=RGB(237, 237, 237);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//无分割线
    
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
   
    
//    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cell.frame.size.height-10)];
//    label.backgroundColor=[UIColor whiteColor];
//    //清除cell背景颜色 在底部添加白色背景label 高度小于cell 使之看起来有间隔
//    cell.backgroundColor=[UIColor clearColor];
//    cell.contentView.backgroundColor=[UIColor clearColor];
//    
//    [cell.contentView insertSubview:label atIndex:0];
//    
//    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 3, SCREEN_WIDTH, 30)];
//    titleLabel.font=[UIFont systemFontOfSize:13.0];
//    titleLabel.text=_data[indexPath.item];
//    [cell.contentView addSubview:titleLabel];
    
    cell.textLabel.text=_data[indexPath.item];
    cell.imageView.image=[UIImage imageNamed:@"ic_03_h.png"];
    
    CALayer *layerShadow=[[CALayer alloc]init];
    layerShadow.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y-3, cell.frame.size.width, 3);
//    layerShadow.borderColor=[RGB(237, 223, 223) CGColor];
//    layerShadow.borderWidth=1;
    layerShadow.backgroundColor=[RGB(237, 237, 237) CGColor];
    [cell.layer addSublayer:layerShadow];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    UIViewController *detailViewController;
    

    
    if (indexPath.item==2) {
        detailViewController=[[ConnetPeiKua alloc] initWithNibName:@"ConnetPeiKua" bundle:nil];
    }else if (indexPath.item==3){
        detailViewController=[[AboutPeiKua alloc] initWithNibName:@"AboutPeiKua" bundle:nil];
    }else if (indexPath.item==4){
    
        detailViewController=[[ServiceTerms alloc] initWithNibName:@"ServiceTerms" bundle:nil];
    }
    
    
    // Push the view controller.
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil  action:nil]];
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

@end
