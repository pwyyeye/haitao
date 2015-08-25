//
//  MenuModel.h
//  haitao
//
//  Created by SEM on 15/7/21.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuModel : NSObject
/** id */
@property (copy, nonatomic) NSString *id;
/** 图像 */
@property (copy, nonatomic) NSString *img;

@property(strong,nonatomic) NSString *img_app;//搜索页面使用图标

@property(strong,nonatomic) NSString *img_app_icon;
//标题
@property (copy, nonatomic) NSString *name;
//子目录
@property (retain, nonatomic) NSArray *child;
@end
