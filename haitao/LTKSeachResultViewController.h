//
//  LTKSeachResultViewController.h
//  LvTongKa
//
//  Created by 123 on 13-8-27.

//

#import "LTKViewController.h"



@interface LTKSeachResultViewController : LTKViewController<UISearchBarDelegate, UISearchDisplayDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationBarDelegate,HTTPControllerProtocol>

{
    UIView *hisView;//历史记录
    UITextField                     *seachField;//搜索内容
    UIScrollView                    *_scrollView;
    UILabel                 *hotLabel;
    UITableView                 *_tableView;
    NSString                    *_keyWords;
    NSMutableArray                  *_marrayAll;
    AppDelegate                  *appDelegate;
    BOOL                isSeachFirst;
    UIView                  *navigation;
    UIView                  *seachBarView;
    NSString                    *_seachString;
    NSMutableArray *hisSerchArr;
    NSMutableArray *hisRoute;
    UIView                  *view_bar;
//    UIView                  *seachBar;
    UrlImageButton              *fourBtn;
    UILabel                 *fourLab;
    UIButton*BtnItem1,*BtnItem2;
    UIImageView *tabBarArrow;
    UIImageView* imageViewToolBar;
    
    UIButton*seachBtn;

    UIImageView*seachImageView;
    BOOL _isFirstView;
    UITextField *serchText;

}
@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) UISearchDisplayController *strongSearchDisplayController;
-(id)initSeachKeyWords:(NSString*)keyWords addSeachString:(NSString*)string;
@end
