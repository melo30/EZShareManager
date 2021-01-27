//
//  EZShareManager.m
//  EZShareManager_Example
//
//  Created by 陈诚 on 2021/1/19.
//  Copyright © 2021 melo30. All rights reserved.
//

#import "EZShareManager.h"
#import <ShareSDK/ShareSDK.h>
#import "EZShareGloabalModel.h"
#import "UIImage+EZBundleHelp.h"
#import "EZShareView.h"
#import "YYModel.h"
#import "LCProgressHUD.h"
#import "EZShareQRCodeView.h"

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
#import "WeiboSDK.h"
#import <MessageUI/MessageUI.h>

@interface EZShareManager () <MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) EZShareGloabalModel *gloabalModel;

@property (nonatomic, strong) EZShareQRCodeView *codeView;
@end

@implementation EZShareManager

+ (instancetype)shareInstance {
    static EZShareManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [EZShareManager new];
    });
    return manager;
}

- (void)configerDatasWithParams:(NSDictionary *)params {
    
    EZShareView *shareView = [[EZShareView alloc] init];
    shareView.onlyShareView = [params[@"onlyShareView"] boolValue];
    shareView.newsId = params[@"newsId"];
    shareView.isCollect = [params[@"isCollect"] boolValue];
    shareView.functionType = params[@"functionType"];
    shareView.homeModel = params[@"homeModel"];
    shareView.collectModel = params[@"collectModel"];
    shareView.type = params[@"type"];
    shareView.isLike = [params[@"isLike"] boolValue];
    shareView.isTrample = [params[@"isTrample"] boolValue];
    shareView.topCount = params[@"topCount"];
    shareView.trampleCount = params[@"trampleCount"];
    
    EZShareGloabalModel *gloabalModel = [EZShareGloabalModel yy_modelWithJSON:params];
    _gloabalModel = gloabalModel;
    if (!gloabalModel.generalOptions) {
        NSLog(@"请传入通用模型实体");
        return;
    }
    NSMutableArray *items = [NSMutableArray array];
    NSArray *generalItems = @[@(EZShareUIViewTypeXunliao),@(EZShareUIViewTypeHaoyouquan),@(EZShareUIViewTypeWechatSession), @(EZShareUIViewTypeWechatTimeline), @(EZShareUIViewTypeQQ), @(EZShareUIViewTypeQQZone)];
    [generalItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger type = [obj integerValue];
        EZShareUIModel *model = [EZShareUIModel new];
        model.type = type;
        //讯聊和好友圈
        if (type == EZShareUIViewTypeXunliao || type == EZShareUIViewTypeHaoyouquan) {
            [items addObject:model];
        }
        
        //QQ
        if (type == EZShareUIViewTypeQQ && ([QQApiInterface isQQInstalled] || [QQApiInterface isTIMInstalled] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])) {
            [items addObject:model];
        }
        
        //QQ空间
        if (type == EZShareUIViewTypeQQZone && ([QQApiInterface isQQInstalled] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqzone://"]] || [QQApiInterface isTIMInstalled] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])) {
            [items addObject:model];
        }
        
        //微信好友和微信朋友圈
        if ((type == EZShareUIViewTypeWechatSession || type == EZShareUIViewTypeWechatTimeline) && ([WXApi isWXAppInstalled] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"Whatapp://"]]) ) {
            [items addObject:model];
        }
        
    }];
    
    //微博
    if (gloabalModel.weiboOptions) {
        if ([WeiboSDK isWeiboAppInstalled]) {
            EZShareUIModel *model = [EZShareUIModel new];
            model.type = EZShareUIViewTypeSinaWeibo;
            [items addObject:model];
        }
    }
    
    //复制链接
    if (gloabalModel.linkCopyOptions) {
        EZShareUIModel *model = [EZShareUIModel new];
        model.type = EZShareUIViewTypeCopy;
        [items addObject:model];
    }
    
    //短信
    if (gloabalModel.SMSOptions) {
        EZShareUIModel *model = [EZShareUIModel new];
        model.type = EZShareUIViewTypeSms;
        [items addObject:model];
    }
    
    //二维码
    if (gloabalModel.QRCodeOptions) {
        EZShareUIModel *model = [EZShareUIModel new];
        model.type = EZShareUIViewTypeCode;
        [items addObject:model];
    }
    
    //其它功能(包括不感兴趣、夜间模式、字体设置、顶、踩)
    if (!shareView.onlyShareView) {
        {
            //举报
            EZShareUIModel *model = [EZShareUIModel new];
            model.type = EZShareUIViewTypeReport;
            [items addObject:model];
        }
        {
            //收藏
            EZShareUIModel *model = [EZShareUIModel new];
            model.type = shareView.isCollect ? EZShareUIViewTypeCollectionSelect : EZShareUIViewTypeCollection;
            [items addObject:model];
        }
        
        if ([shareView.functionType isEqualToString:@"loseInterest"]) {//视频频道首页(特有不感兴趣)
            EZShareUIModel *model = [EZShareUIModel new];
            model.type = EZShareUIViewTypeLoseIntrest;
            [items addObject:model];
        }else {
            if ([shareView.type isEqualToString:@"video"]) {//视频类型(特有顶踩)
                {
                    EZShareUIModel *model = [EZShareUIModel new];
                    model.type = shareView.isLike ? EZShareUIViewTypeTopSelect : EZShareUIViewTypeTop;
                    model.title = [NSString stringWithFormat:@"顶%@",shareView.topCount];
                    [items addObject:model];
                }
                {
                    EZShareUIModel *model = [EZShareUIModel new];
                    model.type = shareView.isTrample ? EZShareUIViewTypeDownSelect : EZShareUIViewTypeDown;
                    model.title = [NSString stringWithFormat:@"顶%@",shareView.trampleCount];
                    [items addObject:model];
                }
            }else {//普通文章类型(特有主题模式和字体设置)
                NSString *pattern = [[NSUserDefaults standardUserDefaults] objectForKey:@"kNightTimePattern"];
                if (!pattern || [pattern isEqualToString:@"夜间模式"]) {
                    EZShareUIModel *model = [EZShareUIModel new];
                    model.type = EZShareUIViewTypeThemeNightTime;
                    [items addObject:model];
                }else {
                    EZShareUIModel *model = [EZShareUIModel new];
                    model.type = EZShareUIViewTypeThemeDayTime;
                    [items addObject:model];
                }
                //字体设置
                EZShareUIModel *model = [EZShareUIModel new];
                model.type = EZShareUIViewTypeFontSet;
                [items addObject:model];
            }
        }
    }
    
    NSString *singleShareType = params[@"singleShareType"];
    if ([singleShareType isEqualToString:@""]) {
        
    }else {//单个分享
        if ([singleShareType isEqualToString:@"weixin"]) {//分享到微信好友
             [self shareToPlatformWithType:EZShareUIViewTypeWechatSession];
        }else if ([singleShareType isEqualToString:@"weixinFriend"]) {//分享到微信朋友圈
             [self shareToPlatformWithType:EZShareUIViewTypeWechatTimeline];
        }
    }
    
    [shareView reloadDataWithItems:items];
    
    [shareView show];
}

/// 分享
- (void)shareToPlatformWithType:(EZShareUIViewType)type {
    
    SSDKPlatformType platformType = 0;
    
    switch (type) {
        case EZShareUIViewTypeWechatSession://微信好友
            platformType = SSDKPlatformSubTypeWechatSession;
            break;
        case EZShareUIViewTypeWechatTimeline://微信朋友圈
            platformType = SSDKPlatformSubTypeWechatTimeline;
            break;
        case EZShareUIViewTypeSinaWeibo://新浪微博
            platformType = SSDKPlatformTypeSinaWeibo;
            break;
        case EZShareUIViewTypeQQ://QQ
            platformType = SSDKPlatformTypeQQ;
            break;
        case EZShareUIViewTypeQQZone://QQ空间
            platformType = SSDKPlatformSubTypeQZone;
            break;
        default:
            break;
    }
    
    NSString *title = _gloabalModel.generalOptions.title;
    NSString *text = _gloabalModel.generalOptions.describe;
    NSString *image = _gloabalModel.generalOptions.img;
    NSArray *images = _gloabalModel.generalOptions.images;
    UIImage *imageObj;
    if (images.count > 0) {
        imageObj = [images firstObject];
    }
    if (image == nil && imageObj == nil) {
        imageObj = [UIImage bundleKey:@"EZShareManager" imageName:@"ezshare_wnjLogo"];
    }
    NSURL *url = [NSURL URLWithString:_gloabalModel.generalOptions.linkurl?_gloabalModel.generalOptions.linkurl:@"www.manjiwang.com"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:text images:image?image:imageObj url:url title:title type:SSDKContentTypeAuto];
    [ShareSDK share:platformType
             parameters:params
    onStateChanged:^(SSDKResponseState state,
    NSDictionary *userData, SSDKContentEntity *contentEntity,
    NSError *error) {

            switch (state) {
                  case SSDKResponseStateSuccess:
                            NSLog(@"成功");//成功
                            break;
                  case SSDKResponseStateFail:
                      {
                            NSLog(@"--%@",error.description);
                            //失败
                            break;
                       }
                  case SSDKResponseStateCancel:
                            //取消
                            break;

                  default:
                  break;
            }
    }];
}

/// 复制
- (void)copyLinkUrl {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *url = self.gloabalModel.linkCopyOptions.linkurl;
    if (!url) {
        url = self.gloabalModel.generalOptions.linkurl;
    }
    pasteboard.string = url ? url : @"www.wisdomNuJiang.com";
    [LCProgressHUD show:@"已复制到粘贴板"];
}

/// 发送短信
- (void)sendSms {
    MFMessageComposeViewController *viewController = [[MFMessageComposeViewController alloc] init];
    viewController.body = self.gloabalModel.SMSOptions.describe;
    viewController.messageComposeDelegate = self;
    if (viewController) {
        [LCProgressHUD show:@"正在调起系统短信组件"];
        UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topRootViewController.presentedViewController) {
            topRootViewController = topRootViewController.presentedViewController;
        }
        [topRootViewController presentViewController:viewController animated:YES completion:^{
            [LCProgressHUD hide];
        }];
    }else {
        [LCProgressHUD show:@"该设备不支持短信功能"];
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate 点击取消会调用
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

/// 二维码分享
- (void)codeShare {
    self.codeView = [[EZShareQRCodeView alloc] initWithModel:self.gloabalModel.QRCodeOptions];
    [self.codeView show];
}
@end
