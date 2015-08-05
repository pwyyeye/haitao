//
//  ChooseSizeViewController.h
//  haitao
//
//  Created by SEM on 15/7/30.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//
/**
 *	刷新控件的代理方法
 */
@protocol ChooseSizeDelegate <NSObject>


@optional

/**
 *	刷新回调
 *	@param refresh      刷新的控件
 *	@param direction    刷新的方向
 */
- (void)addShopCarFinsh:(NSDictionary *)dic;


@end
#import "LTKViewController.h"
#import "New_Goods.h"
@interface ChooseSizeViewController : LTKViewController<HTTPControllerProtocol>
@property(nonatomic,retain)NSDictionary *goods_attr;
@property(nonatomic,retain)New_Goods *goods;
/**代理回调对象*/
@property (nonatomic,weak)id<ChooseSizeDelegate>delegate;
@property (nonatomic,assign)bool ischange;
@property (nonatomic,copy)NSString *numCount;
@end
