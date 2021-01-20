//
//  EZShareQRCodeView.h
//  EZShareManager
//
//  Created by 陈诚 on 2021/1/20.
//

#import <UIKit/UIKit.h>
#import "EZShareGloabalModel.h"

NS_ASSUME_NONNULL_BEGIN

@class EZShareQRCodeGoodsContainerView, EZShareQRCodeContainerView, EZShareQRCodeShopContainerView, EZShareQRCodeGeneralContainerView, EZShareQRCodeItem, EZShareQRCodeItemContainerView;
@interface EZShareQRCodeView : UIView

- (instancetype)initWithModel:(EZShareItemModel *)model;

- (void)show;

- (void)hide;
@end

@interface EZShareQRCodeContainerView : UIView

@property (nonatomic, strong) EZShareItemModel * model;

@property (nonatomic, strong) UIImageView * logoImageView;

@property (nonatomic, strong) UIImageView * codeImageView;

@property (nonatomic, strong) UIImageView * showImageView;

@property (nonatomic, strong) UIImageView * codeContainerImageView;
@end

@interface EZShareQRCodeGoodsContainerView : EZShareQRCodeContainerView

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UILabel * titleLabel;

@end

@interface EZShareQRCodeShopContainerView : EZShareQRCodeContainerView

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UILabel * contentLabel;

@property (nonatomic, strong) UIButton * fansLabel;

@property (nonatomic, strong) UIButton * scoreLabel;

@property (nonatomic, strong) NSArray * imageViews;

@end

@interface EZShareQRCodeGeneralContainerView : EZShareQRCodeContainerView

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UILabel * contentLabel;

@end


@interface EZShareQRCodeItemContainerView : UIView

@property (nonatomic, strong) NSArray * views;

@property (nonatomic, copy) void (^buttonEventBlock)(NSString *title);

@end

@interface EZShareQRCodeItem : UIButton

@end

NS_ASSUME_NONNULL_END
