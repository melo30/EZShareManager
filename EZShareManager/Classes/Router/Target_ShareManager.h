//
//  Target_ShareManager.h
//  EZShareManager
//
//  Created by 陈诚 on 2021/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_ShareManager : NSObject

/// 只有分享
/// @param params ..
- (id)Action_SimpleShare:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
