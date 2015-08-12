//
//  LBDockCell.m
//  haitao
//
//  Created by SEM on 15/8/5.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LBDockCell.h"
#import "Header.h"
@implementation LBDockCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        
        UILabel *category =[[UILabel alloc]initWithFrame:(CGRect){0,0,30,30}];
        [self.contentView addSubview:category];
        _category=category;
        
        UIView *viewShow =[[UIView alloc]initWithFrame:(CGRect){0,29.5,30,0.5}];
        viewShow.backgroundColor=[UIColor blackColor];
        viewShow.alpha=0.4;
        [self.contentView addSubview:viewShow];
        UIView *viewShow1 =[[UIView alloc]initWithFrame:(CGRect){0,0,2,30}];
        viewShow1.backgroundColor=RGB(255, 13, 94);
        [self.contentView addSubview:viewShow1];
        
        viewShow1.hidden=YES;
        
        
        _viewShow1=viewShow1;
    }
    return self;
}

-(void)setCategoryText:(NSString *)categoryText
{
    _category.text=categoryText;
    _category.textAlignment=NSTextAlignmentCenter;
    _category.font=Font(13);
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BADockCell";
    LBDockCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LBDockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //取消选中状态
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}
@end
