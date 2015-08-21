//
//  SpecialModel.h
//  haitao
//
//  Created by SEM on 15/7/25.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialModel : NSObject
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *tags;
@property (copy, nonatomic) NSString *sub_desc;
@property (copy, nonatomic) NSString *start_time;
@property (copy, nonatomic) NSString *end_time;
@property (copy, nonatomic) NSString *img;
@property (copy, nonatomic) NSString *img_app;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *is_open;
@property (copy, nonatomic) NSString *note;
@property (copy, nonatomic) NSString *ct;
@property (copy, nonatomic) NSString *mt;
@property (copy, nonatomic) NSString *sortby;
@property (copy, nonatomic) NSString *is_command;
@property (nonatomic, retain) NSArray *goods_list;
@property (nonatomic, retain) NSArray *goods_list_page;
@property (nonatomic, retain) NSArray *subject_list;
@end
