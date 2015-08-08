//
//  OrderListController.h
//  haitao
//
//  Created by pwy on 15/8/2.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order_package.h"
@interface OrderListController : UIViewController<HTTPControllerProtocol, UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(strong,nonatomic) UIView *empty_view;

@property(strong,nonatomic) UITableView *tableView;

@property(strong,nonatomic) UITableView *subTableView;

@property(strong,nonatomic) NSArray *order_array;

@property(strong,nonatomic) NSArray *result_array;

@property(strong,nonatomic) Order_package *package;

@property(strong,nonatomic) NSArray *goods_arrayForSubView;

@property(strong,nonatomic) UISegmentedControl *seg;

@property(strong,nonatomic) NSString *selectedOrderNo;
@end
