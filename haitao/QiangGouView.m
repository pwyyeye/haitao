//
//  QiangGouView.m
//  haitao
//
//  Created by SEM on 15/8/9.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "QiangGouView.h"

@implementation QiangGouView
-(void)setTimeStart:(NSDate *)qiangDate{
    //时间间隔
    dateTime=qiangDate;
    NSTimeInterval timeInterval =1.0 ;
    //定时器
     timer=[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(changeTime) userInfo:nil repeats:YES];

}
-(void)changeTime{
    NSDate *nowDate=[NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSHourCalendarUnit;//年、月、日、时、分、秒、周等等都可以
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:nowDate toDate:dateTime options:0];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
