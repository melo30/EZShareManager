//
//  EZViewController.m
//  EZShareManager
//
//  Created by melo30 on 01/15/2021.
//  Copyright (c) 2021 melo30. All rights reserved.
//

#import "EZViewController.h"
#import "UIImage+EZBundleHelp.h"
#import <ShareSDK/ShareSDK.h>
#import "CTMediator.h"

@interface EZViewController ()

@end

@implementation EZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [UIButton new];
    [btn setTitle:@"Share" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnEventAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)btnEventAction:(UIButton *)sender {
    NSString *shareUrl = @"njwap.manjiwangtest.com/#/sharePage?newsId=ce8ef419496747a792a9caf8c2977014";
    NSString *img = @"https://nujiang.oss-cn-hangzhou.aliyuncs.com/images/2020/11/09/16049107560971651.jpg";
    NSString *title = @"测试标题...";
    NSString *subTitle = @"测试描述...";
    
    [[CTMediator sharedInstance] performTarget:@"ShareManager" action:@"SimpleShare" params:@{
        @"sid":@"",
        @"shareEventCallbackUrl":@"xxx",
        @"generalOptions":@{
                @"title":title,
                @"describe": subTitle,
                @"linkurl": shareUrl,
                @"img": img?img:@""
        },
        @"weiboOptions": @{
                @"describe":[NSString stringWithFormat:@"%@  http://%@", title , shareUrl],
                @"img":img?img:@""
        },
        @"QRCodeOptions": @{
                @"type": @1,
                @"img": img?img:@"" ,
                @"title": title?title:@"",
                @"price": @"10",
                @"originalPrice":@"100",
                @"linkurl": shareUrl?shareUrl:@"",
                @"describe": subTitle
                },
        @"SMSOptions": @{
                @"describe": [NSString stringWithFormat:@"%@%@", title?title:@"", shareUrl?shareUrl:@""]
                },
        @"linkCopyOptions": @{
                @"linkurl": shareUrl?shareUrl:@""
                },
        @"singleShareType":@"",
        @"onlyShareView":@(0),
        @"newsId":@"xxxxxx",
        @"isCollect":@(1)} shouldCacheTarget:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
