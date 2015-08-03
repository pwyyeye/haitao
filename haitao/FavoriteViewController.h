//
//  FavoriteViewController.h
//  haitao
//
//  Created by pwy on 15/7/30.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOPDropDownMenu.h"
@interface FavoriteViewController : UIViewController<HTTPControllerProtocol,DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) NSArray *allData;//所有收藏

@property(strong,nonatomic) NSArray *brand_data;//品牌

@property(strong,nonatomic) NSArray *shop_data;//商城

@property(strong,nonatomic) NSArray *category_data;//类别

@property(strong,nonatomic) NSArray *goodsList;//产品列表

@property(strong,nonatomic) UITableView *tableView;

@property (nonatomic, copy) NSArray *results;//搜索结果集

@property(strong,nonatomic) NSIndexPath *del_indexPath;

@property(strong,nonatomic) DOPDropDownMenu *menu;

@property(strong,nonatomic) UIView *empty_view;



@end
