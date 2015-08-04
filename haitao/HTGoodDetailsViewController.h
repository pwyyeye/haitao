//
//  HTGoodDetailsViewController.h
//  haitao
//
//  Created by SEM on 15/7/18.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//商品详细信息

#import "LTKViewController.h"
#import "New_Goods.h"
#import "Goods_Ext.h"

@interface HTGoodDetailsViewController : LTKViewController
{
    UIScrollView *_scrollView;
    UIImageView*  tabBarArrow;//上部桔红线条
    UIButton*BtnItem1; //上部三个按钮
    UIButton*BtnItem2;
    UIButton*BtnItem3;
    
    UrlImageButton *_bigView2;
    UrlImageButton *_bigImg;
    
    UrlImageButton *btnNine;
}
@property(nonatomic,retain)New_Goods *goods ;
@property(nonatomic,retain)NSArray *goods_parity;
@property(nonatomic,retain)Goods_Ext *goodsExt;
@property(nonatomic,retain)NSArray *goods_image;
@property(nonatomic,retain)NSDictionary *goods_attr;
@end
