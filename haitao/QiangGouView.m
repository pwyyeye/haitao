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
    if (timer) {
        if ([timer isValid]) {
            [timer invalidate];
        }
        timer=nil;
    }
     timer=[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    [timer fire];
}
-(void)changeTime{
    NSDate *nowDate=[NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSHourCalendarUnit|NSCalendarUnitMinute|NSCalendarUnitSecond ;//年、月、日、时、分、秒、周等等都可以
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:nowDate toDate:dateTime options:0];
    int hours = (int)[comps hour];
    int minute = (int)[comps minute];
    int second = (int)[comps second];
    if(second<0||minute<0||hours<0){
        self.hour10.text=@"0";
        self.hour1.text=@"0";
        self.min10.text=@"0";
        self.min1.text=@"0";
        self.sec10.text=@"0";
        self.sec1.text=@"0";
        if ([timer isValid]) {
            [timer invalidate];
            //这行代码很关键
            timer=nil;
            
        }
        return;
    }
    NSLog(@"****%d*****%d****%d",hours,minute,second);
    if(hours<10){
        self.hour10.text=@"0";
        self.hour1.text=[NSString stringWithFormat:@"%d",hours];
    }else{
        int tenStr=hours/10;
        int gStr=hours%10;
        self.hour10.text=[NSString stringWithFormat:@"%d",tenStr];
        self.hour1.text=[NSString stringWithFormat:@"%d",gStr];
    }
    if(minute<10){
        self.min10.text=@"0";
        self.min1.text=[NSString stringWithFormat:@"%d",minute];
    }else{
        int tenStr=minute/10;
        int gStr=minute%10;
        self.min10.text=[NSString stringWithFormat:@"%d",tenStr];
        self.min1.text=[NSString stringWithFormat:@"%d",gStr];
    }
    if(second<10){
        self.sec10.text=@"0";
        self.sec1.text=[NSString stringWithFormat:@"%d",second];
    }else{
        int tenStr=second/10;
        int gStr=second%10;
        self.sec10.text=[NSString stringWithFormat:@"%d",tenStr];
        self.sec1.text=[NSString stringWithFormat:@"%d",gStr];
    }
}

//@property(strong,nonatomic)IBOutlet UILabel *hour10;
//@property(strong,nonatomic)IBOutlet UILabel *hour1;
//@property(strong,nonatomic)IBOutlet UILabel *min10;
//@property(strong,nonatomic)IBOutlet UILabel *min1;
//@property(strong,nonatomic)IBOutlet UILabel *sec10;
//@property(strong,nonatomic)IBOutlet UILabel *sec1;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
