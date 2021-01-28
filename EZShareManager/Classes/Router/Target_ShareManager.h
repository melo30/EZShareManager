//
//  Target_ShareManager.h
//  EZShareManager
//
//  Created by 陈诚 on 2021/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_ShareManager : NSObject

/// 第三方分享
/// @param params ..
- (id)Action_SimpleShare:(NSDictionary *)params;

/// 第三方登录
/// @param platformType  qq / wechat / weibo
- (id)Action_SimpleLogin:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
