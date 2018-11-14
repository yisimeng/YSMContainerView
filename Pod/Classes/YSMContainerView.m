//
//  YSMContainerView.m
//  YSMKit_Example
//
//  Created by duanzengguang on 2018/11/14.
//  Copyright © 2018年 yisimeng. All rights reserved.
//

#import "YSMContainerView.h"
#import "UIView+YSMCategory.h"

// TODO: 定位移除控制器

static NSString * kContainerViewCellReuseId = @"kContainerViewCellReuseId";

@interface YSMContainerView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray * viewControllers;

@end

@implementation YSMContainerView

#pragma mark -- Initialization

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
    }
    return self;
}

- (void)initialization{
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.containerHeaderView];
}

- (void)dealloc{
    
}

#pragma mark -- private
- (void)_layoutViewControllers{
    CGRect headerFrame = self.containerHeaderView.frame;
    // 可以判断header的位置是否在最顶部，然后判断当前的偏移量，可以保持向下滑动很多之后横向切换不该边contentoffset
    CGPoint contentOffset = CGPointMake(0, -(headerFrame.origin.y - (-180)));
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController<YSMContainrerChildControllerDelegate> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.childScrollView.contentOffset = contentOffset;
    }];
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfViewControllersInContainerView:)]) {
        count = [self.dataSource numberOfViewControllersInContainerView:self];
        return count;
    }
    self.viewControllers = [NSMutableArray arrayWithCapacity:count];
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kContainerViewCellReuseId forIndexPath:indexPath];
    [cell.contentView ysm_removeAllSubviews];
    
    UIViewController<YSMContainrerChildControllerDelegate> * childViewController = [self.dataSource containerView:self viewControllerAtIndex:indexPath.row];
    UIScrollView * childScrollView = childViewController.childScrollView;
    // 添加到数组，addChildViewController, 添加观察者
    if (![self.viewControllers containsObject:childViewController]) {
        [self.ysm_viewController addChildViewController:childViewController];
        [self.viewControllers addObject:childViewController];

        // TODO: 控制偏移的高度
        UIEdgeInsets contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
        childScrollView.contentInset = contentInset;
        childScrollView.scrollIndicatorInsets = contentInset;
        
        [childScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    // TODO: 设置偏移量
    [cell.contentView addSubview:childScrollView];
    return cell;
}

#pragma mark -- Horizontal Scroll
#pragma mark -- UICollectionViewDelegate & UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // TODO: 滑动时控制相邻两个scrollView的偏移量与当前一致
    [self _layoutViewControllers];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 水平移动时 控制header水平同步位移
    CGRect headerFrame = self.containerHeaderView.frame;
    headerFrame.origin.x = scrollView.contentOffset.x;
    self.containerHeaderView.frame = headerFrame;
}

#pragma mark -- Vertical Scroll
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (![keyPath isEqualToString:@"contentOffset"]) {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
    
    CGRect headerFrame = self.containerHeaderView.frame;
    // TODO: 可以设置header悬停位置
    if (contentOffset.y < -180) {
        // header 完全显示后，下拉
        headerFrame.origin.y = 0;
        CGFloat height = (-180) - contentOffset.y;
        headerFrame.size.height = height + 180;
    }else if (contentOffset.y <= 0){
        // header 初始位置到完全隐藏之间
        headerFrame.origin.y = -(contentOffset.y - (-180));
        headerFrame.size.height = 180;
    }else{
        headerFrame.origin.y = -180;
    }
    self.containerHeaderView.frame = headerFrame;
}

#pragma mark -- Getter & Setter

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = self.bounds.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kContainerViewCellReuseId];
    }
    return _collectionView;
}

- (UIView *)containerHeaderView{
    if (_containerHeaderView == nil) {
        _containerHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 180)];
        _containerHeaderView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    }
    return _containerHeaderView;
}

@end
