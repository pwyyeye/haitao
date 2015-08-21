//
//  CFContentForDicKeyViewController.h
//  haitao
//
//  Created by SEM on 15/8/12.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LTKViewController.h"
#import "DJRefresh.h"
#import "DJRefreshProgressView.h"
#import "FilterViewController.h"
@interface CFContentForDicKeyViewController : LTKViewController<UITableViewDelegate,UITableViewDataSource,HTTPControllerProtocol,FilterViewControllerDelegate,DJRefreshDelegate>
{
    NSMutableArray *listArr;
    NSString *pageCount;
    NSMutableDictionary *shaixuanDic;
}
//存储所有筛选条件
@property(strong,nonatomic) NSMutableDictionary *inParameters;
@property (nonatomic,retain)NSDictionary *keyDic;
@property (nonatomic,copy)NSString *topTitle;
@property (assign,nonatomic)BOOL isSou;
@property (nonatomic,strong)DJRefresh *refresh;
@end
