//
//  EZShareUIModel.m
//  EZShareManager_Example
//
//  Created by 陈诚 on 2021/1/18.
//  Copyright © 2021 melo30. All rights reserved.
//

#import "EZShareUIModel.h"

@implementation EZShareUIModel

- (void)setType:(EZShareUIViewType)type {
    _type = type;
    switch (_type) {
        case EZShareUIViewTypeQQZone: {
            _title = @"QQ空间";
            _icon = @"ezshare_qqSpace";
        }
            break;
        case EZShareUIViewTypeQQ: {
            _title = @"QQ";
            _icon = @"ezshare_qq";
        }
            break;
        case EZShareUIViewTypeWechatSession: {
            _title = @"微信好友";
            _icon = @"ezshare_weixin";
        }
            break;
        case EZShareUIViewTypeWechatTimeline: {
            _title = @"微信朋友圈";
            _icon = @"ezshare_weixinFriend";
        }
            break;
        case EZShareUIViewTypeSinaWeibo: {
            _title = @"新浪微博";
            _icon = @"ezshare_weibo";
        }
            break;
        case EZShareUIViewTypeCopy: {
            _title = @"复制链接";
            _icon = @"ezshare_复制链接";
        }
            break;
        case EZShareUIViewTypeCode: {
            _title = @"二维码";
            _icon = @"ezshare_二维码";
        }
            break;
        case EZShareUIViewTypeSms: {
            _title = @"短信";
            _icon = @"ezshare_短信";
        }
            break;
        case EZShareUIViewTypeXunliao: {
            _title = @"讯聊";
            _icon = @"ezshare_讯聊";
        }
                break;
        case EZShareUIViewTypeHaoyouquan: {
            _title = @"好友圈";
            _icon = @"ezshare_好友圈";
        }
                break;
        case EZShareUIViewTypeReport: {
            _title = @"举报";
            _icon = @"ezshare_举报";
        }
                break;
        case EZShareUIViewTypeCollection: {
            _title = @"收藏";
            _icon = @"ezshare_收藏";
        }
                break;
        case EZShareUIViewTypeCollectionSelect: {
            _title = @"取消收藏";
            _icon = @"ezshare_收藏选中";
        }
                break;
        case EZShareUIViewTypeThemeNightTime: {
            _title = @"夜间模式";
            _icon = @"ezshare_夜间模式";
        }
                break;
        case EZShareUIViewTypeThemeDayTime: {
            _title = @"日间模式";
            _icon = @"ezshare_日间模式";
        }
                break;
        case EZShareUIViewTypeFontSet: {
            _title = @"字体设置";
            _icon = @"ezshare_字体设置";
        }
                break;
        case EZShareUIViewTypeTop: {
            _title = @"顶";
            _icon = @"ezshare_顶";
        }
                break;
        case EZShareUIViewTypeTopSelect: {
            _title = @"顶";
            _icon = @"ezshare_顶_select";
        }
                break;
        case EZShareUIViewTypeDown: {
            _title = @"踩";
            _icon = @"ezshare_踩";
        }
                break;
        case EZShareUIViewTypeDownSelect: {
            _title = @"踩";
            _icon = @"ezshare_踩_select";
        }
                break;
        case EZShareUIViewTypeLoseIntrest: {
            _title = @"不感兴趣";
            _icon = @"ezshare_不感兴趣";
        }
                break;
        case EZShareUIViewTypeOther: {
            _title = @"";
            _icon = @"";
        }
            break;
            
        default:
            break;
    }
}


@end
