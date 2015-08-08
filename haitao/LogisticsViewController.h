//
//  LogisticsViewController.h
//  haitao
//
//  Created by pwy on 15/8/7.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageDetail.h"
@interface LogisticsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
//物流方式
@property (weak, nonatomic) IBOutlet UILabel *shipType;
//物流单号
@property (weak, nonatomic) IBOutlet UILabel *shipNumber;
//物流状态
@property (weak, nonatomic) IBOutlet UILabel *shipStatus;

@property (weak, nonatomic) IBOutlet UITableView *goodsTable;

@property (weak, nonatomic) IBOutlet UITableView *logisticsTable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;

@property(strong,nonatomic) PackageDetail *packageModel;
@end
