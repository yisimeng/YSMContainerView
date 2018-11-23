//
//  YSMContainerView.m
//  YSMKit_Example
//
//  Created by duanzengguang on 2018/11/14.
//  Copyright © 2018年 yisimeng. All rights reserved.
//

#import "YSMContainerView.h"
#import "UIView+YSMCategory.h"
#import "YSMHeaderView.h"
static NSString * const kContainerViewCellReuseId = @"kContainerViewCellReuseId";

@interface YSMContainerView ()<UICollectionViewDataSource, UICollectionViewDelegate,YSMHeaderDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) YSMHeaderView * headerView;

@property (nonatomic, strong) NSMutableArray<UIViewController<YSMContainrerChildControllerDelegate> *> * viewControllers;

@end

@implementation YSMContainerView{
    CGFloat _headerViewHeight;
}

#pragma mark - Initialization

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
    self.headerHangingHeight = 0;
    self.headerView = [[YSMHeaderView alloc] init];
    self.headerView.delegate = self;
    self.headerView.clipsToBounds = YES;
    
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.headerView];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(headerViewForContainerView:)]) {
        UIView * header = [self.dataSource headerViewForContainerView:self];
        header.frame = header.bounds;
        [self.headerView insertSubview:header atIndex:0];
        self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(header.frame)+44);
        header.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        _headerViewHeight = CGRectGetHeight(self.headerView.frame);
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(titlesForContainerView:)]) {
        self.headerView.titles = (NSMutableArray *)[self.dataSource titlesForContainerView:self];
    }
}

- (void)dealloc{
    [self _removeAllObserver];
}

#pragma mark - public

// 移除控制器
- (BOOL)removeChildController:(UIViewController *)viewController{
    return NO;
}
- (BOOL)removeChildControllerAtIndex:(NSInteger)index{
    return NO;
}

#pragma mark - private

- (void)_removeAllObserver{
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController<YSMContainrerChildControllerDelegate> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.childScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfViewControllersInContainerView:)]) {
        count = [self.dataSource numberOfViewControllersInContainerView:self];
    }
    self.viewControllers = [NSMutableArray arrayWithCapacity:count];
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kContainerViewCellReuseId forIndexPath:indexPath];
    
    UIViewController<YSMContainrerChildControllerDelegate> * childViewController = [self.dataSource containerView:self viewControllerAtIndex:indexPath.row];
    UIScrollView * childScrollView = childViewController.childScrollView;
    // 添加到数组，addChildViewController, 添加观察者
    if (![self.viewControllers containsObject:childViewController]) {
        [self.ysm_viewController addChildViewController:childViewController];
        [self.viewControllers addObject:childViewController];
        
        if (@available(iOS 11.0, *)) {
            childScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            childViewController.automaticallyAdjustsScrollViewInsets = NO;
        }
        childScrollView.frame = self.bounds;
        
        UIEdgeInsets contentInset = UIEdgeInsetsMake(_headerViewHeight, 0, 0, 0);
        childScrollView.contentInset = contentInset;
        childScrollView.scrollIndicatorInsets = contentInset;
        
        [childScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    // 滑动时控制将要显示的scrollView的偏移量与当前一致
    UIViewController<YSMContainrerChildControllerDelegate> * childViewController = [self.dataSource containerView:self viewControllerAtIndex:indexPath.row];
    UIScrollView * childScrollView = childViewController.childScrollView;
    CGRect headerFrame = self.headerView.frame;
    CGPoint contentOffset = CGPointMake(0, -(headerFrame.origin.y - (-_headerViewHeight)));
    
    // 为使child controller 的生命周期正常，所以没在cellforItem里使用
    if (self.delegate && [self.delegate respondsToSelector:@selector(containerView:willScrollToChildControllerIndex:)]) {
        [self.delegate containerView:self willScrollToChildControllerIndex:indexPath.row];
    }
    [cell.contentView addSubview:childScrollView];
    childScrollView.contentOffset = contentOffset;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    // 为使child controller 的生命周期正常，所以没在cellforItem里使用
    [cell.contentView ysm_removeAllSubviews];
}


#pragma mark - Horizontal Scroll： UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 水平移动时 控制header水平同步位移
    CGRect headerFrame = self.headerView.frame;
    headerFrame.origin.x = scrollView.contentOffset.x;
    self.headerView.frame = headerFrame;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    if (self.delegate && [self.delegate respondsToSelector:@selector(containerView:didScrollToChildControllerIndex:)]) {
        [self.delegate containerView:self didScrollToChildControllerIndex:currentIndex];
    }
    [self.headerView didSelectTitleIndex:currentIndex];
}

#pragma mark - Vertical Scroll
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (![keyPath isEqualToString:@"contentOffset"]) {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
    
    CGRect headerFrame = self.headerView.frame;
    // TODO: 可以设置header悬停位置
    if (contentOffset.y < -_headerViewHeight) {
        // header 完全显示后，下拉
        headerFrame.origin.y = 0;
        CGFloat height = (-_headerViewHeight) - contentOffset.y;
        headerFrame.size.height = height + _headerViewHeight;
    }else if (contentOffset.y <= -self.headerHangingHeight){
        // header 初始位置到悬停位置之间
        headerFrame.origin.y = -(_headerViewHeight + contentOffset.y);
        headerFrame.size.height = _headerViewHeight;
    }else{
        headerFrame.origin.y = self.headerHangingHeight -_headerViewHeight;
    }
    self.headerView.frame = headerFrame;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(containerView:didScrollContentOffset:)]) {
        contentOffset.y = contentOffset.y + _headerViewHeight;
        [self.delegate containerView:self didScrollContentOffset:contentOffset];
    }
}

#pragma mark - YSMHeaderDelegate
- (void)headerView:(YSMHeaderView *)headerView didSelectTitleAtIndex:(NSInteger)index{
    CGPoint contentOffset = CGPointMake(index*self.collectionView.bounds.size.width, 0);
    [self.collectionView setContentOffset:contentOffset animated:YES];
}

#pragma mark - Getter & Setter

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
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kContainerViewCellReuseId];
    }
    return _collectionView;
}

@end
