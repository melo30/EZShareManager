//
//  EZShareManager.h
//  EZShareManager_Example
//
//  Created by 陈诚 on 2021/1/19.
//  Copyright © 2021 melo30. All rights reserved.
//  MOB无UI分享管理类

#import <Foundation/Foundation.h>
#import <EZShareUIModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface EZShareManager : NSObject

/// 单例
+ (instancetype)shareInstance;

/// 配置数据
- (void)configerDatasWithParams:(NSDictionary *)params;

/// 第三方分享
- (void)shareToPlatformWithType:(EZShareUIViewType)type;

/// 复制
- (void)copyLinkUrl;

/// 发送短信
- (void)sendSms;

/// 二维码分享
- (void)codeShare;

@end

NS_ASSUME_NONNULL_END