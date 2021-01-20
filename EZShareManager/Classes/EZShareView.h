//
//  EZShareView.h
//  EZShareManager
//
//  Created by 陈诚 on 2021/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EZShareView : UIView

@property (nonatomic, copy) NSString *functionType;

//首页Model
@property (nonatomic, strong) id homeModel;

//详情Model
@property (nonatomic, strong) id collectModel;

//顶的数量
@property (nonatomic, copy) NSString *topCount;

//踩的数量
@property (nonatomic, copy) NSString *trampleCount;

//NO:带有下方的举报字体设置等，YES:只有分享
@property (nonatomic, assign) BOOL onlyShareView;

//新闻Id
@property (nonatomic, copy) NSString *newsId;

//是否收藏
@property (nonatomic, assign) BOOL isCollect;

//是否点赞
@property (nonatomic, assign) BOOL isLike;

//是否踩了
@property (nonatomic, assign) BOOL isTrample;

//分享的文章类型 video
@property (nonatomic, copy) NSString *type;

/// 展示
- (void)show;

/// 隐藏
- (void)hide;

/// 拿到数据源
- (void)reloadDataWithItems:(NSMutableArray *)items;

@end

NS_ASSUME_NONNULL_END
