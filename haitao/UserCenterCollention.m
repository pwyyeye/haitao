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
    [self.navigationController setNavigationBarHidden:YES];
    
    //设置电池状态栏前景色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    //设置电池状态栏前景色
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor=RGB(255, 13, 94);
    [self.view addSubview:view];
    //判断是否登录
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([MyUtil isEmptyString:app.s_app_id]){
        UIViewController *vc=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [app.navigationController pushViewController:vc animated:YES];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    cell.layer.borderColor=[[UIColor clearColor] CGColor];

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
        headerView.user_name.text=@"潘潘潘";
        
        
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
        //detailViewController  = [[UserDetailController alloc] init];
    }else if(indexPath.item==5){
        detailViewController  = [[AddressListController alloc] init];
    }
    
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];


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
