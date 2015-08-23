//
//  TariffViewController.h
//  haitao
//
//  Created by pwy on 15/8/1.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageDetail.h"
#import "OrderTax.h"
@interface TariffViewController : UIViewController<HTTPControllerProtocol, UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic) UIView *empty_view;

@property(strong,nonatomic) UITableView *tableView;

@property(strong,nonatomic) NSArray *tariff_array;

@property(strong,nonatomic) NSArray *result_array;

@property(strong,nonatomic) OrderTax *orderTax;

@property(strong,nonatomic) PackageDetail *packageDetail;

@property(strong,nonatomic) NSString *selectedOrderNo;

@property(strong,nonatomic) UISegmentedControl *seg;


@end
