//
//  EZShareView.m
//  EZShareManager
//
//  Created by 陈诚 on 2021/1/15.
//

#import "EZShareView.h"
#import "Masonry.h"
#import "UIColor+EZShareManagerHelper.h"
#import "UIImage+EZBundleHelp.h"
#import "EZShareCollectionCell.h"
#import "EZShareUIModel.h"
#import "EZShareManager.h"
#import "CTMediator.h"

static NSInteger const viewCornerRadius = 10;

@interface EZShareView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, assign) CGFloat bgViewHeight;
@end

@implementation EZShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.delegate = self;
        [tap addTarget:self action:@selector(viewBgTapGesture:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)setOnlyShareView:(BOOL)onlyShareView {
    _onlyShareView = onlyShareView;
    [self initSubviews];
}

#pragma mark - private
- (void)initSubviews {
    
    self.bgViewHeight = self.onlyShareView ? 160.0 + 50.0 + 15.0 : 240.0 + 50.0 + 15.0;
    
    _bgView = [UIView new];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = viewCornerRadius;
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    _bgView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.bgViewHeight);
    
    [_bgView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgView).offset(10);
        make.right.mas_equalTo(_bgView).offset(-10);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(_bgView);
    }];
    
    [_bgView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgView).offset(10);
        make.right.mas_equalTo(_bgView).offset(-10);
        make.bottom.mas_equalTo(self.cancelBtn.mas_top).offset(-15);
        make.height.mas_equalTo(self.onlyShareView?160.0f:240.0f);//两行或三行
    }];
}

- (void)reloadDataWithItems:(NSMutableArray *)items {
    [self.datas addObjectsFromArray:items];
    [self.collectionView reloadData];
}

/// 展示
- (void)show {
    __weak typeof(self)wself = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        wself.bgView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - wself.bgViewHeight, [UIScreen mainScreen].bounds.size.width, wself.bgViewHeight);
        wself.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }completion:^(BOOL finished) {
        
    }];
}

/// 隐藏
- (void)hide {
    __weak typeof(self)wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        wself.bgView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.bgViewHeight);
        wself.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }completion:^(BOOL finished) {
        [wself removeFromSuperview];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EZShareCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EZShareCollectionCell class]) forIndexPath:indexPath];
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    EZShareUIModel *model = self.datas[indexPath.row];
    
    EZShareCollectionCell *cell = (EZShareCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (model.type == EZShareUIViewTypeXunliao || model.type == EZShareUIViewTypeHaoyouquan) {
        [self hide];
        return;
    }
    
    if (model.type == EZShareUIViewTypeQQZone || model.type ==  EZShareUIViewTypeQQ || model.type == EZShareUIViewTypeWechatSession || model.type == EZShareUIViewTypeWechatTimeline || model.type == EZShareUIViewTypeSinaWeibo) {
        [[EZShareManager shareInstance] shareToPlatformWithType:model.type];
    }
    
    if (model.type == EZShareUIViewTypeCopy) {//复制
        [[EZShareManager shareInstance] copyLinkUrl];
    }
    
    if (model.type == EZShareUIViewTypeSms) {//短信
        [[EZShareManager shareInstance] sendSms];
    }
    
    if (model.type == EZShareUIViewTypeCode) {//二维码分享
        [[EZShareManager shareInstance] codeShare];
    }
    
    if (model.type == EZShareUIViewTypeReport) {//举报
        UIViewController *reportVC = [[CTMediator sharedInstance] performTarget:@"ArticleDetail" action:@"detailReport" params:@{@"newsId":self.newsId?:@""} shouldCacheTarget:YES];
        [self hide];
        [[self findCurrentViewController].navigationController pushViewController:reportVC animated:YES];
        return;
    }
    
    if (model.type == EZShareUIViewTypeCollection) {//收藏
        cell.iconImageView.image = [UIImage bundleKey:@"EZShareManager" imageName:@"ezshare_收藏选中"];
        self.isCollect = YES;
        [[CTMediator sharedInstance] performTarget:@"ArticleDetail" action:@"collectSelect" params:@{@"newsId":self.newsId,@"collectModel":self.collectModel?:@""} shouldCacheTarget:YES];
    }
    
    if (model.type == EZShareUIViewTypeCollectionSelect) {//收藏选中
        cell.iconImageView.image = [UIImage bundleKey:@"EZShareManager" imageName:@"ezshare_收藏"];
        self.isCollect = NO;
        [[CTMediator sharedInstance] performTarget:@"ArticleDetail" action:@"collectSelect" params:@{@"newsId":self.newsId,@"collectModel":self.collectModel?:@""} shouldCacheTarget:YES];
    }
    
    if (model.type == EZShareUIViewTypeLoseIntrest) {//不感兴趣
        [[CTMediator sharedInstance] performTarget:@"ArticleDetail" action:@"loseInterest" params:@{@"newsId":self.newsId} shouldCacheTarget:YES];
    }
    
    if (model.type == EZShareUIViewTypeFontSet) {//字体设置
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[CTMediator sharedInstance] performTarget:@"ArticleDetail" action:@"showFontSetView" params:nil shouldCacheTarget:YES];
        });
    }
    
    if (model.type == EZShareUIViewTypeThemeNightTime) {//夜间模式
        [cell.iconImageView setImage:[UIImage bundleKey:@"EZShareManager" imageName:@"ezshare_日间模式"]];
        cell.titleLabel.text = @"日间模式";
        [[CTMediator sharedInstance] performTarget:@"ArticleDetail" action:@"dayOrNightModeSwitch" params:nil shouldCacheTarget:YES];
    }
    
    if (model.type == EZShareUIViewTypeThemeDayTime) {//日间模式
        [cell.iconImageView setImage:[UIImage bundleKey:@"EZShareManager" imageName:@"ezshare_夜间模式"]];
        cell.titleLabel.text = @"夜间模式";
        [[CTMediator sharedInstance] performTarget:@"ArticleDetail" action:@"dayOrNightModeSwitch" params:nil shouldCacheTarget:YES];
    }
    
    if (model.type == EZShareUIViewTypeTop) {//顶
        if (!self.isTrample) {//没有踩过
            cell.iconImageView.image = [UIImage bundleKey:@"EZShareManager" imageName:@"ezshare_顶_select"];
            self.isLike = YES;
            cell.titleLabel.text = [NSString stringWithFormat:@"顶%ld",[self.topCount integerValue] + 1];
            self.topCount = [NSString stringWithFormat:@"%ld",[self.topCount integerValue] + 1];
            [self handleTopOrDownAction];
        }
    }
    
    if (model.type == EZShareUIViewTypeTopSelect) {//顶选中
        cell.iconImageView.image = [UIImage bundleKey:@"EZShareManager" imageName:@"ezshare_顶"];
        self.isLike = NO;
        cell.titleLabel.text = [NSString stringWithFormat:@"顶%ld",[self.topCount integerValue] - 1];
        self.topCount = [NSString stringWithFormat:@"%ld",[self.topCount integerValue] - 1];
        [self handleTopOrDownAction];
    }
    
    if (model.type == EZShareUIViewTypeDown) {//踩
        if (!self.isLike) {
            cell.iconImageView.image = [UIImage bundleKey:@"EZShareManager" imageName:@"ezshare_踩_select"];
            self.isTrample = YES;
            cell.titleLabel.text = [NSString stringWithFormat:@"踩%ld",[self.trampleCount integerValue] + 1];
            self.trampleCount = [NSString stringWithFormat:@"%ld",[self.trampleCount integerValue] + 1];
            [self handleTopOrDownAction];
        }
    }
    
    if (model.type == EZShareUIViewTypeDownSelect) {//踩选中
        cell.iconImageView.image = [UIImage bundleKey:@"EZShareManager" imageName:@"ezshare_踩"];
        self.isTrample = NO;
        cell.titleLabel.text = [NSString stringWithFormat:@"踩%ld",[self.trampleCount integerValue] - 1];
        self.trampleCount = [NSString stringWithFormat:@"%ld",[self.trampleCount integerValue] - 1];
        [self handleTopOrDownAction];
    }
    
    //关闭
    [self hide];
    
}

- (void)handleTopOrDownAction {
    [[CTMediator sharedInstance] performTarget:@"ArticleDetail" action:@"trample" params:@{@"newsId":self.newsId,@"homeModel":self.homeModel?:@"",@"collectModel":self.collectModel?:@"",@"isAlreadyLiked":@(self.isLike),@"topCount":self.topCount,@"trampleCount":self.trampleCount} shouldCacheTarget:YES];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 20) / 5, ([UIScreen mainScreen].bounds.size.width - 20) / 5);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.layer.masksToBounds = YES;
        _collectionView.layer.cornerRadius = viewCornerRadius;
        [_collectionView registerClass:[EZShareCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([EZShareCollectionCell class])];
    }
    return _collectionView;
}

- (void)cancelBtnAction:(UIButton *)sender {
    [self hide];
}

- (void)viewBgTapGesture:(UITapGestureRecognizer *)recognizer {
    [self hide];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    //子视图禁止父视图的手势事件
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gestureRecognizer;
    
    CGPoint point = [tap locationInView:self.collectionView];
    
    BOOL isIn = CGRectContainsPoint(self.frame,point);
    
    return !isIn;
    
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.cornerRadius = viewCornerRadius;
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIViewController *)findCurrentViewController
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    
    while (true) {
        
        if (topViewController.presentedViewController) {
            
            topViewController = topViewController.presentedViewController;
            
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            
            topViewController = [(UINavigationController *)topViewController topViewController];
            
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
            
        } else {
            break;
        }
    }
    return topViewController;
}
@end
