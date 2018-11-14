//
//  UIView+YSMCategory.m
//  YSMContainerView
//
//  Created by duanzengguang on 2018/11/14.
//

#import "UIView+YSMCategory.h"

@implementation UIView (YSMCategory)

- (void)ysm_removeAllSubviews{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

- (UIViewController * _Nonnull )ysm_viewController{
    for (UIView* next = [self superview];next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
