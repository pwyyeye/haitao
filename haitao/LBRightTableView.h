//
//  LBRightTableView.h
//  haitao
//
//  Created by SEM on 15/8/5.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LBRightTableViewDelegate <NSObject>

-(void)lbQuantity:(NSInteger)quantity money:(NSInteger)money key:(NSString *)key;

@end
@interface LBRightTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSArray *rightArray;

@property (nonatomic ,weak) id<LBRightTableViewDelegate>rightDelegate;

@end
