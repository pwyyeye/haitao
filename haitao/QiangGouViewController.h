//
//  QiangGouViewController.h
//  haitao
//
//  Created by SEM on 15/8/17.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LTKViewController.h"
#import "New_Goods.h"
#import "Goods_Ext.h"
#import "HTGoodDetailsViewController.h"
@interface QiangGouViewController : LTKViewController<UITableViewDelegate,UITableViewDataSource,HTTPControllerProtocol>

@property (nonatomic,retain)NSMutableArray *listArr;
@end
