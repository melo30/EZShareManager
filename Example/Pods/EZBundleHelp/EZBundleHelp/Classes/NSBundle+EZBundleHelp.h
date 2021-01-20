//
//  NSBundle+EZBundleHelp.h
//  EZBundleHelp_Example
//
//  Created by 陈诚 on 2020/11/7.
//  Copyright © 2020 melo30. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (EZBundleHelp)

+ (NSBundle *)getCurrentBundleWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
