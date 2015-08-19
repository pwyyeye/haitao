//
//  Feedback.h
//  haitao
//
//  Created by pwy on 15/7/28.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Feedback : UIViewController<HTTPControllerProtocol,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *buttonView;

@property (weak, nonatomic) IBOutlet UITextView *content;

@property (weak, nonatomic) IBOutlet UITextField *contact;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsViewHeight;

@property (weak, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UIScrollView *myScollView;

@property(strong,nonatomic) NSArray *data;

@property(strong,nonatomic) NSMutableArray *btn_array;

@property(assign,nonatomic) float buttonHeight;

@property(assign,nonatomic) int selectedId;

- (IBAction)submit:(id)sender;

- (IBAction)didEndOnExit:(id)sender;

- (IBAction)textFieldBeginEdit:(id)sender;

- (IBAction)textFieldEndEdit:(id)sender;

@end
