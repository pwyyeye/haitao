//
//  BADockCell.m
//  酒吧助手
//
//  Created by 叶星龙 on 15/5/22.
//  Copyright (c) 2015年 北京局外者科技有限公司. All rights reserved.
//

#import "BADockCell.h"
#import "Header.h"
@interface BADockCell ()




@end


@implementation BADockCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        
        UILabel *category =[[UILabel alloc]initWithFrame:(CGRect){23,0,75-23,75-28}];
        [self.contentView addSubview:category];
        _category=category;
        UrlImageView *urlImgeView=[[UrlImageView alloc]initWithFrame:CGRectMake(2, 10, 25, 25)];
        [urlImgeView setContentMode:UIViewContentModeScaleAspectFill];
        urlImgeView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:urlImgeView];
        _urlView=urlImgeView;
        
        

        
        UIView *viewShow =[[UIView alloc]initWithFrame:(CGRect){0,49.5,75,0.5}];
        viewShow.backgroundColor=[UIColor blackColor];
        viewShow.alpha=0.4;
        [self.contentView addSubview:viewShow];
        UIView *viewShow1 =[[UIView alloc]initWithFrame:(CGRect){0,0,2,50}];
        viewShow1.backgroundColor=UIColorRGBA(255, 127, 0, 1);
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
    _category.font=Font(12);
    
}
-(void)setImgurlText:(NSString *)imgurlText{
    [_urlView setImage:[UIImage imageNamed:imgurlText]];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BADockCell";
    BADockCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BADockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //取消选中状态
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com