//
//  ScreenViewController.h
//  haitao
//
//  Created by SEM on 15/7/26.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//
#define kWindowHeight                       ([[UIScreen mainScreen] bounds].size.height)
#import "LTKViewController.h"

@interface ScreenViewController : LTKViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,retain)NSDictionary *indexDic;//显示的条件
@end
