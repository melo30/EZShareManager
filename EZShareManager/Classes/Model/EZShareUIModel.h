//
//  EZShareUIModel.h
//  EZShareManager_Example
//
//  Created by 陈诚 on 2021/1/18.
//  Copyright © 2021 melo30. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EZShareUIViewType) {
    EZShareUIViewTypeQQZone = 0,//QQ空间
    EZShareUIViewTypeQQ   = 1,//QQ
    EZShareUIViewTypeWechatSession = 2,//微信好友
    EZShareUIViewTypeWechatTimeline,//微信朋友圈
    EZShareUIViewTypeSinaWeibo,//新浪微博
    EZShareUIViewTypeCopy,//复制
    EZShareUIViewTypeCode,//二维码
    EZShareUIViewTypeSms,//短信
    EZShareUIViewTypeXunliao,//讯聊
    EZShareUIViewTypeHaoyouquan,//好友圈
    EZShareUIViewTypeReport,//举报
    EZShareUIViewTypeCollection,//收藏
    EZShareUIViewTypeCollectionSelect,//收藏选中
    EZShareUIViewTypeThemeNightTime,//夜间模式
    EZShareUIViewTypeThemeDayTime,//日间模式
    EZShareUIViewTypeFontSet,//字体设置
    EZShareUIViewTypeTop,//顶
    EZShareUIViewTypeTopSelect,//顶选中
    EZShareUIViewTypeDown,//踩
    EZShareUIViewTypeDownSelect,//踩选中
    EZShareUIViewTypeLoseIntrest,//不感兴趣
    EZShareUIViewTypeOther,//其它
};

@interface EZShareUIModel : NSObject

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) EZShareUIViewType type;

@end

NS_ASSUME_NONNULL_END
