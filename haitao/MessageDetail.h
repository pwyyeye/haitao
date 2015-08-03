//
//  MessageDetail.h
//  haitao
//
//  Created by pwy on 15/8/1.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@interface MessageDetail : UIViewController<HTTPControllerProtocol>

@property (weak, nonatomic) IBOutlet UILabel *from_user;

@property (weak, nonatomic) IBOutlet UIImageView *user_imageView;

@property (weak, nonatomic) IBOutlet UILabel *content;

@property(strong,nonatomic) MessageModel *message;
@end
