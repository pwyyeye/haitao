//
//  IndexModel.h
//  haitao
//
//  Created by SEM on 15/8/5.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexModel : NSObject
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *img;
@property (assign, nonatomic) BOOL isChoose;
@property(nonatomic,retain) NSString *letter;
@property(strong,nonatomic) NSString *logo2;
@property(strong,nonatomic) NSString *first_name;
@property(strong,nonatomic) NSString *app_img;//类别用该字段
@end
