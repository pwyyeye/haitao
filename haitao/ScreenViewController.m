//
//  ScreenViewController.m
//  haitao
//
//  Created by SEM on 15/7/26.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//
#define NUMBERS @"0123456789."
#import "ScreenViewController.h"

@interface ScreenViewController ()
{
    UITableView                 *_tableView;
    UrlImageView *imageV;
    UIView *view_bar1;
    UIButton*btnItem1; //上部五个按钮
    UIButton*btnItem2;
    UIButton*btnItem3;
    UIButton*btnItem4;
    UIButton*btnItem5;
    UIImageView*  tabBarArrow;//上部桔红线条
    UITextField *fromPriceText;//价格
    UITextField *toPriceText;
    UIButton*zhiyouBtn;
    UIButton*zhuanyunBtn;
}

@end

@implementation ScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *naviView=(UIView*) [self getNavigationBar];
    _tableView =[[UITableView alloc]initWithFrame:(CGRect){0,naviView.frame.size.height,self.view.frame.size.width,kWindowHeight-naviView.frame.size.height} style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorColor=[UIColor clearColor];

    //    _tableView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:_tableView];

    // Do any additional setup after loading the view.
}
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return 1;
        //    return spcList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.showArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *titel=self.showArr[section];
    
    UIView * uiview = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 35)] ;
    uiview.backgroundColor=[UIColor whiteColor];
    UILabel *_label=[[UILabel alloc]initWithFrame:CGRectMake(30, 2, 140, 30)];
    _label.text=titel;
    _label.font=[UIFont boldSystemFontOfSize:20];
    _label.backgroundColor=[UIColor clearColor];
    _label.textColor =[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
    _label.numberOfLines=2;
    _label.textAlignment=0;
    if([titel isEqualToString:@"内容"]){
       _label.font=[UIFont boldSystemFontOfSize:25];
        _label.text = @"紧肤霜";
    }
    [uiview addSubview:_label];
    return uiview;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString *titel=self.showArr[indexPath.section];
    // NSArray *arr=@[@"内容",@"价格",@"配送",@"商城",@"品牌"];
    if([titel isEqualToString:@"内容"]){
        static NSString *contet_cell = @"content_cell";
        
        UITableViewCell *cell =nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contet_cell] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
            cell.backgroundColor=[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
        }
        
        return cell;
    }else if([titel isEqualToString:@"价格"]){
        static NSString *price_cell = @"price_cell";
        
        UITableViewCell *cell =nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:price_cell] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
            cell.backgroundColor=[UIColor whiteColor];
        }
        fromPriceText =[[UITextField alloc]initWithFrame:CGRectMake(30, 2, 100, 40)];
        [fromPriceText setBorderStyle:UITextBorderStyleRoundedRect];
        fromPriceText.delegate=self;
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(135, 21, 20, 3)];
        imageView.backgroundColor=[UIColor blackColor];
        toPriceText=[[UITextField alloc]initWithFrame:CGRectMake(160, 2, 100, 40)];
        [toPriceText setBorderStyle:UITextBorderStyleRoundedRect];
        toPriceText.delegate=self;
        [cell addSubview:fromPriceText];
        [cell addSubview:imageView];
        [cell addSubview:toPriceText];
        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(0, 0);
        cellFrame.size.width=self.view.frame.size.width;
        cellFrame.size.height=44;
        [cell setFrame:cellFrame];
        return cell;
    
    }else if([titel isEqualToString:@"配送"]){
        static NSString *sent_cell = @"sent_cell";
        
        UITableViewCell *cell =nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sent_cell] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
            cell.backgroundColor=[UIColor whiteColor];
        }
        zhiyouBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        zhiyouBtn.frame=CGRectMake(30, 2, 100, 40);
        [zhiyouBtn setTitle:@"直邮" forState:UIControlStateNormal];
        [zhiyouBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [zhiyouBtn setBackgroundColor:[UIColor grayColor]];
        
        zhuanyunBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        zhuanyunBtn.frame=CGRectMake(160, 2, 100, 40);
        [zhuanyunBtn setTitle:@"转运" forState:UIControlStateNormal];
        [zhuanyunBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [zhuanyunBtn setBackgroundColor:[UIColor grayColor]];
        [cell addSubview:zhiyouBtn];
        [cell addSubview:zhuanyunBtn];
        return cell;
        
    }else if([titel isEqualToString:@"商城"]){
        static NSString *shop_cell = @"shop_cell";
        
        UITableViewCell *cell =nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shop_cell] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
            cell.backgroundColor=[UIColor whiteColor];
        }
        return cell;
        
    }else if([titel isEqualToString:@"品牌"]){
        static NSString *brand_cell = @"brand_cell";
        
        UITableViewCell *cell =nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:brand_cell] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
            cell.backgroundColor=[UIColor whiteColor];
        }
        return cell;
        
    }


    return  nil;
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titel=self.showArr[indexPath.section];
    if([titel isEqualToString:@"内容"]){
        return 20;
    }
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    
    //    TMThirdClassViewController *goods=[[TMThirdClassViewController alloc]init];
    //
    //    [delegate.navigationController pushViewController:goods animated:YES];
}
-(UIView*)getNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    view_bar1 =[[UIView alloc]init];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>6.1)
    {
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width, 44+20);
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 44+20)];
        imageV.image = BundleImage(@"top.png");
        [view_bar1 addSubview:imageV];
        
        
    }else{
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width,44);
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,44)];
        imageV.image = BundleImage(@"top.png");
        [view_bar1 addSubview:imageV];
        
    }
    view_bar1.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:view_bar1];
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(65, view_bar1.frame.size.height-44, self.view.frame.size.width-130, 44)];
    title_label.text=@"筛选";
    title_label.font=[UIFont boldSystemFontOfSize:20];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =[UIColor whiteColor];
    title_label.textAlignment=1;
    [view_bar1 addSubview:title_label];
        
    UIButton*btnBack=[UIButton buttonWithType:0];
    btnBack.frame=CGRectMake(0, view_bar1.frame.size.height-34, 47, 34);
    [btnBack setImage:BundleImage(@"left_grey") forState:0];
    [btnBack addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [view_bar1 addSubview:btnBack];

    
    
    return view_bar1;
}
#pragma mark退出
-(void)btnBack:(id)sender
{
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//要实现的Delegate方法,关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSCharacterSet*cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"请输入数字"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        
        [alert show];
        return NO;
        
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
