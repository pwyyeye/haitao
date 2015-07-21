//
//  MyUtil.m
//  gatako
//
//  Created by 光速达 on 15-2-3.
//  Copyright (c) 2015年 光速达. All rights reserved.
//

#import "MyUtil.h"

@implementation MyUtil

+ (BOOL) isEmptyString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
+ (NSString *) toJsonUTF8String:(id)obj{
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
    NSString *json=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return json;
}

+ (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName andCompressionQuality:(CGFloat) quality {
    NSData *imageDate=UIImageJPEGRepresentation(currentImage, quality);
    NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]  stringByAppendingPathComponent:imageName];
    
    NSLog(@"%@",fullPath);
    [imageDate writeToFile:fullPath atomically:NO];
    
    

}


//颜色值转化 ＃ffffff 转化成10进制
+(int)colorStringToInt:(NSString *)colorStrig colorNo:(int)colorNo
{
    const char *cstr;
    int iPosition = 0;
    int nColor = 0;
    cstr = [colorStrig UTF8String];
    
    //判断是否有#号
    if (cstr[0] == '#') iPosition = 1;//有#号，则从第1位开始是颜色值，否则认为第一位就是颜色值
    else iPosition = 0;
    
    //第1位颜色值
    iPosition = iPosition + colorNo*2;
    if (cstr[iPosition] >= '0' && cstr[iPosition] < '9') nColor = (cstr[iPosition] - '0') * 16;
    else  nColor = (cstr[iPosition] - 'A' + 10) * 16;
    
    //第2位颜色值
    iPosition++;
    if (cstr[iPosition] >= '0' && cstr[iPosition] < '9') nColor = nColor + (cstr[iPosition] - '0');
    else nColor = nColor + (cstr[iPosition] - 'A' + 10);
    
    return nColor;
}
@end