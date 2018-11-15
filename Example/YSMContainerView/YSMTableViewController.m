//
//  YSMTableViewController.m
//  YSMKit_Example
//
//  Created by duanzengguang on 2018/11/13.
//  Copyright © 2018年 yisimeng. All rights reserved.
//

#import "YSMTableViewController.h"

@interface YSMTableViewController ()

@end

static NSString * const kTableViewControllerCellId = @"kTableViewControllerCellId";

@implementation YSMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewControllerCellId];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewControllerCellId forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"TableView Controller 第%ld行", indexPath.row];
    return cell;
}

#pragma mark - YSMContainrerChildControllerDelegate

- (UIScrollView *)childScrollView{
    return self.tableView;
}

@end
