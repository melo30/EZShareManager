//
//  EZShareCollectionCell.h
//  EZShareManager_Example
//
//  Created by 陈诚 on 2021/1/18.
//  Copyright © 2021 melo30. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZShareUIModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EZShareCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) EZShareUIModel *model;

@end

NS_ASSUME_NONNULL_END
