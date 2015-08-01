//
//  MessageDetail.m
//  haitao
//
//  Created by pwy on 15/8/1.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "MessageDetail.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface MessageDetail ()

@end

@implementation MessageDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"站内信";
    if (![_message isEqual:[NSNull null]]) {
        _from_user.text=_message.from_user;
        _content.text=_message.content;
        [_user_imageView setImageWithURL:[NSURL URLWithString:_message.img] placeholderImage:[UIImage imageNamed:@"default_04.png"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
