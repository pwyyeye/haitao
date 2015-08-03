//
//  MessageCell.m
//  haitao
//
//  Created by pwy on 15/8/1.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

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
    self.textLabel.frame=CGRectMake(rect.origin.x, rect.origin.y-10, 180, rect.size.height);
    rect=self.detailTextLabel.frame;
    self.detailTextLabel.frame=CGRectMake(rect.origin.x, rect.origin.y+5, rect.size.width, rect.size.height);
    rect=self.imageView.frame;
    self.imageView.frame=CGRectMake(rect.origin.x, rect.origin.y, 40, 40);
    if (self.isRead!=nil) {
        self.isRead.frame=CGRectMake(rect.origin.x+43, rect.origin.y, 6, 6);

    }
}

@end