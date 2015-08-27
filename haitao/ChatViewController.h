//
//  ChatViewController.h
//  haitao
//
//  Created by pwy on 15/8/14.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCCore.h"
#import <AudioToolbox/AudioToolbox.h>
@interface ChatViewController : UIViewController<UIWebViewDelegate>
@property(strong,nonatomic) UIWebView *chatView;
@property(strong,nonatomic) NSString *chatUrl;
@property(assign,nonatomic) BOOL isHome;
@property(strong,nonatomic) MCChatViewController* viewController;
+(ChatViewController *)shareChat;
-(void)mechat;
@end
