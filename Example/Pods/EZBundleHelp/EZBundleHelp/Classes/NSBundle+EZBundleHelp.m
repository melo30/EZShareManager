//
//  NSBundle+EZBundleHelp.m
//  EZBundleHelp_Example
//
//  Created by 陈诚 on 2020/11/7.
//  Copyright © 2020 melo30. All rights reserved.
//

#import "NSBundle+EZBundleHelp.h"

@implementation NSBundle (EZBundleHelp)

+ (NSBundle *)getCurrentBundleWithKey:(NSString *)key {
    NSString *mainBundlePath = [NSBundle mainBundle].bundlePath;
    NSString *bundlePath = [NSString stringWithFormat:@"%@/%@.bundle",mainBundlePath, key];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if (bundle == nil) {
        bundlePath = [NSString stringWithFormat:@"%@/Frameworks/%@.framework/%@.bundle",mainBundlePath, key, key];
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    return bundle;
}

@end
