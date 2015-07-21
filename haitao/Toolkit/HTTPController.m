//
//  HTTPController.m
//  SemCC
//
//  Created by SEM on 15/5/20.
//  Copyright (c) 2015年 SEM. All rights reserved.
//

#import "HTTPController.h"
#import "AppDelegate.h"
@implementation HTTPController
-(instancetype)initWith:(NSString *)urlStr withType:(int)type withUrlName:(NSString *)name{
    self = [super init];
    urlPam = urlStr;
    typePam = type;
    urlName = name;
  
    return self;
}
-(instancetype)initWith:(NSString *)urlStr withType:(int)type withPam:(NSDictionary *)pam  withUrlName:(NSString *)name {
    self = [super init];
    urlPam = urlStr;
    typePam = type;
    urlName = name;
    pamDic = pam;

    return self;
}


-(void)onSearch{
    //
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    urlPam = [urlPam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//     [self showToast:@"查询中....."];
    [manager GET:urlPam parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate didRecieveResults:responseObject withName:urlName];
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app stopLoading];

        //[mi_statusbar setHidden:YES];
        //[timer invalidate];
//        [indicator stopAnimating];
//        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        NSLog(@"Error: %@", error);
    }];
    
}
-(void)onSearchForPostJson{
     //[self showToast:@"查询中....."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    //传入的参数
    NSDictionary *parameters = pamDic;
    //你的接口地址
    NSString *url=urlPam;
    //发送请求
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //[mi_statusbar setHidden:YES];
        //[timer invalidate];
        //[indicator stopAnimating];
        //[alertView dismissWithClickedButtonIndex:0 animated:YES];
        [self.delegate didRecieveResults:responseObject withName:urlName];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[mi_statusbar setHidden:YES];
        //[timer invalidate];
        //[indicator stopAnimating];
        
        //[alertView dismissWithClickedButtonIndex:0 animated:YES];
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app stopLoading];

        NSLog(@"Error: %@", error);
        NSLog ( @"operation: %@" , operation. responseString );
    }];
}

@end