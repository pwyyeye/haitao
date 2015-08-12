//
//  LBRightTableView.m
//  haitao
//
//  Created by SEM on 15/8/5.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LBRightTableView.h"
#import "Header.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "IndexModel.h"
@implementation LBRightTableView
-(id)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.dataSource=self;
        self.delegate=self;
        
    }
    
    return self;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _rightArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"rightCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //出列可重用的cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OrderListCell"];
    }
//    cell.rightData=_rightArray[indexPath.row];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    [cell.contentView addSubview:_rightArray[indexPath.row]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色

    return cell;
//
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



    

@end
