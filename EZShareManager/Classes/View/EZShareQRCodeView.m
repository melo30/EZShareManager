//
//  EZShareQRCodeView.m
//  EZShareManager
//
//  Created by 陈诚 on 2021/1/20.
//

#import "EZShareQRCodeView.h"

#import <Masonry/Masonry.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
#import <YYWebImage/YYWebImage.h>
#import "UIImage+EZQRCode.h"
#import <Photos/Photos.h>
#import <MJProgressHUD/LCProgressHUD.h>
#import "UIImage+EZQRCode.h"

#define EZShare_UICOLOR_HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString *const EZShareQRCodeViewWeixinKey = @"微信";
static NSString *const EZShareQRCodeViewWeixinPengyouquanKey = @"朋友圈";
static NSString *const EZShareQRCodeViewQQKey = @"QQ";
static NSString *const EZShareQRCodeViewSaveKey = @"保存";


@interface EZShareQRCodeView ()

@property (nonatomic, strong) UIView * bgWindow;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) BOOL animationing;

@property (nonatomic, strong) EZShareQRCodeContainerView * containerView;

@property (nonatomic, strong) EZShareQRCodeItemContainerView * itemView;

@property (nonatomic, strong) UIButton * closeButton;

@property (nonatomic, strong) EZShareItemModel * model;

@property (nonatomic, strong) UIImage * image;

@property (nonatomic, strong) UIButton * backgroundButton;
@end

@implementation EZShareQRCodeView

- (instancetype)initWithModel:(EZShareItemModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
        [self initSubView];
        __weak typeof(self) wself = self;
        [self.itemView setButtonEventBlock:^(NSString * _Nonnull title) {
            [wself startShareWithType:title];
        }];
    }
    return self;
}

#pragma mark - 点击代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
        [LCProgressHUD show:@"保存图片失败"];
    }else{
        [LCProgressHUD show:@"保存图片成功"];
    }
}

- (void)startShareWithType:(NSString *)type {
    if (!self.image) {
        return;
    }
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您尚未打开照片权限，请iPhone的“设置-隐私-照片”中允许访问照片" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([type isEqualToString:EZShareQRCodeViewWeixinKey] || [type isEqualToString:EZShareQRCodeViewWeixinPengyouquanKey]) {
            [WXApi openWXApp];
        }
        if ([type isEqualToString:EZShareQRCodeViewQQKey]) {
            if ([QQApiInterface isQQInstalled]) {
                [QQApiInterface openQQ];
            }else {
                [QQApiInterface openTIM];
            }
        }
    });
}

- (void)initSubView {
    [self addSubview:self.backgroundButton];
    [self.backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(36);
        make.right.mas_equalTo(self.mas_right).mas_offset(-36);
        make.top.mas_equalTo(self.mas_top).mas_offset(70 + [self safeAreaInsetsTop]);
        make.height.mas_equalTo(self.containerView.mas_width).multipliedBy(415.0/304.0);
    }];
    
    [self addSubview:self.itemView];
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView.mas_bottom).mas_offset(30);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(75);
    }];
    
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-16);
        make.bottom.mas_equalTo(self.containerView.mas_top).mas_offset(-5);
        make.height.width.mas_equalTo(25);
    }];
}

/** 二维码分享类型，0或者不传表示 通用的二维码分享类型  1：商品的二维码分享  2：商家分享类型" */
- (void)setModel:(EZShareItemModel *)model {
    _model = model;
    switch (model.type) {
        case 1:
            self.containerView = [EZShareQRCodeGoodsContainerView new];
            break;
        case 2:
            self.containerView = [EZShareQRCodeShopContainerView new];
            break;
        default:
            self.containerView = [EZShareQRCodeGeneralContainerView new];
            break;
    }
    self.containerView.model = model;
}

- (CGFloat)safeAreaInsetsTop {
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        CGFloat topSpace = keyWindow.safeAreaInsets.top;
        return topSpace == 0 ? 20.0 : topSpace;
    }
    return 20;
}

#pragma mark -- show
- (void)show {
    if (_isShow || _animationing) {
        return;
    }
    _isShow = YES;
    _animationing = YES;
    [self.bgWindow addSubview:self];
    self.frame = self.bgWindow.bounds;
    self.backgroundColor = [UIColor colorWithWhite:0.684 alpha:0.000];
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        wself.backgroundColor = [UIColor colorWithWhite:0.177 alpha:0.420];
    }completion:^(BOOL finished) {
        wself.animationing = NO;
    }];
}

#pragma mark -- remove
- (void)hide {
    if (_animationing) {
        return;
    }
    _animationing = YES;
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        wself.backgroundColor = [UIColor colorWithWhite:0.684 alpha:0.000];
        wself.alpha = 0;
    } completion:^(BOOL finished) {
        wself.isShow = NO;
        wself.animationing = NO;
        wself.alpha = 1;
        [wself removeFromSuperview];
    }];
}


#pragma mark -- getter

- (EZShareQRCodeItemContainerView *)itemView {
    if (!_itemView) {
        _itemView = [[EZShareQRCodeItemContainerView alloc] init];
    }
    return _itemView;
}

- (UIImage *)image {
    if (!_image) {
        _image = [UIImage captureView:self.containerView];
    }
    return _image;
}

- (UIView *)bgWindow {
    if (!_bgWindow) {
        _bgWindow = ({
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window;
        });
    }
    return _bgWindow;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage ezshare_imageNamed:@"ezshare_close_icon"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)backgroundButton {
    if (!_backgroundButton) {
        _backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backgroundButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundButton;
}

@end


@implementation EZShareQRCodeContainerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self setBackgroundColor:[UIColor whiteColor]];
    self.layer.cornerRadius = 3;
    self.clipsToBounds = YES;
    [self addSubview:self.logoImageView];
    [self addSubview:self.codeImageView];
    [self addSubview:self.showImageView];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(12);
        make.top.mas_equalTo(self.mas_top).mas_offset(10);
        make.width.mas_equalTo(59);
        make.height.mas_equalTo(18);
    }];
    
    [self.showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(12);
        make.right.mas_equalTo(self.mas_right).mas_offset(-12);
        make.top.mas_equalTo(self.mas_top).mas_offset(37);
        make.height.mas_equalTo(self.mas_width).multipliedBy(256.0/280.0);
    }];
    

    [self addSubview:self.codeContainerImageView];
    [self.codeContainerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-18);
        make.top.mas_equalTo(self.showImageView.mas_bottom).mas_offset(15);
        make.width.height.mas_equalTo(80);
    }];
    
    [self.codeContainerImageView addSubview:self.codeImageView];
    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(65);
        make.centerX.mas_equalTo(self.codeContainerImageView.mas_centerX);
        make.centerY.mas_equalTo(self.codeContainerImageView.mas_centerY);
    }];
    
}

- (void)setModel:(EZShareItemModel *)model {
    _model = model;
    if (model.img) {
        NSArray *imageUrls = [model.img componentsSeparatedByString:@","];
        NSString *firstImageUrl = [imageUrls firstObject];
        if (firstImageUrl) {
            [self.showImageView yy_setImageWithURL:[NSURL URLWithString:firstImageUrl] placeholder:nil];
        }
    }else {
        self.showImageView.image = [model.images firstObject];
    }
    
    if ([model.linkurl hasPrefix:@"http://"] || [model.linkurl hasPrefix:@"https://"]) {
        self.codeImageView.image = [UIImage createQRWithString:model.linkurl QRSize:CGSizeMake(65, 65) QRColor:[UIColor blackColor] bkColor:[UIColor whiteColor]];
    }else {
        self.codeImageView.image = [UIImage createQRWithString:[@"http://" stringByAppendingString:model.linkurl] QRSize:CGSizeMake(65, 65) QRColor:[UIColor blackColor] bkColor:[UIColor whiteColor]];
    }
}


- (UIImageView *)codeContainerImageView {
    if (!_codeContainerImageView) {
        _codeContainerImageView = [[UIImageView alloc] init];
        _codeContainerImageView.image = [UIImage ezshare_imageNamed:@"ezshare_code_border"];
    }
    return _codeContainerImageView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage ezshare_imageNamed:@"ezshare_code_logo"];
    }
    return _logoImageView;
}

- (UIImageView *)codeImageView {
    if (!_codeImageView) {
        _codeImageView = [[UIImageView alloc] init];
    }
    return _codeImageView;
}

- (UIImageView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] init];
        _showImageView.layer.cornerRadius = 3;
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showImageView.clipsToBounds = YES;
    }
    return _showImageView;
}


@end


@implementation EZShareQRCodeGoodsContainerView

- (void)initSubViews {
    [super initSubViews];
    _textLabel = [[UILabel alloc] init];
    _textLabel.textColor = EZShare_UICOLOR_HEX(0xE60012);
    _textLabel.font = [UIFont systemFontOfSize:9];
    _textLabel.text = @" ";
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(12);
        make.top.mas_equalTo(self.showImageView.mas_bottom).mas_offset(19);
        make.right.mas_equalTo(self.codeContainerImageView.mas_left).mas_offset(-20);
    }];
    
    [self addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(12);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15);
    }];
    
}

- (void)setModel:(EZShareItemModel *)model {
    [super setModel:model];
    
    if ([model.price doubleValue] > 0) {
        _textLabel.hidden = NO;
    }else {
        _textLabel.hidden = YES;
    }
    
    self.titleLabel.text = model.title;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = EZShare_UICOLOR_HEX(0x333333);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

@end

@implementation EZShareQRCodeShopContainerView


- (void)initSubViews {
    [super initSubViews];
    
    self.showImageView.hidden = YES;
    CGFloat imageViewWidth = ([UIScreen mainScreen].bounds.size.width - 72 - 24 - 2) / 2.0;
    CGFloat imageViewHeight = imageViewWidth * (127 / 139.0);
    __weak typeof(self) wself = self;
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        [wself addSubview:imageView];
        CGFloat left = 12;
        CGFloat top = 37;
        if (idx % 2 == 1) {
            left = left + imageViewWidth + 2;
        }
        if (idx > 1) {
            top = imageViewHeight + 2 + top;
        }
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(top);
            make.left.mas_equalTo(self.mas_left).mas_offset(left);
            make.width.mas_equalTo(imageViewWidth);
            make.height.mas_equalTo(imageViewHeight);
        }];
    }];
    
    [self.codeContainerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-18);
        make.top.mas_equalTo(self.showImageView.mas_bottom).mas_offset(0);
        make.width.height.mas_equalTo(80);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(12);
        make.top.mas_equalTo(self.showImageView.mas_bottom).mas_offset(0);
        make.right.mas_equalTo(self.codeContainerImageView.mas_left).mas_offset(-20);
    }];
    
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(12);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(9);
        make.right.mas_equalTo(self.codeContainerImageView.mas_left).mas_offset(-20);
    }];
    
    [self addSubview:self.fansLabel];
    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(12);
        make.bottom.mas_equalTo(self.codeContainerImageView.mas_bottom);
        make.height.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(60);
    }];
    
    [self addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fansLabel.mas_right).mas_offset(5);
        make.bottom.mas_equalTo(self.codeContainerImageView.mas_bottom);
        make.height.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(60);
    }];
}

- (void)setModel:(EZShareItemModel *)model {
    [super setModel:model];
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.describe;
    NSArray *imageUrls = [model.img componentsSeparatedByString:@","];
    [imageUrls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < 4) {
            UIImageView *imageView = self.imageViews[idx];
            [imageView yy_setImageWithURL:[NSURL URLWithString:obj] placeholder:nil];
        }
    }];
    [self.scoreLabel setTitle:[NSString stringWithFormat:@"评分%0.1f", [model.shopScore floatValue]] forState:UIControlStateNormal];
    [self.fansLabel setTitle:[NSString stringWithFormat:@"粉丝%ld", [model.shopFans integerValue]] forState:UIControlStateNormal];
}


- (NSArray *)imageViews {
    if (!_imageViews) {
        NSMutableArray *imageViews = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i ++) {
            UIImageView *imageView = [UIImageView new];
            imageView.layer.cornerRadius = 3;
            imageView.clipsToBounds = YES;
            [imageViews addObject:imageView];
        }
        _imageViews = imageViews;
    }
    return _imageViews;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = EZShare_UICOLOR_HEX(0x333333);
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = EZShare_UICOLOR_HEX(0x999999);
        _contentLabel.numberOfLines = 2;
    }
    return _contentLabel;
}

- (UIButton *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = ({
            UIButton *label = [UIButton buttonWithType:UIButtonTypeCustom];
            label.backgroundColor = EZShare_UICOLOR_HEX(0xFFCDC2);
            [label setTitleColor:EZShare_UICOLOR_HEX(0xE30000) forState:UIControlStateNormal];
            label.titleEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 9);
            label.titleLabel.font = [UIFont systemFontOfSize:11];
            label.layer.cornerRadius = 10;
            label;
        });
    }
    return _scoreLabel;
}

- (UIButton *)fansLabel {
    if (!_fansLabel) {
        _fansLabel = ({
            UIButton *label = [UIButton buttonWithType:UIButtonTypeCustom];
            label.backgroundColor = EZShare_UICOLOR_HEX(0xFFCDC2);
            [label setTitleColor:EZShare_UICOLOR_HEX(0xE30000) forState:UIControlStateNormal];
            label.titleEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 9);
            label.titleLabel.font = [UIFont systemFontOfSize:11];
            label.layer.cornerRadius = 10;
            label;
        });
    }
    return _fansLabel;
}


@end

@implementation EZShareQRCodeGeneralContainerView

- (void)initSubViews {
    [super initSubViews];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(12);
        make.top.mas_equalTo(self.showImageView.mas_bottom).mas_offset(19);
        make.right.mas_equalTo(self.codeContainerImageView.mas_left).mas_offset(-20);
    }];
    
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(12);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(9);
        make.right.mas_equalTo(self.codeContainerImageView.mas_left).mas_offset(20);
    }];
}

- (void)setModel:(EZShareItemModel *)model {
    [super setModel:model];
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.describe;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = EZShare_UICOLOR_HEX(0x333333);
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = EZShare_UICOLOR_HEX(0x999999);
        _contentLabel.numberOfLines = 2;
    }
    return _contentLabel;
}


@end


@implementation EZShareQRCodeItemContainerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    CGFloat containerWidth = [UIScreen mainScreen].bounds.size.width - 72;
    CGFloat space = (containerWidth - 50 * self.views.count) / (self.views.count + 1);
    __block CGFloat left = space + 36;
    [self.views enumerateObjectsUsingBlock:^(UIView *  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(75);
            make.left.mas_equalTo(self.mas_left).mas_offset(left);
            make.top.mas_equalTo(self.mas_top);
        }];
        left = left + 50 + space;
    }];
}

- (EZShareQRCodeItem *)createItemWithTitle:(NSString *)title imageName:(NSString *)imageName {
    EZShareQRCodeItem *item = [[EZShareQRCodeItem alloc] init];
    [item setTitle:title forState:UIControlStateNormal];
    [item setImage:[UIImage ezshare_imageNamed:imageName] forState:UIControlStateNormal];
    item.titleLabel.font = [UIFont systemFontOfSize:12];
    [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    item.titleLabel.textAlignment = NSTextAlignmentCenter;
    [item addTarget:self action:@selector(handlerItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    return item;
}

- (void)handlerItemEvent:(UIButton *)sender {
    if (self.buttonEventBlock) {
        self.buttonEventBlock(sender.currentTitle);
    }
}

- (NSArray *)views {
    if (!_views) {
        NSMutableArray *views = [NSMutableArray array];
        if ([WXApi isWXAppInstalled] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"Whatapp://"]]) {
            [views addObject:[self createItemWithTitle:EZShareQRCodeViewWeixinKey imageName:@"ezshare_code_weixin_icon"]];
            [views addObject:[self createItemWithTitle:EZShareQRCodeViewWeixinPengyouquanKey imageName:@"ezshare_code_weixinpengyouquan_icon"]];
        }
        
        if ([QQApiInterface isQQInstalled] || [QQApiInterface isTIMInstalled] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            [views addObject:[self createItemWithTitle:EZShareQRCodeViewQQKey imageName:@"ezshare_code_QQ_icon"]];
        }
        [views addObject:[self createItemWithTitle:EZShareQRCodeViewSaveKey imageName:@"ezshare_code_save_icon"]];
        _views = views;
    }
    return _views;
}

@end


@implementation EZShareQRCodeItem

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat h = self.bounds.size.width;
    CGFloat w = self.bounds.size.width;
    CGFloat x = 0;
    CGFloat y = 0;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 63, self.bounds.size.width, 12);
}
@end
