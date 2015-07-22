//
//  AddressModel.h
//  haitao
//
//  Created by pwy on 15/7/22.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
/**
 
 "id": "2",
 "user_id": "4",
 "consignee": "3",
 "mobile": "13501929794",
 "idcard": "310228198401232811",
 "idcard_status": "0",
 "idcard_1": "",
 "idcard_2": "",
 "province": "222",
 "address": "333",
 "zipcode": "201500",
 "is_default": "1",
 "ct": "1437383323",
 "mt": "1437383986"
 
 */
@property(strong,nonatomic) NSString *id;

@property(strong,nonatomic) NSString *user_id;

@property(strong,nonatomic) NSString *consignee;

@property(strong,nonatomic) NSString *idcard;

@property(strong,nonatomic) NSString *mobile;

@property(strong,nonatomic) NSString *idcard_status;

@property(strong,nonatomic) NSString *province;

@property(strong,nonatomic) NSString *address;

@property(strong,nonatomic) NSString *zipcode;

@property(strong,nonatomic) NSString *is_default;

@property(strong,nonatomic) NSString *ct;

@property(strong,nonatomic) NSString *mt;



@end
