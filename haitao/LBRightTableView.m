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
    LBRightCell *cell =[LBRightCell cellWithTableView:tableView];
    cell.TapActionBlock=^(NSInteger pageIndex ,NSInteger money,NSString *key){
        if ([self.rightDelegate respondsToSelector:@selector(lbQuantity:money:key:)]) {
            [self.rightDelegate lbQuantity:pageIndex money:money key:key];
        }
        
    };
    
    cell.backgroundColor=UIColorRGBA(246, 246, 246, 1);
    cell.rightData=_rightArray[indexPath.row];
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
