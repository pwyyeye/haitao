//
//  FilterViewController.m
//  haitao
//
//  Created by pwy on 15/8/11.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterGoodsModel.h"
#import "Cat_indexModel.h"
#import "IndexModel.h"
@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //是否显示navigationBar
    [self.navigationController setNavigationBarHidden:NO];
    //navigationBar 背景色
    self.navigationController.navigationBar.barTintColor=RGB(255, 13, 94);
    //若为yesnavigationBar背景 会有50％的透明
    self.navigationController.navigationBar.translucent = NO;
    
    //返回的颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //navigationBar的标题
    //self.navigationItem.title=@"登录";
    self.title=@"筛选";
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    
    _hengxian.height=0.5;
    _hengxian.backgroundColor=RGB(179, 179, 179);
    
    _coll=[[CollapseClick alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    _coll.CollapseClickDelegate = self;
    _coll.cellSpace=0;
    _coll.cellHeight=40;
    _coll.scrollEnabled=NO;

    
    [self.footerView addSubview:_coll];
    
    [self initData];
    
 _brand_leftArray=@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
}


-(void)initData{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_getGoodsList withType:POSTURL withPam:@{@"need_cat_index":@"1",@"need_page":@"1"} withUrlName:@"getGoodsList"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)gotoBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.viewWidth.constant=SCREEN_WIDTH;
    //tableView的高度时header＋footer＋cell高度*cell个数

    //自身高度
    self.viewHeight.constant=self.footerView.frame.origin.y+self.shopsView.frame.size.height+_coll.frame.size.height+200;
    
    _hengxianHeight.constant=0.5;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - http Delegate
-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
                
        if ([urlname isEqualToString:@"getGoodsList"]) {
            FilterGoodsModel *listModel=[FilterGoodsModel objectWithKeyValues: [dictemp objectForKey:@"data"]];
            _shops=listModel.cat_index.shop_row;
            _categaties=listModel.cat_index.cat_row;
            _brand_rightArray=listModel.cat_index.brand_row;
            
            
            [_coll reloadCollapseClick];
//            _coll.frame=CGRectMake(_coll.frame.origin.x, _coll.frame.origin.y, SCREEN_WIDTH, _shopsView.frame.size.height+3*_coll.cellHeight+20);
//            [_coll openCollapseClickCellAtIndex:0 animated:YES];

        }

    }

}


#pragma mark - Collapse Click Delegate

// Required Methods
-(int)numberOfCellsForCollapseClick {
    return 3;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    switch (index) {
        case 0:
            return @"商城";
            break;
        case 1:
            return @"分类";
            break;
        case 2:
            return @"品牌";
            break;
        default:
            return @"";
            break;
    }
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    
    switch (index) {
        case 0:
        {
            _shopsView =[[FilterViewForButtons alloc] initWithBtnArray:_shops andType:FilterButtonTypeShop];
            [_shopsView loadShopsButtons];
            return _shopsView;
            break;
        }
        case 1:
        {
            _categatiesView =[[FilterViewForButtons alloc] initWithBtnArray:_categaties andType:FilterButtonTypeCategaty];
            [_categatiesView loadCategoriesButtons];
            return _categatiesView;
            break;
        }
        case 2:
        {
            _brandTableView=[[FilterBrandTabelView alloc] initWithLeftArray:_brand_leftArray andRightArray:_brand_rightArray];
            _brandTableView.leftTableHeight=30;
            _brandTableView.leftTableWidth=30;
            _brandTableView.rightTableHeight=50;
            _brandTableView.rightTableWidth=50;
            [_brandTableView loadView];
            return _brandTableView;
            break;
        }
            
        default:
            break;
            
    }
    
    return nil;
}


// Optional Methods

-(UIColor *)colorForCollapseClickTitleViewAtIndex:(int)index {
    return [UIColor whiteColor];
}


-(UIColor *)colorForTitleLabelAtIndex:(int)index {
    return RGB(51, 51, 51);
}

-(UIColor *)colorForTitleArrowAtIndex:(int)index {
    return RGB(255, 13, 94);
}

-(void)didClickCollapseClickCellAtIndex:(int)index isNowOpen:(BOOL)open {
    NSLog(@"%d and it's open:%@", index, (open ? @"YES" : @"NO"));
    if (open) {
        switch (index) {
            case 0:
            {
                _collHeightTotal+=_shopsView.frame.size.height;
               
            }
                break;
            case 1:
            {
                 _collHeightTotal+=_categatiesView.frame.size.height;

            }
                break;
            case 2:
                _collHeightTotal+=_brandTableView.frame.size.height;
            default:
                break;
        }
    }else{
        switch (index) {
            case 0:
                _collHeightTotal-=_shopsView.frame.size.height;
                break;
            case 1:
                _collHeightTotal-=_categatiesView.frame.size.height;
                break;
            case 2:
                _collHeightTotal-=_brandTableView.frame.size.height;
                break;
            default:
                break;
        }
    }
     _coll.frame=CGRectMake(_coll.frame.origin.x, _coll.frame.origin.y, SCREEN_WIDTH, _collHeightTotal+3*_coll.cellHeight+20);
    [self updateViewConstraints];
    
}


@end
