//
//  LetterBrandDockTavleView.h
//  haitao
//
//  Created by SEM on 15/8/5.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LetterBrandDockDelegate <NSObject>

-(void)lbDockClickindexPathRow:(NSMutableArray *)row  index:(NSIndexPath *)index indeXPath:(NSIndexPath *)indexPath;


@end
@interface LetterBrandDockTavleView : UITableView
@property (nonatomic ,strong) NSMutableArray *dockArray;

@property (weak ,nonatomic) id <LetterBrandDockDelegate>dockDelegate;
@end
