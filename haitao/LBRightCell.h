//
//  LBRightCell.h
//  haitao
//
//  Created by SEM on 15/8/5.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexModel.h"
@interface LBRightCell : UITableViewCell
@property (nonatomic ,strong) IndexModel *rightData;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex ,NSInteger money ,NSString *key);

@end
