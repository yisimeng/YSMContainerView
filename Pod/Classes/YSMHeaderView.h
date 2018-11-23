//
//  YSMHeaderView.h
//  YSMContainerView
//
//  Created by duanzengguang on 2018/11/19.
//

#import <UIKit/UIKit.h>

@class YSMHeaderView;
@protocol YSMHeaderDelegate<NSObject>

- (void)headerView:(YSMHeaderView *)headerView didSelectTitleAtIndex:(NSInteger)index;

@end

@interface YSMHeaderView : UIView

@property (nonatomic, weak) id<YSMHeaderDelegate>delegate;

@property (nonatomic, copy) NSMutableArray<NSString *> * titles;

- (void)didSelectTitleIndex:(NSInteger)index;

@end
