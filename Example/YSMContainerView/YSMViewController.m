//
//  YSMViewController.m
//  YSMContainerView
//
//  Created by yisimeng on 11/14/2018.
//  Copyright (c) 2018 yisimeng. All rights reserved.
//

#import "YSMViewController.h"
#import <YSMContainerView/YSMContainerView.h>
#import "YSMTableViewController.h"
#import "YSMTableViewController1.h"
#import "YSMCollectionViewController.h"
@interface YSMViewController ()<YSMContainerViewDataSource,YSMContainerViewDelegate>

@property (nonatomic, strong) YSMContainerView * containerView;
@property (nonatomic, strong) NSArray * viewControllers;

@end

@implementation YSMViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.containerView = [[YSMContainerView alloc] initWithFrame:self.view.bounds];
    self.containerView.dataSource = self;
    self.containerView.delegate = self;
    self.containerView.headerHangingHeight = 64;
    [self.view addSubview:self.containerView];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 150);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    
    YSMTableViewController * child1 = [[YSMTableViewController alloc] initWithStyle:UITableViewStylePlain];
    YSMTableViewController1 * child2 = [[YSMTableViewController1 alloc] init];
    YSMCollectionViewController * child3 = [[YSMCollectionViewController alloc] initWithCollectionViewLayout:layout];

    self.viewControllers = @[child1,child2,child3];
}

- (NSArray<NSString *> *)titlesForContainerView:(YSMContainerView *)containerView{
    return @[@"第一个",@"第二个",@"第三"];
}

- (void)containerView:(YSMContainerView *)containerView didScrollContentOffset:(CGPoint)contentOffset{
}

- (NSInteger)numberOfViewControllersInContainerView:(YSMContainerView *)containerView {
    return self.viewControllers.count;
}
- (UIViewController<YSMContainrerChildControllerDelegate> *)containerView:(YSMContainerView *)containerView viewControllerAtIndex:(NSInteger)index {
    UIViewController<YSMContainrerChildControllerDelegate> * childController = self.viewControllers[index];
    return childController;
}


- (UIView *)headerViewForContainerView:(YSMContainerView *)containerView{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    headerView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:headerView.bounds];
    imageView.image = [UIImage imageNamed:@"headerImage"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [headerView addSubview:imageView];
    return headerView;
}


@end
