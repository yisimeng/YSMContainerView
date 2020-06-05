//
//  YSMCustomViewController.m
//  YSMContainerView_Example
//
//  Created by duanzengguang on 2018/11/15.
//  Copyright © 2018年 yisimeng. All rights reserved.
//

#import "YSMTableViewController1.h"

static NSString * const kTableViewController1CellId = @"kTableViewController1CellId";

@interface YSMTableViewController1 ()<UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation YSMTableViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tableView.contentOffset = CGPointMake(0, -244);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kTableViewController1CellId forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"View Controller 第%ld行", indexPath.row];
    return cell;
}


- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewController1CellId];
    }
    return _tableView;
}

#pragma mark - YSMContainrerChildControllerDelegate
- (UIScrollView *)childScrollView{
    return self.tableView;
}

@end
