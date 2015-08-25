//
//  ForgetForEmaol.h
//  haitao
//
//  Created by pwy on 15/7/24.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetForEmail : UIViewController<HTTPControllerProtocol>
@property (weak, nonatomic) IBOutlet UILabel *message;
@property(strong,nonatomic) NSString *username;
- (IBAction)reSend:(id)sender;


@end
