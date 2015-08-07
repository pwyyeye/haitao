//
//  HTBoutiqueViewController.h
//  haitao
//
//  Created by SEM on 15/7/17.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LTKViewController.h"
#import "DJRefresh.h"
#import "DJRefreshProgressView.h"
#import "CFImageButton.h"
@interface HTBoutiqueViewController : LTKViewController
<UITableViewDelegate,UITableViewDataSource,HTTPControllerProtocol,DJRefreshDelegate>{
    NSMutableArray *listArr;
}
@property (nonatomic,strong)DJRefresh *refresh;
@end
