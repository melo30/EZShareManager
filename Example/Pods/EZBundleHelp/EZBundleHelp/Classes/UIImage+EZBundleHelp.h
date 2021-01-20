//
//  UIImage+EZBundleHelp.h
//  EZBundleHelp_Example
//
//  Created by 陈诚 on 2020/11/7.
//  Copyright © 2020 melo30. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (EZBundleHelp)

+ (UIImage *)bundleKey:(NSString *)key imageName:(NSString *)imageName;

+ (UIImage *)bundleKey:(NSString *)key imageName:(NSString *)imageName ofType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
