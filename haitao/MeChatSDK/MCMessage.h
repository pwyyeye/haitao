//
//  MCMessage.h
//  MeChatSDK
//
//  Created by Injoy on 14-8-4.
//  Copyright (c) 2014年 MeChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCDefination.h"

@interface MCMessage : NSObject

//消息id
@property (nonatomic,strong) NSString            * messageId;//用作发送消息时该属性可以为空，消息发送成功后会返回messageid
//内容
@property (nonatomic,strong) NSString            * content;
//消息创建时间
@property (nonatomic,assign) long long           createdTime;
//消息类型
@property (nonatomic,assign) kMCMessageType      messageType;
//发送方向
@property (nonatomic,assign) kMCMessageDirection messageDirection;
//发送状态
@property (nonatomic,assign) kMCSentStatus       sentStatus;

@end