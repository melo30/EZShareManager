//
//  UIImage+EZBundleHelp.m
//  EZBundleHelp_Example
//
//  Created by 陈诚 on 2020/11/7.
//  Copyright © 2020 melo30. All rights reserved.
//

#import "UIImage+EZBundleHelp.h"
#import "NSBundle+EZBundleHelp.h"

@implementation UIImage (EZBundleHelp)

+ (UIImage *)bundleKey:(NSString *)key imageName:(NSString *)imageName {
    return [self bundleKey:key imageName:imageName ofType:@"png"];
}

+ (UIImage *)bundleKey:(NSString *)key imageName:(NSString *)imageName ofType:(NSString *)type {
    NSBundle *bundle = [NSBundle getCurrentBundleWithKey:key];
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {//imageNamed:inBundle:compatibleWithTraitCollection:从image asset 或者 主要的捆绑包中载入图片来进行创建图片对象
        return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    }else {//imageWithContentsOfFile: or initWithContentsOfFile:从本地文件中载入图片进行创建图片对象
        return [UIImage imageWithContentsOfFile:[bundle pathForResource:imageName ofType:type]];
    }
}

@end
