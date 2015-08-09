//
//  OrderListCell.m
//  haitao
//
//  Created by pwy on 15/8/2.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "OrderListCell.h"

@implementation OrderListCell

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
    self.textLabel.frame=CGRectMake(rect.origin.x, rect.origin.y-20, 150, rect.size.height);
    
    if (_option1!=nil && ![_option1 isEqual:[NSNull null]]) {
        _option1.frame=CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y+20, 150, 20);
    }
    if (_option2!=nil && ![_option2 isEqual:[NSNull null]]) {
        _option2.frame=CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y+40, 150, 20);
    }
    
    
    rect=self.detailTextLabel.frame;
    self.detailTextLabel.frame=CGRectMake(rect.origin.x, rect.origin.y+5, rect.size.width, rect.size.height);
    rect=self.imageView.frame;
    
    self.imageView.frame=CGRectMake(rect.origin.x, rect.origin.y, 50, 50);
    
}
@end
