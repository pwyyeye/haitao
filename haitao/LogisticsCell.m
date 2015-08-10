//
//  LogisticsCell.m
//  haitao
//
//  Created by pwy on 15/8/8.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LogisticsCell.h"

@implementation LogisticsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect=self.textLabel.frame;
//    self.textLabel.frame=CGRectMake(rect.origin.x, rect.origin.y-20, 150, rect.size.height);
//    rect=self.detailTextLabel.frame;
//    self.detailTextLabel.frame=CGRectMake(rect.origin.x, rect.origin.y+5, rect.size.width, rect.size.height);
    rect=self.imageView.frame;
    
    self.imageView.frame=CGRectMake(rect.origin.x, rect.origin.y, 15, 15);
    
    if (_lianjiexian!=nil) {
        if (self.isFirst==YES) {
            self.lianjiexian.frame=CGRectMake(rect.origin.x+7, self.frame.size.height/2+8, 1, self.frame.size.height);
        }else if(self.isLast==YES){
            self.lianjiexian.frame=CGRectMake(rect.origin.x+7, 0, 1, self.frame.size.height/2-8);
        }else{
            self.lianjiexian.frame=CGRectMake(rect.origin.x+7, 0, 1, self.frame.size.height);
        }
        
    }
    
    
    
}

@end
