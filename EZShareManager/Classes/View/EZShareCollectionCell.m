//
//  EZShareCollectionCell.m
//  EZShareManager_Example
//
//  Created by 陈诚 on 2021/1/18.
//  Copyright © 2021 melo30. All rights reserved.
//

#import "EZShareCollectionCell.h"
#import "UIColor+EZShareManagerHelper.h"
#import "UIImage+EZBundleHelp.h"

@implementation EZShareCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        CGFloat center_x = frame.size.width / 2;
        CGFloat size_w = 30.5;
        CGFloat size_h = 29;
        CGFloat center_y = frame.size.height / 2 - 10;
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.center = CGPointMake(center_x, center_y);
        _iconImageView.bounds = CGRectMake(0, 0, size_w, size_h);
        [self.contentView addSubview:_iconImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, center_y + 22, frame.size.width, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_titleLabel];
        
    }
    return self;
}

- (void)setModel:(EZShareUIModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    [_iconImageView setImage:[UIImage bundleKey:@"EZShareManager" imageName:model.icon]];
}

@end
