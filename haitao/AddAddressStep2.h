//
//  AddAddressStep2.h
//  haitao
//
//  Created by pwy on 15/7/21.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AddAddressStep2 : UIViewController<HTTPControllerProtocol,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>

@property(strong,nonatomic) NSString *id;

@property (weak, nonatomic) IBOutlet UIImageView *idcard_zhengmian;
@property (weak, nonatomic) IBOutlet UIImageView *idcard_fanmian;

@property(assign,nonatomic) int targetIdex;//纪录哪个UIImageView被触发

@property(assign,nonatomic) int uploadStatus_zhengmian;//0、用户并未上传，1、上传正面

@property(assign,nonatomic) int uploadStatus_fanmian;//0、用户并未上场 1、上传反面
- (IBAction)save:(id)sender;
@end
