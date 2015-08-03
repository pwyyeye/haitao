//
//  URL.h
//  haitao
//
//  Created by pwy on 15/7/23.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#ifndef haitao_URL_h
#define haitao_URL_h

/**--------------请求地址声明--------------------*/

#define requestUrl [NSString stringWithFormat:@"http://www.peikua.com/app.php?a=app"]

//首页数据
#define requestUrl_getHomeData [NSString stringWithFormat:@"%@&f=getHomeData&m=home",requestUrl]

//分类以及二级分类
#define requestUrl_getHomeNav [NSString stringWithFormat:@"%@&f=getHomeNav&m=home",requestUrl]

//专题列表
#define requestUrl_getSubjectList [NSString stringWithFormat:@"%@&f=getSubjectList&m=goods",requestUrl]

//专题页详情
#define requestUrl_getSubjectInfo [NSString stringWithFormat:@"%@&f=getSubjectInfo&m=goods",requestUrl]

//产品列表
#define requestUrl_getGoodsList [NSString stringWithFormat:@"%@&f=getGoodsList&m=goods",requestUrl]

//产品比价信息
#define requestUrl_getGoodsParityList [NSString stringWithFormat:@"%@&f=getGoodsParityList&m=goods",requestUrl]

//获取验证码
#define requestUrl_captcha [NSString stringWithFormat:@"%@&f=sendVerifyCode&m=user",requestUrl]

//注册
#define requestUrl_doMobileRegist [NSString stringWithFormat:@"%@&f=doMobileRegist&m=user",requestUrl]

//登录
#define requestUrl_doLogin [NSString stringWithFormat:@"%@&f=doLogin&m=user",requestUrl]


//修改用户昵称
#define requestUrl_modifyUserNick [NSString stringWithFormat:@"%@&f=modifyUserNick&m=user",requestUrl]

//修改用户头像
#define requestUrl_modifyUserAvatar [NSString stringWithFormat:@"%@&f=modifyUserAvatar&m=user",requestUrl]


//重置密码
#define requestUrl_resetPassByMobile [NSString stringWithFormat:@"%@&f=resetPassByMobile&m=user",requestUrl]

//登出
#define requestUrl_doLoginOut [NSString stringWithFormat:@"%@&f=doLoginOut&m=user",requestUrl]

//添加地址
#define requestUrl_addAddress [NSString stringWithFormat:@"%@&f=addAddress&m=user",requestUrl]

//修改地址
#define requestUrl_modifyAddress [NSString stringWithFormat:@"%@&f=modifyAddress&m=user",requestUrl]

//删除地址
#define requestUrl_delAddress [NSString stringWithFormat:@"%@&f=delAddress&m=user",requestUrl]

//添加地址
#define requestUrl_getAddress [NSString stringWithFormat:@"%@&f=getAddress&m=user",requestUrl]

//设置默认地址
#define requestUrl_setDefaultAddress [NSString stringWithFormat:@"%@&f=setDefaultAddress&m=user",requestUrl]

//上传身份证
#define requestUrl_modifyIdCard [NSString stringWithFormat:@"%@&f=modifyIdCard&m=user",requestUrl]


//添加购物车
#define requestUrl_addCart [NSString stringWithFormat:@"%@&f=addCart&m=cart",requestUrl]


//购物车列表
#define requestUrl_getCart [NSString stringWithFormat:@"%@&f=getCart&m=cart",requestUrl]


//修改购物车
#define requestUrl_modifyCart [NSString stringWithFormat:@"%@&f=modifyCart&m=cart",requestUrl]


//删除
#define requestUrl_delCart [NSString stringWithFormat:@"%@&f=delCart&m=cart",requestUrl]


//获取意见反馈选项
#define requestUrl_getSuggestTypeList [NSString stringWithFormat:@"%@&f=getSuggestTypeList&m=home",requestUrl]

//获取意见反馈选项
#define requestUrl_addSuggest [NSString stringWithFormat:@"%@&f=addSuggest&m=home",requestUrl]

//我的收藏列表
#define requestUrl_getFav [NSString stringWithFormat:@"%@&f=getFav&m=user",requestUrl]

//添加收藏
#define requestUrl_addFav [NSString stringWithFormat:@"%@&f=addFav&m=user",requestUrl]

//删除收藏
#define requestUrl_delFav [NSString stringWithFormat:@"%@&f=delFav&m=user",requestUrl]

//站内信列表
#define requestUrl_getMsg [NSString stringWithFormat:@"%@&f=getMsg&m=user",requestUrl]

//站内信详情
#define requestUrl_getMsgById [NSString stringWithFormat:@"%@&f=getMsgById&m=user",requestUrl]

//更新站内信已读
#define requestUrl_setReadBat [NSString stringWithFormat:@"%@&f=setReadBat&m=user",requestUrl]

//删除
#define requestUrl_delMsgBat [NSString stringWithFormat:@"%@&f=delMsgBat&m=user",requestUrl]


//我的订单列表
#define requestUrl_getOrderList [NSString stringWithFormat:@"%@&f=getOrderList&m=user",requestUrl]

//站内信详情
//#define requestUrl_getMsgById [NSString stringWithFormat:@"%@&f=getMsgById&m=user",requestUrl]


#endif
