//
//  HTSeachViewController.m
//  haitao
//
//  Created by SEM on 15/7/17.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "HTSeachViewController.h"
#import "BAWineShoppingDockTavleView.h"
#import "BARightTableView.h"
#import "BADockCell.h"
#import "Header.h"
#import "BALabel.h"
#import "MenuModel.h"

@interface HTSeachViewController ()<DockTavleViewDelegate,RightTableViewDelegate>{
    UIView *view_bar1;
}
@property (nonatomic ,strong) BAWineShoppingDockTavleView *dockTavleView;

@property (nonatomic ,strong) BARightTableView *rightTableView;

@property (nonatomic ,strong) NSMutableArray *dockArray;

@property (nonatomic ,strong) NSMutableArray *offsArray;

@property (nonatomic ,weak) UILabel *totalPrice;

@property (nonatomic ,weak) BALabel *bottomLabel;

@property (nonatomic ,assign) NSInteger quantityInt;

@property (nonatomic ,strong) NSMutableDictionary *dic;

@property (nonatomic ,strong) NSMutableArray *key;

@property (nonatomic ,weak) UILabel *totalSingular;

@property (nonatomic ,weak) UIImageView *cartImage;
@end

@implementation HTSeachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    menuArr=[[NSMutableArray alloc]init];
    
    UIView *naviView=(UIView*) [self getNavigationBar];
    //CGRectMake(self.view.frame.size.width-50, naviView.frame.size.height+10, 42, 42)
    
    
    BAWineShoppingDockTavleView *dockTavleView =[[BAWineShoppingDockTavleView alloc]initWithFrame:(CGRect){0,naviView.frame.size.height+1,75,kWindowHeight-50}];
    dockTavleView.rowHeight=50;
    dockTavleView.dockDelegate=self;
    dockTavleView.backgroundColor=UIColorRGBA(238, 238, 238, 1);
    [dockTavleView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:dockTavleView];
    _dockTavleView =dockTavleView;
    
    BARightTableView *rightTableView =[[BARightTableView alloc]initWithFrame:(CGRect){75,naviView.frame.size.height+1,kWindowWidth-75,kWindowHeight-50}];
    rightTableView.rowHeight=90;
    rightTableView.rightDelegate=self;
    rightTableView.backgroundColor=UIColorRGBA(238, 238, 238, 1);
    [rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:rightTableView];
    _rightTableView=rightTableView;
    
    
    _dockArray =[NSMutableArray array];
    
 
    _offsArray =[NSMutableArray array];
    for ( int i=0; i<[_dockArray count]; i++) {
        CGPoint point =CGPointMake(0, 0);
        [_offsArray addObject:NSStringFromCGPoint(point)];
    }
    
    
    UIView *bottomView =[[UIView alloc]initWithFrame:(CGRect){0,kWindowHeight-50,kWindowWidth,50}];
    bottomView.backgroundColor=UIColorRGBA(29, 29, 29, 1);
    [self.view addSubview:bottomView];
    
    BALabel *bottomLabel =[[BALabel alloc]initWithFrame:(CGRect){kWindowWidth-55-10,50/2-24/2,55,24}];
    bottomLabel.text=@"请选购";
    bottomLabel.textColor=[UIColor whiteColor];
    bottomLabel.textAlignment=NSTextAlignmentCenter;
    bottomLabel.font=Font(13);
    bottomLabel.backgroundColor=[UIColor lightGrayColor];
    bottomLabel.layer.masksToBounds=YES;
    bottomLabel.layer.cornerRadius=6;
    bottomLabel.layer.borderWidth = 1;
    bottomLabel.userInteractionEnabled=NO;
    [bottomLabel addTarget:self action:@selector(bottomLabelClick) forControlEvents:BALabelControlEventTap];
    bottomLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    [bottomView addSubview:bottomLabel];
    _bottomLabel=bottomLabel;
    
    
    
    
    
    UIImageView *cartImage =[[UIImageView alloc]initWithFrame:(CGRect){10,5,40,40}];
    cartImage.image=[UIImage imageNamed:@"Home_Cart.jpg"];
    [bottomView addSubview:cartImage];
    _cartImage=cartImage;
    _quantityInt=0;
    
    UILabel *totalPrice =[[UILabel alloc]initWithFrame:(CGRect){CGRectGetMaxX(cartImage.frame)+20,50/2-16/2,200,16}];
    
    totalPrice.text=@"￥0";
    totalPrice.textColor=[UIColor whiteColor];
    totalPrice.font=Font(16);
    [bottomView addSubview:totalPrice];
    _totalPrice=totalPrice;
    
    UILabel *totalSingular =[[UILabel alloc]initWithFrame:(CGRect){35,5,15,15}];
    totalSingular.text=@"0";
    totalSingular.hidden=YES;
    totalSingular.layer.masksToBounds=YES;
    totalSingular.layer.cornerRadius=7.5;
    totalSingular.textAlignment=NSTextAlignmentCenter;
    totalSingular.backgroundColor=[UIColor redColor];
    totalSingular.textColor=[UIColor whiteColor];
    totalSingular.font=Font(13);
    [bottomView addSubview:totalSingular];
    _totalSingular=totalSingular;
    
    _dic=[NSMutableDictionary dictionary];
    _key=[NSMutableArray array];
    //    UIButton *btn =[[UIButton alloc]initWithFrame:(CGRect){200,300,100,100}];
    //    btn.backgroundColor=[UIColor redColor];
    //    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:btn];
    
    [self getMenuData];
    
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
}
-(void)getMenuData{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    NSString* url =@"http://www.peikua.com/app.php?app.php?m=home&a=app&f=getHomeNav" ;
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:GETURL withUrlName:@"menu"];
    httpController.delegate = self;
    [httpController onSearch];
}

//获取数据
-(void) didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    NSString *s_app_id=[dictemp objectForKey:@"s_app_id"];
    NSString *status=[dictemp objectForKey:@"status"];
    //    if(![status isEqualToString:@"1"]){
    ////        [self showMessage:message];
    ////        return ;
    //    }
    if([urlname isEqualToString:@"menu"]){
        NSArray *arrtemp=[dictemp objectForKey:@"data"];
        if ((NSNull *)arrtemp == [NSNull null]) {
            showMessage(@"暂无数据!");
            //            [self showMessage:@"暂无数据!"];
            return;
            
        }
        for (NSDictionary *employeeDic in arrtemp) {
            MenuModel *menuModel= [MenuModel objectWithKeyValues:employeeDic] ;
            NSArray *arr=menuModel.child;
            NSMutableArray *childList=[[NSMutableArray alloc]init];
            for (NSDictionary *childDic in arr) {
                MenuModel *menuTepm= [MenuModel objectWithKeyValues:childDic] ;
                [childList addObject:menuTepm];
            }
            menuModel.child = childList;
            [menuArr addObject:menuModel];
        }
        [self initTable];
        NSLog(@"");
        //保存数据
        
    }
    
    
}
-(void)initTable{
    for ( int i=0; i<menuArr.count; i++) {
        MenuModel *menu=menuArr[i];
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        
        NSMutableArray *array =[NSMutableArray array];
        
        
        
        for (int j=0; j<7; j++) {
            if (j==0) {
                NSMutableDictionary *dic1 =[NSMutableDictionary dictionary];
                dic1=[@{@"image":@"1.jpg",@"name":@"德国OETTINGER奥丁格大麦啤酒500ml*4罐/组",@"money":@"39",@"OriginalPrice":@"56",@"Quantity":@"0",@"ProductID":@"q",@"Discount":@"7折"} mutableCopy];
                [array addObject:dic1];
            }
            if (j==1) {
                NSMutableDictionary *dic1 =[NSMutableDictionary dictionary];
                dic1=[@{@"image":@"2.jpg",@"name":@"德拉克（Durlacher） 黑啤酒 330ml*6听",@"money":@"40",@"OriginalPrice":@"67",@"Quantity":@"0",@"ProductID":@"w",@"Discount":@"6折"} mutableCopy];
                [array addObject:dic1];
            }
            if (j==2) {
                NSMutableDictionary *dic1 =[NSMutableDictionary dictionary];
                dic1=[@{@"image":@"3.jpg",@"name":@"奥塔利金爵 啤酒500ml*12 匈牙利原装低度进口啤酒酒水饮品",@"money":@"109",@"OriginalPrice":@"218",@"Quantity":@"0",@"ProductID":@"e",@"Discount":@"5折"} mutableCopy];
                [array addObject:dic1];
            }
            if (j==3) {
                NSMutableDictionary *dic1 =[NSMutableDictionary dictionary];
                dic1=[@{@"image":@"4.jpg",@"name":@"德国啤酒 原装进口啤酒 flensburger/弗伦斯堡啤酒 土豪金啤 5L 桶装啤酒",@"money":@"158",@"OriginalPrice":@"226",@"Quantity":@"0",@"ProductID":@"r",@"Discount":@"7折"} mutableCopy];
                [array addObject:dic1];
            }
            if (j==4) {
                NSMutableDictionary *dic1 =[NSMutableDictionary dictionary];
                dic1=[@{@"image":@"5.jpg",@"name":@"青岛啤酒 经典 醇厚 啤酒500ml*12听/箱 国产 整箱",@"money":@"66",@"OriginalPrice":@"110",@"Quantity":@"0",@"ProductID":@"t",@"Discount":@"6折"} mutableCopy];
                [array addObject:dic1];
            }
            if (j==5) {
                NSMutableDictionary *dic1 =[NSMutableDictionary dictionary];
                dic1=[@{@"image":@"6.jpg",@"name":@"京姿 百威罐装330ml*24 啤酒",@"money":@"140",@"OriginalPrice":@"200",@"Quantity":@"0",@"ProductID":@"y",@"Discount":@"7折"} mutableCopy];
                [array addObject:dic1];
            }
            if (j==6) {
                NSMutableDictionary *dic1 =[NSMutableDictionary dictionary];
                dic1=[@{@"image":@"7.jpg",@"name":@"德国OETTINGER奥丁格自然浑浊型小麦啤酒500ml*4罐/组",@"money":@"58",@"OriginalPrice":@"129",@"Quantity":@"0",@"ProductID":@"u",@"Discount":@"4.5折"} mutableCopy];
                [array addObject:dic1];
            }
            
            
        }
        dic =[@{@"dockName":menu.name,@"right":array} mutableCopy];
        [_dockArray addObject:dic];
        
        
        
        
    }
    _dockTavleView.dockArray=_dockArray;
    [_dockTavleView reloadData];
    
}
-(void)bottomLabelClick
{
    UIViewController *vc =[[UIViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)quantity:(NSInteger)quantity money:(NSInteger)money key:(NSString *)key
{
    NSInteger addend  =quantity *money;
    
    [_dic setObject:[NSString stringWithFormat:@"%ld",addend] forKey:key];
    //得到词典中所有KEY值
    NSEnumerator * enumeratorKey = [_dic keyEnumerator];
    //遍历所有KEY的值
    NSInteger total=0;
    NSInteger totalSingularInt=0;
    for (NSObject *object in enumeratorKey) {
        total+=[_dic[object] integerValue];
        if ([_dic[object] integerValue] !=0) {
            totalSingularInt +=1;
            _totalSingular.hidden=NO;
        }
    }
    if (totalSingularInt==0) {
        _totalSingular.hidden=YES;
        _bottomLabel.backgroundColor=[UIColor lightGrayColor];
        _bottomLabel.userInteractionEnabled=NO;
        _bottomLabel.text=@"请选购";
    }else
    {
        _bottomLabel.backgroundColor=[UIColor clearColor];
        _bottomLabel.userInteractionEnabled=YES;
        _bottomLabel.text=@"去结算";
    }
    _totalSingular.text=[NSString stringWithFormat:@"%ld",totalSingularInt];
    _totalPrice.text=[NSString stringWithFormat:@"￥%ld",total];
    
}

-(void)dockClickindexPathRow:(NSMutableArray *)array index:(NSIndexPath *)index indeXPath:(NSIndexPath *)indexPath
{
    [_rightTableView setContentOffset:_rightTableView.contentOffset animated:NO];
    _offsArray[index.row] =NSStringFromCGPoint(_rightTableView.contentOffset);
    _rightTableView.rightArray=array;
    [_rightTableView reloadData];
    CGPoint point=CGPointFromString([_offsArray objectAtIndex:indexPath.row]);
    [_rightTableView setContentOffset:point];
    //    NSLog(@"%@",row);
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
    //    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(65, view_bar1.frame.size.height-44, self.view.frame.size.width-130, 44)];
    ////        title_label.text=@"商品详情";
    //    title_label.font=[UIFont boldSystemFontOfSize:20];
    //    title_label.backgroundColor=[UIColor clearColor];
    //    title_label.textColor =[UIColor whiteColor];
    //    title_label.textAlignment=1;
    //    [view_bar1 addSubview:title_label];
    
    
    
    
    
    return view_bar1;
}

-(void)cartImageClick
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
