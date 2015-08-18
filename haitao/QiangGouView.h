//
//  QiangGouView.h
//  haitao
//
//  Created by SEM on 15/8/9.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiangGouView : UIView{
    NSTimer *timer;
    NSDate *dateTime;
}
@property(strong,nonatomic)IBOutlet UILabel *hour10;
@property(strong,nonatomic)IBOutlet UILabel *hour1;
@property(strong,nonatomic)IBOutlet UILabel *min10;
@property(strong,nonatomic)IBOutlet UILabel *min1;
@property(strong,nonatomic)IBOutlet UILabel *sec10;
@property(strong,nonatomic)IBOutlet UILabel *sec1;
-(void)setTimeStart:(NSDate *)qiangDate;
@end
