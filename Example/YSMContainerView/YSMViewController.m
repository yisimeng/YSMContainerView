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


@interface YSMViewController ()<YSMContainerViewDataSource>

@property (nonatomic, strong) YSMContainerView * containerView;
@property (nonatomic, strong) NSArray * viewControllers;

@end

@implementation YSMViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.containerView = [[YSMContainerView alloc] initWithFrame:self.view.bounds];
    self.containerView.dataSource = self;
    [self.view addSubview:self.containerView];
    
    YSMTableViewController * table1 = [[YSMTableViewController alloc] initWithStyle:UITableViewStylePlain];
    YSMTableViewController * table2 = [[YSMTableViewController alloc] initWithStyle:UITableViewStylePlain];
    YSMTableViewController * table3 = [[YSMTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.viewControllers = @[table1,table2,table3];
}

- (UIViewController<YSMContainrerChildControllerDelegate> *)containerView:(YSMContainerView *)containerView viewControllerAtIndex:(NSInteger)index {
    UIViewController<YSMContainrerChildControllerDelegate> * vc = self.viewControllers[index];
    return vc;
}

- (NSInteger)numberOfViewControllersInContainerView:(YSMContainerView *)containerView {
    return self.viewControllers.count;
}



@end
