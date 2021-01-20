//
//  UIColor+EZShareManagerHelper.h
//  EZShareManager_Example
//
//  Created by 陈诚 on 2021/1/18.
//  Copyright © 2021 melo30. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (EZShareManagerHelper)

+ (nullable UIColor *)colorWithHexString:(NSString *)hexStr;

+ (nullable UIColor *)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
