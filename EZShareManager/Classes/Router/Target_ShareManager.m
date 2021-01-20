//
//  Target_ShareManager.m
//  EZShareManager
//
//  Created by 陈诚 on 2021/1/18.
//

#import "Target_ShareManager.h"
#import "EZShareManager.h"

@implementation Target_ShareManager

/// 分享
- (id)Action_SimpleShare:(NSDictionary *)params {
    [[EZShareManager shareInstance] configerDatasWithParams:params];
    return nil;
}


@end
