//
//  YSMHeaderView.m
//  YSMContainerView
//
//  Created by duanzengguang on 2018/11/19.
//

#import "YSMHeaderView.h"

@interface YSMHeaderView ()

@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) NSMutableArray<UILabel *>* titleLabels;

@end

@implementation YSMHeaderView{
    NSInteger _currentIndex;
}

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
    [self addSubview:self.titleView];
}

- (void)setTitles:(NSMutableArray<NSString *> *)titles{
    _titles = titles;
    self.titleLabels = [NSMutableArray arrayWithCapacity:titles.count];
    [self setupSubViews];
}

- (void)setupSubViews{
    CGFloat titleWidth = self.frame.size.width/self.titles.count;
    CGSize titleSize = CGSizeMake(titleWidth, self.titleView.frame.size.height);
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = {CGPointMake(idx*titleWidth, 0),titleSize};
        UILabel * label = [[UILabel alloc] initWithFrame:frame];
        label.text = obj;
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.tag = idx;
        [self.titleLabels addObject:label];
        [self.titleView addSubview:label];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelDidTap:)];
        [label addGestureRecognizer:tap];
        if (idx == 0) {
            self->_currentIndex = 0;
            label.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
        }
    }];
}


- (void)titleLabelDidTap:(UITapGestureRecognizer *)tap{
    NSInteger selectIndex = tap.view.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didSelectTitleAtIndex:)]) {
        [self.delegate headerView:self didSelectTitleAtIndex:selectIndex];
    }
    [self didSelectTitleIndex:selectIndex];
}

- (void)didSelectTitleIndex:(NSInteger)selectIndex{
    UILabel *currentLabel = self.titleLabels[_currentIndex];
    currentLabel.transform = CGAffineTransformIdentity;
    
    UILabel * selectLabel = self.titleLabels[selectIndex];
    selectLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
    _currentIndex = selectIndex;
}

- (UIView *)titleView{
    if (_titleView == nil) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-44, CGRectGetWidth(self.frame), 44)];
        _titleView.backgroundColor = [UIColor lightGrayColor];
        _titleView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _titleView;
}

@end
