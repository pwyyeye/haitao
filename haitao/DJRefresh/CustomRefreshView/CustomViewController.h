//
//  CustomViewController.h
//  haitao
//
//  Created by SEM on 15/7/28.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LTKViewController.h"
#import "DJRefresh.h"
#import "DJRefreshProgressView.h"
#import "CFImageButton.h"
#import "Goods_Ext.h"
#import "CFContentViewController.h"
#import "HTGoodDetailsViewController.h"
#import "ShaiXuanBtn.h"
#import "FilterViewController.h"
@interface CustomViewController : LTKViewController<UITableViewDelegate,UITableViewDataSource,HTTPControllerProtocol,DJRefreshDelegate,ChangeTableDelegate,GoodChangeTableDelegate,FilterViewControllerDelegate>
{
    NSMutableArray *listArr;
    NSString *title;
    NSString *menuid;
    NSString *pageCount;
    NSMutableDictionary *shaixuanDic;
    NSString *sidTemp;
}
@property (nonatomic,retain)NSDictionary *spcDic;
@property (nonatomic,strong)DJRefresh *refresh;
//存储所有筛选条件
@property(strong,nonatomic) NSMutableDictionary *inParameters;


@end
