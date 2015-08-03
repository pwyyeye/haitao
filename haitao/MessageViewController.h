//
//  MessageViewController.h
//  haitao
//
//  Created by pwy on 15/8/1.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOPDropDownMenu.h"

@interface MessageViewController : UIViewController<HTTPControllerProtocol,DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic) DOPDropDownMenu *menu;

@property(strong,nonatomic) UIView *empty_view;

@property(strong,nonatomic) UITableView *tableView;

@property(strong,nonatomic) NSArray *message_array;

@property(strong,nonatomic) NSArray *result_array;


@end
