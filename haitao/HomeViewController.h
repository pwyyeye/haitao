//
//  HomeViewController.h
//  haitao
//
//  Created by SEM on 15/7/17.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LTKViewController.h"
#import "HaiTaoBase.h"
@interface HomeViewController : LTKViewController<UIScrollViewDelegate,HTTPControllerProtocol>
{
    UIScrollView              *_scrollView;
    NSMutableArray *app_home_bigegg;//首页通栏即广告栏
    NSMutableArray *app_home_grab;//手机端抢购
    NSMutableArray *app_home_command;//手机端精品推荐
    NSMutableArray *app_home_brand;//手机端国际名品
    NSMutableArray *new_goods;//手机端国际名品
}
@property(nonatomic,retain)NSMutableArray *_scrol_marray;//滚动图片数组
@end
