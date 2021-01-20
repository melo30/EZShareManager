//
//  UIImage+EZQRCode.h
//  EZShareManager
//
//  Created by 陈诚 on 2021/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (EZQRCode)

+ (UIImage *)createQRWithString:(NSString*)text QRSize:(CGSize)size QRColor:(UIColor*)qrColor bkColor:(UIColor*)bkColor;


+ (UIImage *)captureView:(UIView *)view;


+ (UIImage *)ezshare_imageNamed:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
