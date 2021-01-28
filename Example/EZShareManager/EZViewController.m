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
    
    UIButton *shareBtn = [UIButton new];
    [shareBtn setTitle:@"Share" forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(100, 100, 100, 100);
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnEventAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    UIButton *weixinLoginBtn = [UIButton new];
    [weixinLoginBtn setTitle:@"微信登录" forState:UIControlStateNormal];
    weixinLoginBtn.frame = CGRectMake(100, 150, 100, 100);
    [weixinLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [weixinLoginBtn addTarget:self action:@selector(weixinBtnEventAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinLoginBtn];
    
    UIButton *qqLoginBtn = [UIButton new];
    [qqLoginBtn setTitle:@"QQ登录" forState:UIControlStateNormal];
    qqLoginBtn.frame = CGRectMake(100, 200, 100, 100);
    [qqLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [qqLoginBtn addTarget:self action:@selector(qqBtnEventAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqLoginBtn];
    
    UIButton *weiboLoginBtn = [UIButton new];
    [weiboLoginBtn setTitle:@"微博登录" forState:UIControlStateNormal];
    weiboLoginBtn.frame = CGRectMake(100, 250, 100, 100);
    [weiboLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [weiboLoginBtn addTarget:self action:@selector(weiboBtnEventAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboLoginBtn];
    
}

- (void)shareBtnEventAction:(UIButton *)sender {
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
        @"onlyShareView":@(1),
        @"newsId":@"xxxxxx",
        @"isCollect":@(1)} shouldCacheTarget:YES];
}

- (void)weixinBtnEventAction:(UIButton *)sender {
    [[CTMediator sharedInstance] performTarget:@"ShareManager" action:@"SimpleLogin" params:@{@"platformType":@"wechat"} shouldCacheTarget:YES];
}

- (void)qqBtnEventAction:(UIButton *)sender {
    [[CTMediator sharedInstance] performTarget:@"ShareManager" action:@"SimpleLogin" params:@{@"platformType":@"qq"} shouldCacheTarget:YES];
}

- (void)weiboBtnEventAction:(UIButton *)sender {
    [[CTMediator sharedInstance] performTarget:@"ShareManager" action:@"SimpleLogin" params:@{@"platformType":@"weibo"} shouldCacheTarget:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
