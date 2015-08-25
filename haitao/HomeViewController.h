//
//  HomeViewController.h
//  haitao
//
//  Created by SEM on 15/7/17.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LTKViewController.h"
#import "HaiTaoBase.h"
#import "DJRefresh.h"
#import "DJRefreshProgressView.h"
typedef NS_ENUM(NSInteger, eRefreshType){
    eRefreshTypeDefine=0,
    eRefreshTypeProgress=1
};

@interface HomeViewController : LTKViewController<UIScrollViewDelegate,HTTPControllerProtocol,DJRefreshDelegate>
{
//    UIScrollView              *_scrollView;
    NSMutableArray *app_home_bigegg;//首页通栏即广告栏
    NSMutableArray *app_home_grab;//手机端抢购
    NSMutableArray *app_home_command;//手机端精品推荐
    NSMutableArray *app_home_brand;//手机端国际名品
    NSMutableArray *new_goods;//新品推荐
    NSString *nowpage;
    NSMutableDictionary *new_goods_pageDic;
    CGRect lastFrameForPage;
    BOOL isfirst;
    NSString *sidTemp;
    NSString *titleTemp;
//    NSMutableArray *new_goods_add;//新品推荐
}
@property (nonatomic,assign)eRefreshType type;
@property(nonatomic,retain)NSMutableArray *_scrol_marray;//滚动图片数组
@property(nonatomic,retain)UIScrollView              *_scrollView;
@end
