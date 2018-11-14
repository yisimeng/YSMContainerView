//
//  YSMContainerView.h
//  YSMKit_Example
//
//  Created by duanzengguang on 2018/11/14.
//  Copyright © 2018年 yisimeng. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 Child View Controller
 */
@protocol YSMContainrerChildControllerDelegate<NSObject>
/**
 UIScrollView 及其子类
 */
@property (nonatomic) UIScrollView * childScrollView;
@end

@class YSMContainerView;
@protocol YSMContainerViewDelegate<NSObject>
@end

@protocol YSMContainerViewDataSource<NSObject>
/**
 Child View Controller 个数

 @param containerView containerView
 @return number
 */
- (NSInteger)numberOfViewControllersInContainerView:(YSMContainerView *)containerView;

@required
/**
 Child View Controller 入参

 @param containerView containerView
 @param index index
 @return ViewController
 */
- (UIViewController<YSMContainrerChildControllerDelegate> *)containerView:(YSMContainerView *)containerView viewControllerAtIndex:(NSInteger)index;

@end

@interface YSMContainerView : UIView

@property (nonatomic, strong) UIView * containerHeaderView;

@property (nonatomic, weak, nullable) id <YSMContainerViewDelegate> delegate;

@property (nonatomic, weak, nullable) id <YSMContainerViewDataSource> dataSource;

@end
