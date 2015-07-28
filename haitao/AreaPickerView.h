//
//  AreaPickerView.h
//  haitao
//
//  Created by pwy on 15/7/27.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2
@interface AreaPickerView : UIPickerView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic)  NSDictionary *areaDic;
@property (strong, nonatomic)  NSArray *provinces;
@property (strong, nonatomic)  NSArray *city;
@property (strong, nonatomic)  NSArray *district;

@property (strong, nonatomic)  NSString *selectedProvince;

@end
