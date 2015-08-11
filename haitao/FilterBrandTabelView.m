//
//  FilterBrandTabelView.m
//  haitao
//
//  Created by pwy on 15/8/11.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "FilterBrandTabelView.h"

@implementation FilterBrandTabelView

-(float)leftTableHeight

{
    if (_leftTableHeight == 0)
    {
        _leftTableHeight = 50.0;
        
    }
    return _leftTableHeight;
    
}

-(float)leftTableWidth

{
    if (_leftTableWidth == 0)
    {
        _leftTableWidth = 50.0;
        
    }
    return _leftTableWidth;
    
}

-(float)rightTableHeight

{
    if (_rightTableHeight == 0)
    {
        _rightTableHeight = 50.0;
        
    }
    return _rightTableHeight;
    
}

-(float)rightTableWidth

{
    if (_rightTableWidth == 0)
    {
        _rightTableWidth = 50.0;
        
    }
    return _rightTableWidth;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithLeftArray:(NSArray *)leftArray andRightArray:(NSArray *)rightArray{
    self = [super init];
    if (self) {
        _leftArray=leftArray;
        _rightArray=rightArray;
        
    }
    return self;
}

-(void)loadView{
    if (_leftArray.count!=0) {
        _leftTable =[[LetterBrandDockTavleView alloc] initWithFrame:CGRectMake(0, 0, _leftTableWidth, _leftTableHeight*_leftArray.count+10)];
        _leftTable.rowHeight=_leftTableHeight;
        _leftTable.dockDelegate=self;
        _leftTable.backgroundColor=[UIColor whiteColor];//需要自己修改
        _leftTable.dockArray=[_leftArray copy];
        [_leftTable reloadData];
        [_leftTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:_leftTable];
    }
    if (_rightArray.count!=0) {
        _rightTable =[[LBRightTableView alloc]initWithFrame:(CGRect){_leftTableWidth,0,SCREEN_WIDTH-_leftTableWidth,_rightTableHeight*(_rightArray.count/2+1)}];
        _rightTable.rowHeight=_rightTableHeight;
        _rightTable.rightDelegate=self;
        _rightTable.rightArray=[_rightArray copy];
        _rightTable.backgroundColor=[UIColor whiteColor];
        [_rightTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_rightTable reloadData];
        [self addSubview:_rightTable];
        
    }
    if (_leftArray.count!=0&&_rightArray.count!=0) {
        
        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, _leftTable.frame.size.height-_rightTable.frame.size.height>0?_leftTable.frame.size.height:_rightTable.frame.size.height);
    }

}

#pragma mark - LetterBrandDockDelegate

-(void)lbDockClickindexPathRow:(NSMutableArray *)row  index:(NSIndexPath *)index indeXPath:(NSIndexPath *)indexPath{
    NSLog(@"----pass-LetterBrandDockDelegate%@---",index);
}

#pragma mark -  LBRightTableViewDelegate
-(void)lbQuantity:(NSInteger)quantity money:(NSInteger)money key:(NSString *)key{
    NSLog(@"----pass-%@---%ld--%ld-",key,(long)quantity,(long)money);
}


@end
