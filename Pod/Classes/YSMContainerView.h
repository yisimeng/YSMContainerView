//
//  YSMContainerView.h
//  YSMKit_Example
//
//  Created by duanzengguang on 2018/11/14.
//  Copyright © 2018年 yisimeng. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 Child View Controller delegate
 */
@protocol YSMContainrerChildControllerDelegate<NSObject>
@required
/**
 child controller scroll view

 @return scroll view
 */
- (UIScrollView *)childScrollView;
@end

@class YSMContainerView;

@protocol YSMContainerViewDelegate<NSObject>
@optional
#pragma mark - Horizontal Scroll
/**
 Horizontal will scroll to controller index

 @param containerView containerView
 @param index index
 */
- (void)containerView:(YSMContainerView *)containerView willScrollToChildControllerIndex:(NSInteger)index;
/**
 Horizontal did scroll to controller index

 @param containerView containerView
 @param index index
 */
- (void)containerView:(YSMContainerView *)containerView didScrollToChildControllerIndex:(NSInteger)index;

#pragma mark - Vertical Scroll
/**
 Vertical did scroll contentOffset

 @param containerView containerView
 @param contentOffset contentOffset
 */
- (void)containerView:(YSMContainerView *)containerView didScrollContentOffset:(CGPoint)contentOffset;
@end

@protocol YSMContainerViewDataSource<NSObject>

@required
/**
 Child View Controller count

 @param containerView containerView
 @return number
 */
- (NSInteger)numberOfViewControllersInContainerView:(YSMContainerView *)containerView;
/**
 Child View Controller
 
 @param containerView containerView
 @param index index
 @return ViewController
 */
- (UIViewController<YSMContainrerChildControllerDelegate> *)containerView:(YSMContainerView *)containerView viewControllerAtIndex:(NSInteger)index;

@optional
/**
 Header View

 @param containerView containerView
 @return header View
 */
- (UIView *)headerViewForContainerView:(YSMContainerView *)containerView;

@end

@interface YSMContainerView : UIView

@property (readonly) NSMutableArray * viewControllers;

@property (readonly) UIView * containerHeaderView;

@property (nonatomic, weak, nullable) id <YSMContainerViewDelegate> delegate;

@property (nonatomic, weak, nullable) id <YSMContainerViewDataSource> dataSource;

- (BOOL)removeChildControllerAtIndex:(NSInteger)index;

- (BOOL)removeChildController:(UIViewController *)viewController;



@end
