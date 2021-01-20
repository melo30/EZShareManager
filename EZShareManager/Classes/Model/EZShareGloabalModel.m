//
//  EZShareGloabalModel.m
//  EZShareManager_Example
//
//  Created by 陈诚 on 2021/1/19.
//  Copyright © 2021 melo30. All rights reserved.
//

#import "EZShareGloabalModel.h"

@implementation EZShareGloabalModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"SMSOptions" : @[@"SMSOptions", @"smsOptions"],
             @"QRCodeOptions" : @[@"QRCodeOptions", @"qrCodeOptions"]
             };
}

@end

@implementation EZShareItemModel

@end
