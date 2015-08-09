//
//  SingletonAlipay.m
//  haitao
//
//  Created by pwy on 15/8/7.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "SingletonAlipay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
@implementation SingletonAlipay
//获取支付单例
+(SingletonAlipay *)singletonAlipay{
    static dispatch_once_t onceToken;
    static SingletonAlipay *singletonAlipay;
    dispatch_once(&onceToken, ^{
        singletonAlipay=[[SingletonAlipay alloc] init];
    });
    NSLog(@"-------singletonAlipay---------%@",singletonAlipay);
    return singletonAlipay;
}
-(void)payOrder:(AlipayOrder *) order{

    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088021294345611";
    NSString *seller = @"caiwu@quekua.com";
    NSString *privateKey =@"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALMDdoV+XH0u0pIWhxMGNci/kd7yn9MWzXf2DSLKzSO77bd/55Hta2rTiZDJGANCgQQDjPA+x3HkB9zVXQChS5/i2VKks0nVJjX1JZYV5w0DIyjGGuZTm8P8ia1alzKEzYQlDtyXvJ0Vn3OvVPbgoZKo4dQMk84DT7cLVNwL+mSjAgMBAAECgYEAjSC2yMl0+w/13Ew8Uwg7ULeOtbiLvewlMmTduEcv8PMQlvEUTFxjqgV5V5biAnfkpJhz/VdQ/33poPTo7D09E01PEcBB1lRSR130GRMppHE/okQiW3k4o1yUwSUBeZRhKiBrr/RCL803D/8e2c80glv2gv73S7GdYDO5ki0k5UECQQDueM6J+3G2NXzVkVj4zMz+kjDlVPsvRcsafOBZ9jZ23ps2MTWuGayh6rTkXiWVvcS/HnlYmcn8ZhW8F7sv5H7hAkEAwCvcas9HDaFS614yTlMyl0IGlwmc7/aFGRZhOgg8IrrWWscJUgD7L+Kj/w9KKOnFp/V+APAtWwFYQBpcaHHoAwJBAJoWAQ5zI/Rh9zlf4ydP3Z0YBPQJxwuygxuoWKaISoTgLVYE0fSerkcpCp0MoChzJ+9911aCeFrX829HvjGh6MECQGDRODlvuIJ7doUybfHcJK7kCuHpa/HRp3jeN5m/MFzm+Lu/b0irSeH0M197WoeGT5ixLAxY9ODWqpmRLmFIkfUCQB+40LRTYiookSMAQppnjaT2tvICpNZ0KZuKRxK0BpngMFkiCu2sdcELR78xBNX+a6wtEoIFSsQVttsZYPha+VM=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
//    AlipayOrder *order = [[AlipayOrder alloc] init];
    order.partner = partner;
    order.seller = seller;
    //--------必须填充－－－－begin
//    order.tradeNO = @"123123123"; //订单ID（由商家自行制定）
//    order.productName = @"商品标题"; //商品标题
//    order.productDescription = @"商品描述"; //商品描述
    //必须填充－－－－－－－－－end
    
//    order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
    order.notifyURL =  @"http://www.peikua.com/plugins/pk_alipay/pk_return_url.php"; //回调URL  $return_url = DOMAIN."/plugins/pk_alipay/pk_return_url.php";
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"haitao";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        /***
         9000 订单支付成功
         8000 正在处理中
         4000 订单支付失败
         6001 用户中途取消
         6002 网络连接出错
         */
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            if ([self.delegate respondsToSelector:@selector(callBack:)]) {
                [self.delegate callBack:resultDic];
            }else{
                NSLog(@"reslut with no delegate");
            }
            
        }];

    }
    
}
@end
