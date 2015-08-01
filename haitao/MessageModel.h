//
//  MessageModel.h
//  haitao
//
//  Created by pwy on 15/8/1.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
@property(strong,nonatomic) NSString *id;
@property(strong,nonatomic) NSString *from_user;
@property(strong,nonatomic) NSString *to_user;
@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *content;
@property(strong,nonatomic) NSString *status;
@property(strong,nonatomic) NSString *ct;
@property(strong,nonatomic) NSString *mt;
@property(strong,nonatomic) NSString *img;
@end
