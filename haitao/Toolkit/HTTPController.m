//
//  HTTPController.m
//  SemCC
//
//  Created by SEM on 15/5/20.
//  Copyright (c) 2015年 SEM. All rights reserved.
//

#import "HTTPController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
@implementation HTTPController
-(instancetype)initWith:(NSString *)urlStr withType:(int)type withUrlName:(NSString *)name{
    self = [super init];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    if (![MyUtil isEmptyString:app.s_app_id]) {
        urlPam = [NSString stringWithFormat:@"%@&s_app_id=%@",urlStr,app.s_app_id];
    }else{
        urlPam=urlStr;
    }
    typePam = type;
    urlName = name;
  
    return self;
}
-(instancetype)initWith:(NSString *)urlStr withType:(int)type withPam:(NSDictionary *)pam  withUrlName:(NSString *)name {
    self = [super init];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (![MyUtil isEmptyString:app.s_app_id]) {
        urlPam = [NSString stringWithFormat:@"%@&s_app_id=%@",urlStr,app.s_app_id];
    }else{
        urlPam=urlStr;
    }
    
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
    [manager GET:urlPam parameters:pamDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([urlName isEqual:@"login"]) {
            NSLog(@"JSON: %@", responseObject);

        }
        //判断是否登录如果未登录 则进入登录页面
        NSNumber *status=[responseObject objectForKey:@"status"];
        NSLog(@"----pass-httprequest header%@---",operation.request);
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];

        if([status integerValue] == -1){
            
            UIViewController *vc=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [app stopLoading];
        
            [app.navigationController pushViewController:vc animated:YES];
//            [app.navigationController presentViewController:vc animated:YES completion:^{
//                
//            }];
        }else if([status integerValue] == 0){
            id array=[responseObject objectForKey:@"msg"];
            if ([array isKindOfClass:[NSString class]]) {
                ShowMessage(array);
            }else if([array isKindOfClass:[NSArray class]]){
                ShowMessage([array objectAtIndex:0]);
            }
            
            [app stopLoading];
        }else{
            [self.delegate didRecieveResults:responseObject withName:urlName];
        }
        
        
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
    //manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
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
        
        //判断是否登录如果未登录 则进入登录页面
        NSNumber *status=[responseObject objectForKey:@"status"];
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];

        if([status integerValue] == -1){
            
            UIViewController *vc=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [app stopLoading];
            
            [app.navigationController pushViewController:vc animated:YES];
        }else if([status integerValue] == 0){
            id array=[responseObject objectForKey:@"msg"];
            if ([array isKindOfClass:[NSString class]]) {
                 ShowMessage(array);
            }else if([array isKindOfClass:[NSArray class]]){
                  ShowMessage([array objectAtIndex:0]);
            }
            
            [app stopLoading];
           
        }else{
            [self.delegate didRecieveResults:responseObject withName:urlName];
        }
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
