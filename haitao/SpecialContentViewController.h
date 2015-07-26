//
//  SpecialContentViewController.h
//  haitao
//
//  Created by SEM on 15/7/25.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LTKViewController.h"
#import "DJRefresh.h"
#import "DJRefreshProgressView.h"
@interface SpecialContentViewController : LTKViewController<UITableViewDelegate,UITableViewDataSource,HTTPControllerProtocol,DJRefreshDelegate>
{
NSMutableArray *listArr;
}
@property (nonatomic,retain)NSDictionary *spcDic;
@property (nonatomic,strong)DJRefresh *refresh;
@end
