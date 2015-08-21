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
#import "FilterViewController.h"
@protocol ChangeTableDelegate
- (void)changeFrame;
@end
@interface CFContentViewController : LTKViewController<UITableViewDelegate,UITableViewDataSource,HTTPControllerProtocol,DJRefreshDelegate,FilterViewControllerDelegate>
{
   NSMutableArray *listArr;
    NSString *pageCount;
    NSMutableDictionary *shaixuanDic;
}
@property (nonatomic,retain)NSDictionary *menuIndexDic;
//存储所有筛选条件
@property(strong,nonatomic) NSMutableDictionary *inParameters;
@property (nonatomic,strong)NSMutableArray *dataList;
@property (nonatomic,strong)DJRefresh *refresh;
@property (nonatomic,copy)NSString *topTitle;
@property (nonatomic,copy)NSString *menuid;
@property (nonatomic,weak)id<ChangeTableDelegate>delegate;
@end
