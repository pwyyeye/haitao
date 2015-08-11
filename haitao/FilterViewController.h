//
//  FilterViewController.h
//  haitao
//
//  Created by pwy on 15/8/11.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollapseClick.h"
#import "FilterViewForButtons.h"
#import "FilterBrandTabelView.h"
@interface FilterViewController : UIViewController<HTTPControllerProtocol, UITableViewDataSource,UITableViewDelegate,CollapseClickDelegate>
//分类三选项
@property (weak, nonatomic) IBOutlet UIView *categoryView;

@property (weak, nonatomic) IBOutlet UILabel *categoryName;

@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;

//开始价格
@property (weak, nonatomic) IBOutlet UITextField *beginPrice;
//结束价格
@property (weak, nonatomic) IBOutlet UITextField *endPrice;
//直邮
@property (weak, nonatomic) IBOutlet UIButton *directBtn;
//转运
@property (weak, nonatomic) IBOutlet UIButton *transportBtn;

@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UILabel *hengxian;

//约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hengxianHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryViewHeight;

//其他
//下来伸缩
@property(strong,nonatomic) CollapseClick *coll;

//商城
@property(strong,nonatomic) FilterViewForButtons *shopsView;
//类别
@property(strong,nonatomic) FilterViewForButtons *categatiesView;
//商城数组
@property(strong,nonatomic) NSArray *shops;

//类别数组
@property(strong,nonatomic) NSArray *categaties;
//动态计算下拉高度
@property(assign,nonatomic) float collHeightTotal;

//左边A～Z数组
@property(strong,nonatomic) NSArray *brand_leftArray;

@property(strong,nonatomic) NSArray *brand_rightArray;

@property(strong,nonatomic) FilterBrandTabelView *brandTableView;




@end