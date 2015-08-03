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

        [_user_imageView setImageWithURL:[NSURL URLWithString:_message.img] placeholderImage:[UIImage imageNamed:@"message_admin"]];
        if ([_message.status integerValue]==0) {
            [self updateIsRead];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateIsRead{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    NSDictionary *parameters = @{@"ids":@[_message.id]};
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_setReadBat withType:POSTURL withPam:parameters withUrlName:@"setReadBat"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
}

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app.s_app_id=[dictemp objectForKey:@"s_app_id"];
    [app stopLoading];
    if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
        NSDictionary *dic=[dictemp objectForKey:@"data"];
        NSLog(@"----pass-dic%@---",dic);
        //判断是否有注册通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeToReload" object:nil];
        
    }

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noticeToReload" object:nil];
    
    
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
