//
//  LBRightTableView.m
//  haitao
//
//  Created by SEM on 15/8/5.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LBRightTableView.h"
#import "LBRightCell.h"
#import "Header.h"
#import "ClassificationBtn.h"
#import "UITableGridViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
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




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _rightArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    LBRightCell *cell =[LBRightCell cellWithTableView:tableView];
//    cell.TapActionBlock=^(NSInteger pageIndex ,NSInteger money,NSString *key){
//        if ([self.rightDelegate respondsToSelector:@selector(lbQuantity:money:key:)]) {
//            [self.rightDelegate lbQuantity:pageIndex money:money key:key];
//        }
//        
//    };
//    
//    cell.backgroundColor=UIColorRGBA(246, 246, 246, 1);
//    cell.rightData=_rightArray[indexPath.row];
//    return cell;
//    
    
    static NSString *identifier = @"Cell";
    //自定义UITableGridViewCell，里面加了个NSArray用于放置里面的3个图片按钮
    UITableGridViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    for(UIView *view in [cell subviews])
    {
        [view removeFromSuperview];
        
    }
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arr=_rightArray[indexPath.row];
    for (int i=0; i<arr.count; i++) {
        MenuModel *menu=arr[i];
        //        NSLog(menu.name);
        //自定义继续UIButton的UIImageButton 里面只是加了2个row和column属性
        ClassificationBtn *button = [ClassificationBtn buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake(0, 0, 50, 50);
        button.center = CGPointMake((1 + i) * 5 + 50 *( 0.5 + i) , 5 + 50 * 0.5);
        //button.column = i;
        [button setValue:[NSNumber numberWithInt:i] forKey:@"column"];
        button.menuModel=menu;
        button.tag=indexPath.row;
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [imageView setImageWithURL:[NSURL URLWithString:menu.img] placeholderImage:[UIImage imageNamed:@"奶粉.jpg"]];
        // UIImage *image = [rightTableView cutCenterImage:imageView.image  size:CGSizeMake(50, 50)];
//        [button addTarget:self action:@selector(imageItemClick:) forControlEvents:UIControlEventTouchUpInside];             [button setBackgroundImage:imageView.image forState:UIControlStateNormal];
        [cell addSubview:button];
        [array addObject:button];
        UILabel *_label=[[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x,button.frame.origin.y+button.frame.size.height,50,30)];
        _label.text=menu.name;
        _label.font=[UIFont boldSystemFontOfSize:13];
        _label.backgroundColor=[UIColor clearColor];
        _label.textColor =RGB(51, 51, 51);
        _label.numberOfLines=1;
        _label.textAlignment=NSTextAlignmentCenter;
        _label.tag=indexPath.row;
        [cell addSubview:_label];
    }
    [cell setValue:array forKey:@"buttons"];
    //获取到里面的cell里面的3个图片按钮引用
    NSArray *imageButtons =cell.buttons;
    //设置UIImageButton里面的row属性
    [imageButtons setValue:[NSNumber numberWithInt:indexPath.row] forKey:@"row"];
    
    return cell;

    
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
