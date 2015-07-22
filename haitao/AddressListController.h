//
//  AddressListController.h
//  haitao
//
//  Created by pwy on 15/7/19.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressListController : UITableViewController<HTTPControllerProtocol>

@property(strong,nonatomic) NSArray *data;

@property(strong,nonatomic) UIView *emptyView;

@property(strong,nonatomic) NSString *selfRequestURL;

-(void)initData;

@end
