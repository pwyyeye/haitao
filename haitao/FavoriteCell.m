//
//  FavoriteCell.m
//  haitao
//
//  Created by pwy on 15/7/31.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "FavoriteCell.h"

@implementation FavoriteCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect=self.imageView.frame;
    self.imageView.frame=CGRectMake(rect.origin.x, rect.origin.y, 50, 50);
    
    rect=self.textLabel.frame;
    self.textLabel.frame=CGRectMake(rect.origin.x, rect.origin.y-10, 180, rect.size.height);
    rect=self.detailTextLabel.frame;
    self.detailTextLabel.frame=CGRectMake(rect.origin.x, rect.origin.y+13, rect.size.width, rect.size.height);
    
    
    
    
}

@end
