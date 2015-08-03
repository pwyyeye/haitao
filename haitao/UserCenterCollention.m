//
//  UserCenterCollention.m
//  haitao
//
//  Created by pwy on 15/7/24.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "UserCenterCollention.h"
#import "UserCenterCollectionCell.h"
#import "UserDetailController.h"
#import "AddressListController.h"
#import "UserCenterHeader.h"
#import "LoginViewController.h"
#import "FCTabBarController.h"
#import "FavoriteViewController.h"
#import "HelpViewController.h"
#import "MessageViewController.h"
#import "CouponListController.h"
#import "TariffViewController.h"
#import "OrderListController.h"
@interface UserCenterCollention ()

@end

@implementation UserCenterCollention

static NSString * const reuseIdentifier = @"userCenterCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UserCenterCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[UserCenterHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"userCenterHeader"];
    
    
    
    _tableList=@[@"我的订单",@"消息中心",@"优惠券",@"关税缴纳",@"地址管理",@"收藏",@"分享app",@"帮助说明",@"在线客服"];
    
    self.collectionView.backgroundColor=[UIColor whiteColor];
    //self.collectionView.frame=CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT);
//    self.title=@"用户中心";
    
    
    //设置电池状态栏前景色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    //设置电池状态栏前景色
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor=RGB(255, 13, 94);
    [self.view addSubview:view];
    
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"noticeToReload" object:nil];

}
-(void)reloadData{
    [self.collectionView reloadData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    //判断是否登录
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([MyUtil isEmptyString:app.s_app_id]){
        UIViewController *vc=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [app.navigationController pushViewController:vc animated:YES];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UserCenterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    cell.content.text=_tableList[indexPath.item];
    
    cell.content.textColor=RGB(51, 51, 51);
    cell.layer.borderColor=[[UIColor clearColor] CGColor];
    switch (indexPath.item) {
        case 0:
            cell.imageView.image=[UIImage imageNamed:@"userCenter_inco_order"];
            break;
        case 1:
            cell.imageView.image=[UIImage imageNamed:@"userCenter_inco_bell"];
            break;
        case 2:
            cell.imageView.image=[UIImage imageNamed:@"userCenter_inco_youhuiquan"];
            break;
        case 3:
            cell.imageView.image=[UIImage imageNamed:@"userCenter_inco_Offer"];
            break;
        case 4:
            cell.imageView.image=[UIImage imageNamed:@"userCenter_inco_Location"];
            break;
        case 5:
            cell.imageView.image=[UIImage imageNamed:@"userCenter_inco_Love"];
            break;
        case 6:
            cell.imageView.image=[UIImage imageNamed:@"userCenter_inco_Share"];
            break;
        case 7:
            cell.imageView.image=[UIImage imageNamed:@"userCenter_inco_help"];
            break;
        case 8:
            cell.imageView.image=[UIImage imageNamed:@"userCenter_inco_connect"];
            break;
            
        default:
            break;
    }
    
    //重置之前的layer
    if (cell.layer.sublayers.count>1) {
        CALayer *restLayer=cell.layer.sublayers.lastObject;
        //        restLayer.frame=CGRectZero;
        
        [restLayer removeFromSuperlayer];
    }


    if (indexPath.item==0||indexPath.item==1||indexPath.item==3||indexPath.item==4) {//9宫格 1 2 4 5格子 右、下边线
        CALayer *layerShadow=[[CALayer alloc]init];
        layerShadow.frame=CGRectMake(-1, -1, cell.frame.size.width+1, cell.frame.size.height+1);
        layerShadow.borderColor=[RGB(237, 223, 223) CGColor];
        layerShadow.borderWidth=1;
        [cell.layer addSublayer:layerShadow];
    }if (indexPath.item==2||indexPath.item==5) {//9宫格 3 6格子下边线
        
        CALayer *layerShadow=[[CALayer alloc]init];
        layerShadow.frame=CGRectMake(0, cell.frame.size.height-1,  cell.frame.size.width,1);
        layerShadow.borderColor=[RGB(237, 223, 223) CGColor];
        layerShadow.borderWidth=1;
        [cell.layer addSublayer:layerShadow];
        
    }else if (indexPath.item==6||indexPath.item==7){//9宫格 3 6格子右边线
        
        CALayer *layerShadow=[[CALayer alloc]init];
        layerShadow.frame=CGRectMake(cell.frame.size.width-1,0,1,cell.frame.size.height);
        layerShadow.borderColor=[RGB(237, 223, 223) CGColor];
        layerShadow.borderWidth=1;
        [cell.layer addSublayer:layerShadow];
    }
    

    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UserCenterHeader *headerView;
    if (kind==UICollectionElementKindSectionHeader) {
        headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"userCenterHeader" forIndexPath:indexPath];
        //header.user_img.image=[UIImage imageNamed:@""];
        
        
        if ([MyUtil isEmptyString:[USER_DEFAULT objectForKey:@"user_nick"]]) {
            headerView.user_name.text=[USER_DEFAULT objectForKey:@"user_name"];
        }else{
            headerView.user_name.text=[USER_DEFAULT objectForKey:@"user_nick"];
        
        }
        headerView.user_img.image=[UIImage imageNamed:@"default_04.png"];
        
        if (![MyUtil isEmptyString:[USER_DEFAULT objectForKey:@"avatar_img"]]) {
            NSURL *url=[NSURL URLWithString:[USER_DEFAULT objectForKey:@"avatar_img"]];
            [headerView.user_img setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_04.png"]];
        }
        
        
    }else if(kind==UICollectionElementKindSectionFooter){
        headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"userCenterFooter" forIndexPath:indexPath];

    }
    
    return headerView;
}
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        CGSize size = {SCREEN_WIDTH, 100};
        return size;
    }
    else
    {
        CGSize size = {320, 50};
        return size;
    }
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 NSLog(@"----pass-collection%@---",@"test");
 
 }
*/


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *detailViewController;
    if (indexPath.item==0) {
        detailViewController  = [[OrderListController alloc] init];
    }else if (indexPath.item==1) {
        detailViewController  = [[MessageViewController alloc] init];
    }else if (indexPath.item==2) {
        detailViewController  = [[CouponListController alloc] init];
    }else if (indexPath.item==3) {
        detailViewController  = [[TariffViewController alloc] init];
    }else if(indexPath.item==4){
        detailViewController  = [[AddressListController alloc] init];
    }else if(indexPath.item==5){
        detailViewController  = [[FavoriteViewController alloc] init];
    }else if(indexPath.item==7){
        detailViewController  = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    }
    
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    
//    [self.navigationController pushViewController:detailViewController animated:YES];
    AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
//    delegate.navigationController.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
    delegate.navigationController.navigationItem.backBarButtonItem=item;
    [delegate.navigationController pushViewController:detailViewController animated:YES];

}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-20)/3, ((SCREEN_WIDTH-20)/3)*1.2);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
   
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

@end
