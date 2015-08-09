//
//  OrderSuccessController.h
//  haitao
//
//  Created by pwy on 15/8/8.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderSuccessController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *orderNo;

@property (weak, nonatomic) IBOutlet UILabel *payAmount;

@property(strong,nonatomic) NSString *orderNoString;

@property(strong,nonatomic) NSString *payAmountString;

- (IBAction)gotoOrder:(id)sender;

- (IBAction)gotoSearch:(id)sender;

- (IBAction)gotoHome:(id)sender;
@end
