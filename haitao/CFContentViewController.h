//
//  CFContentViewController.h
//  haitao
//
//  Created by SEM on 15/7/29.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LTKViewController.h"
#import "DJRefresh.h"
#import "DJRefreshProgressView.h"

@interface CFContentViewController : LTKViewController<UITableViewDelegate,UITableViewDataSource,HTTPControllerProtocol,DJRefreshDelegate>
{
   NSMutableArray *listArr;
}
@property (nonatomic,retain)NSDictionary *menuIndexDic;
@property (nonatomic,strong)NSMutableArray *dataList;
@property (nonatomic,strong)DJRefresh *refresh;
@property (nonatomic,copy)NSString *title;
@end
