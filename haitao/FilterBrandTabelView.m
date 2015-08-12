//
//  FilterBrandTabelView.m
//  haitao
//
//  Created by pwy on 15/8/11.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "FilterBrandTabelView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "IndexModel.h"
#import "FilterBtn.h"
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
        _leftTable.scrollEnabled=NO;
        [self addSubview:_leftTable];
    }
    
    if (_rightArray.count!=0) {
        //一开始只load A选项
//        _rightArray=[self loadRightView:_rightArray];
        NSArray *modelArray=[self filterArray:_rightArray withLetter:@"A"];
       NSArray  *Array=[self loadRightView:modelArray];

        
        _rightTable =[[LBRightTableView alloc]initWithFrame:(CGRect){_leftTableWidth,0,SCREEN_WIDTH-_leftTableWidth,_rightTableHeight*(Array.count/2+1)}];
        _rightTable.rowHeight=_rightTableHeight;
        _rightTable.rightArray=Array;
        _rightTable.backgroundColor=[UIColor whiteColor];
        [_rightTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_rightTable reloadData];
        _rightTable.scrollEnabled=NO;
        [self addSubview:_rightTable];
        
        
        
    }
    if (_leftArray.count!=0&&_rightArray.count!=0) {
        
        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, _leftTable.frame.size.height-_rightTable.frame.size.height>0?_leftTable.frame.size.height:_rightTable.frame.size.height);
    }

}

-(NSArray *)loadRightView:(NSArray *)array{
    NSMutableArray *mutArray=[[NSMutableArray alloc] init];
    int step=0;
    UIView *view;
    for (int i=0; i<array.count; i++) {
        IndexModel *model=array[i];
        if (step==0) {
            view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, _rightTableWidth, _rightTableHeight)];
            step++;
            FilterBtn *button=[FilterBtn buttonWithType:UIButtonTypeCustom];
            button.indexModel=model;
            button.frame=CGRectMake(10, 5, _rightTableWidth/2-20, _rightTableHeight-10);
            
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _rightTableHeight-10, _rightTableHeight-10)];
            [imageView setImageWithURL:[NSURL URLWithString:model.logo2] placeholderImage:[UIImage imageNamed:@"default_04"]];
            
            [button addSubview:imageView];
            
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+_rightTableHeight, 0, _rightTableWidth/2-_rightTableHeight-25, _rightTableHeight-10)];
            
            label.text=model.name;
            label.font=[UIFont systemFontOfSize:11];
            label.textColor=RGB(51, 51, 51);
            [button addSubview:label];
            button.layer.borderColor=RGB(237, 237, 237).CGColor;
            button.layer.borderWidth=0.5;
            [button addTarget:self action:@selector(btnBrandClick:) forControlEvents:UIControlEventTouchUpInside];

            [view addSubview:button];
            
            if (array.count%2!=0 && array.count-1==i) {
                [mutArray addObject:view];
            }
            
        }else{
            FilterBtn *button=[FilterBtn buttonWithType:UIButtonTypeCustom];
            button.indexModel=model;
            
            button.frame=CGRectMake(_rightTableWidth/2+10, 5, _rightTableWidth/2-20, _rightTableHeight-10);
            
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _rightTableHeight-10, _rightTableHeight-10)];
            [imageView setImageWithURL:[NSURL URLWithString:model.logo2] placeholderImage:[UIImage imageNamed:@"default_04"]];
            
            [button addSubview:imageView];
            
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+_rightTableHeight, 0, _rightTableWidth/2-_rightTableHeight-25, _rightTableHeight-10)];
            
            label.text=model.name;
            label.font=[UIFont systemFontOfSize:11];
            label.textColor=RGB(51, 51, 51);
            [button addSubview:label];
            button.layer.borderColor=RGB(237, 237, 237).CGColor;
            button.layer.borderWidth=0.5;
            
            [button addTarget:self action:@selector(btnBrandClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:button];
            step=0;
            [mutArray addObject:view];
        }
        
        
    }
    _resultArray=[mutArray copy];
    return _resultArray;
}

-(void)btnBrandClick:(UIButton *)sender{
    
    for (UIView *view in _resultArray) {
        for (FilterBtn *subview in view.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *button=(UIButton *)subview;
                button.selected=NO;
                button.layer.borderColor=[UIColor clearColor].CGColor;
                button.layer.borderWidth=0;
            }
        }
        
        
    }
    if (!sender.selected) {
        sender.layer.borderColor=RGB(255, 13, 94).CGColor;
        sender.layer.borderWidth=0.5;
        sender.selected=YES;
        if ([self.delegate respondsToSelector:@selector(buttonClickForBrand:)]) {
            FilterBtn *btn=(FilterBtn *)sender;
            [self.delegate buttonClickForBrand:btn.indexModel];
        }
    }else{
        sender.layer.borderColor=CLEARCOLOR.CGColor;
        sender.layer.borderWidth=0;
        sender.selected=NO;
    }
    
}

#pragma mark - LetterBrandDockDelegate

-(void)lbDockClickindexPathRow:(NSMutableArray *)row  index:(NSIndexPath *)index indeXPath:(NSIndexPath *)indexPath{
    NSLog(@"----pass-LetterBrandDockDelegate%d,,,,,,,%@---",indexPath.row,_leftArray[indexPath.row]);
    NSArray *modelArray=[self filterArray:_rightArray withLetter:_leftArray[indexPath.row]] ;
    
    _rightTable.rightArray=[self loadRightView:modelArray];
    [_rightTable reloadData];
}


-(NSArray *)filterArray:(NSArray *) array withLetter:(NSString *)letter{
    
    NSString  *prediStr1 = [NSString stringWithFormat:@"first_name=='%@'", letter];
    
    NSLog(@"----pass-prediStr1%@---",[NSString stringWithFormat:@"%@",prediStr1]);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@",prediStr1]];
    return [_rightArray filteredArrayUsingPredicate:predicate];
}

@end
