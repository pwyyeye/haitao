//
//  Setting.h
//  haitao
//
//  Created by pwy on 15/7/28.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Setting : UITableViewController<HTTPControllerProtocol>
@property(strong,nonatomic) NSArray *data;

@end