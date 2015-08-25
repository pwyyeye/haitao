//
//  QAViewController.h
//  haitao
//
//  Created by pwy on 15/8/25.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAViewController : UIViewController<UIWebViewDelegate,HTTPControllerProtocol>

@property(strong,nonatomic) UIWebView *webView;
@property(strong,nonatomic) NSString *webUrl;

@end
