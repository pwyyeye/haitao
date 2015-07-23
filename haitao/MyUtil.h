//
//  MyUtil.h
//  gatako
//
//  Created by 光速达 on 15-2-3.
//  Copyright (c) 2015年 光速达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyUtil : NSObject
//判断字符串是否为空
+ (BOOL) isEmptyString:(NSString *)string;
//对象转换成utf8json
+ (NSString *) toJsonUTF8String:(id)obj;

//将图片压缩 保存至本地沙盒
+ (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName andCompressionQuality:(CGFloat) quality ;

//颜色值转化 ＃ffffff 转化成10进制
+(int)colorStringToInt:(NSString *)colorStrig colorNo:(int)colorNo;

//验证手机号码格式
+ (BOOL)checkTelephone:(NSString *)str;
@end
