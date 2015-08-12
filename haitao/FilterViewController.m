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
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface FilterViewController ()

@end

@implementation FilterViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    return [self initWithNibName:nibNameOrNil bundle:nil andFilterType:FilterViewControllTypeDefault andParameter:@{@"need_cat_index":@"1",@"need_page":@"1"}];
}
/**
 f_cat=12(一级分类),
 s_cat=317(二级分类),
 local=1(国家),
 shop=1(商城),
 brand=1459(品牌),
 ship=1(运输方式),
 min_price:搜索开始价格
 max_price：搜索结束价格
 sort=price_cn-asc(排序), //价格price_cn-asc/desc  ，/销量 order_num，/折扣 discount
 keyword=xxx(关键词),
 need_page＝1(是否需要分页统计)
 p=1(页码)
 per=20(每页多少笔记录 默认20)
 need_cat_index＝1//有需要筛选页面添加
 */
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFilterType:(FilterViewControllerType) type andParameter:(NSDictionary *)parameter{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _filterType=type;
        _inParameter=parameter;
    }
    return self;
}
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
    //右边确定安妮
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(makeSure)];
    [self.navigationItem setRightBarButtonItem:rightItem];
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

    _brand_leftArray=@[@"默认",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    [self.footerView addSubview:_coll];
    
    
    [self initDataWithParameter:_inParameter];
    
    if (_filterType==FilterViewControllTypeCategary) {
        _categoryName.text=_pamCategoryName;
        [_categoryImageView setImageWithURL:[NSURL URLWithString:_categoryImageUrl] placeholderImage:[UIImage imageNamed:@"default_04"]];
    }
}


-(void)initDataWithParameter:(NSDictionary *)parameter{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    NSLog(@"----pass-initDataWithParameter%@---",parameter);
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_getGoodsList withType:POSTURL withPam:parameter withUrlName:@"getGoodsList"];
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

-(void)makeSure{
    NSLog(@"----pass-pass %@---",@"makeSure");
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    NSMutableDictionary *mutarray=[_inParameter mutableCopy];
    if (![MyUtil isEmptyString:_selected_brand]) {
        [mutarray setObject:_selected_brand forKey:@"brand"];
    }
    if (![MyUtil isEmptyString:_selected_categary]) {
        [mutarray setObject:_selected_categary forKey:@"s_cat"];

    }
    if (![MyUtil isEmptyString:_selected_shop]) {
        [mutarray setObject:_selected_shop forKey:@"shop"];
    
    }
    if (![MyUtil isEmptyString:_beginPrice.text]) {
        [mutarray setObject:_beginPrice.text forKey:@"min_price"];

    }
    if (![MyUtil isEmptyString:_endPrice.text]) {
        [mutarray setObject:_endPrice.text forKey:@"max_price"];
    }
    
    if (_directBtn.selected) {
        [mutarray setObject:@"1" forKey:@"ship"];
    }else if(_transportBtn.selected){
        [mutarray setObject:@"2" forKey:@"ship"];
    }
    
    NSLog(@"----pass-_inParameter%@---",[mutarray copy]);
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_getGoodsList withType:POSTURL withPam:[mutarray copy] withUrlName:@"getResultList"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
}


-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.viewWidth.constant=SCREEN_WIDTH;
    if (_filterType!=FilterButtonTypeCategaty) {
        _categoryViewHeight.constant=0;
        _categatyNameHeight.constant=0;
        _categatyImageHeight.constant=0;
        _headLineHeight.constant=0;
        _categoryName.text=@"";
    
    }
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

        }else if ([urlname isEqualToString:@"getResultList"]){
            FilterGoodsModel *listModel=[FilterGoodsModel objectWithKeyValues: [dictemp objectForKey:@"data"]];

            if ([self.delegate respondsToSelector:@selector(getFilterResult:)]) {
                [self.delegate getFilterResult:listModel.list];
                
                [self.navigationController popViewControllerAnimated:YES];

            }
        }

    }

}


#pragma mark - Collapse Click Delegate

// Required Methods
-(int)numberOfCellsForCollapseClick {
    switch (_filterType) {
        case FilterViewControllTypeDefault:
            return 3;
            break;
        default:
            return 2;
            break;
    }
    
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    if (_filterType==FilterViewControllTypeDefault) {
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
    }else if(_filterType==FilterViewControllTypeShop){
        switch (index) {
            case 0:
                return @"分类";
                break;
            case 1:
                return @"品牌";
                break;
            default:
                return @"";
                break;
        }
    }else if(_filterType==FilterViewControllTypeCategary){
        switch (index) {
            case 0:
                return @"商城";
                
                break;

            case 1:
                return @"品牌";
                break;
            default:
                return @"";
                break;
        }
    }else if(_filterType==FilterViewControllTypeBrand){
        switch (index) {
            case 0:
                return @"商城";
                
                break;
            case 1:
                return @"分类";
                break;
            default:
                return @"";
                break;
        }
    }
    return @"";
}
    


-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
   
    
    if (_filterType==FilterViewControllTypeDefault) {
        
        switch (index) {
            case 0:
            {
                _shopsView =[[FilterViewForButtons alloc] initWithBtnArray:_shops andType:FilterButtonTypeShop];
                _shopsView.delegate=self;
                [_shopsView loadShopsButtons];
                return _shopsView;
                break;
            }
            case 1:
            {
                _categatiesView =[[FilterViewForButtons alloc] initWithBtnArray:_categaties andType:FilterButtonTypeCategaty];
                _categatiesView.delegate=self;
                [_categatiesView loadCategoriesButtons];
                return _categatiesView;
                break;
            }
            case 2:
            {
                
                _brandTableView=[[FilterBrandTabelView alloc] initWithLeftArray:_brand_leftArray andRightArray: _brand_rightArray];
                _brandTableView.delegate=self;
                _brandTableView.leftTableHeight=30;
                _brandTableView.leftTableWidth=30;
                _brandTableView.rightTableHeight=50;
                _brandTableView.rightTableWidth=SCREEN_WIDTH-30;
                [_brandTableView loadView];
                return _brandTableView;
                break;
            }
                
            default:
                break;
                
        }
        
    }else if(_filterType==FilterViewControllTypeShop){
        
        switch (index) {
            case 0:
            {
                _categatiesView =[[FilterViewForButtons alloc] initWithBtnArray:_categaties andType:FilterButtonTypeCategaty];
                _categatiesView.delegate=self;
                [_categatiesView loadCategoriesButtons];
                return _categatiesView;
                break;
            }
            case 1:
            {
                
                _brandTableView=[[FilterBrandTabelView alloc] initWithLeftArray:_brand_leftArray andRightArray: _brand_rightArray];
                _brandTableView.delegate=self;
                _brandTableView.leftTableHeight=30;
                _brandTableView.leftTableWidth=30;
                _brandTableView.rightTableHeight=50;
                _brandTableView.rightTableWidth=SCREEN_WIDTH-30;
                [_brandTableView loadView];
                return _brandTableView;
                break;
            }
                
            default:
                break;
                
        }
        
    }else if(_filterType==FilterViewControllTypeCategary){
        
        switch (index) {
            case 0:
            {
                _shopsView =[[FilterViewForButtons alloc] initWithBtnArray:_shops andType:FilterButtonTypeShop];
                _shopsView.delegate=self;
                [_shopsView loadShopsButtons];
                return _shopsView;
                break;
            }
            case 1:
            {
                
                _brandTableView=[[FilterBrandTabelView alloc] initWithLeftArray:_brand_leftArray andRightArray: _brand_rightArray];
                _brandTableView.delegate=self;
                _brandTableView.leftTableHeight=30;
                _brandTableView.leftTableWidth=30;
                _brandTableView.rightTableHeight=50;
                _brandTableView.rightTableWidth=SCREEN_WIDTH-30;
                [_brandTableView loadView];
                return _brandTableView;
                break;
            }
                
            default:
                break;
                
        }
        
    }else if(_filterType==FilterViewControllTypeBrand){
        
        switch (index) {
            case 0:
            {
                _shopsView =[[FilterViewForButtons alloc] initWithBtnArray:_shops andType:FilterButtonTypeShop];
                _shopsView.delegate=self;
                [_shopsView loadShopsButtons];
                return _shopsView;
                break;
            }
            case 1:
            {
                _categatiesView =[[FilterViewForButtons alloc] initWithBtnArray:_categaties andType:FilterButtonTypeCategaty];
                _categatiesView.delegate=self;
                [_categatiesView loadCategoriesButtons];
                return _categatiesView;
                break;
            }
            default:
                break;
                
        }
        
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
        if (_filterType==FilterViewControllTypeDefault) {
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
        }else if(_filterType==FilterViewControllTypeShop){
            switch (index) {
                case 0:
                {
                    _collHeightTotal+=_categatiesView.frame.size.height;
                    
                }
                    break;
                case 1:
                    _collHeightTotal+=_brandTableView.frame.size.height;
                default:
                break;                    }
        }else if(_filterType==FilterViewControllTypeCategary){
            switch (index) {
                    
                case 0:
                {
                    _collHeightTotal+=_shopsView.frame.size.height;
                    
                }
                    break;
                case 1:
                    _collHeightTotal+=_brandTableView.frame.size.height;
                default:
                    break;
            }
        }else if(_filterType==FilterViewControllTypeBrand){
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
                default:
                    break;
            }
        }
        

    }else{
        if (_filterType==FilterViewControllTypeDefault) {
            switch (index) {
                    
                case 0:
                {
                    _collHeightTotal-=_shopsView.frame.size.height;
                    
                }
                    break;
                case 1:
                {
                    _collHeightTotal-=_categatiesView.frame.size.height;
                    
                }
                    break;
                case 2:
                    _collHeightTotal-=_brandTableView.frame.size.height;
                default:
                    break;
            }
        }else if(_filterType==FilterViewControllTypeShop){
            switch (index) {
                case 0:
                {
                    _collHeightTotal-=_categatiesView.frame.size.height;
                    
                }
                    break;
                case 1:
                    _collHeightTotal-=_brandTableView.frame.size.height;
                default:
                break;                    }
        }else if(_filterType==FilterViewControllTypeCategary){
            switch (index) {
                    
                case 0:
                {
                    _collHeightTotal-=_shopsView.frame.size.height;
                    
                }
                    break;
                case 1:
                    _collHeightTotal-=_brandTableView.frame.size.height;
                default:
                    break;
            }
        }else if(_filterType==FilterViewControllTypeBrand){
            switch (index) {
                    
                case 0:
                {
                    _collHeightTotal-=_shopsView.frame.size.height;
                    
                }
                    break;
                case 1:
                {
                    _collHeightTotal-=_categatiesView.frame.size.height;
                    
                }
                    break;
                default:
                    break;
            }

        
        }

    }
    NSLog(@"----pass-_collHeight%f---",_collHeightTotal);
     _coll.frame=CGRectMake(_coll.frame.origin.x, _coll.frame.origin.y, SCREEN_WIDTH, _collHeightTotal+3*_coll.cellHeight+20);
    [self updateViewConstraints];
    
}



-(void)buttonClickForBrand:(IndexModel *)indexModel{
    NSLog(@"----pass-pass%@--%@-",@"buttonClickForBrand",indexModel.name);
    _selected_brand=indexModel.id;
}

-(void)buttonClickForShopOrCategary:(IndexModel *)indexModel andType:(FilterButtonType) type{
    NSLog(@"----pass-pass%@--%@-",@"buttonClickForShopOrCategary",indexModel.name);
    if (type==FilterButtonTypeCategaty) {
        _selected_categary=indexModel.id;
    }else{
        _selected_shop=indexModel.id;
    }
}

- (IBAction)btnClick:(id)sender {
    UIButton *button=(UIButton *)sender;
    if ([button isEqual:_transportBtn]) {
        _transportBtn.selected=YES;
        _transportBtn.backgroundColor=RGB(255, 13, 94);
        [_transportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _directBtn.selected=NO;
        _directBtn.backgroundColor=RGB(237, 237, 237);
        [_directBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        
    }else if([button isEqual:_directBtn]){
        _directBtn.selected=YES;
        _directBtn.backgroundColor=RGB(255, 13, 94);
        [_directBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        _transportBtn.selected=NO;
        _transportBtn.backgroundColor=RGB(237, 237, 237);
        [_transportBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];

    }
}

- (IBAction)didEndOnExit:(id)sender {
    [sender resignFirstResponder];
}
@end
