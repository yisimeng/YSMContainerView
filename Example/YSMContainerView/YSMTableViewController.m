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

@implementation YSMTableViewController
@synthesize childScrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"aa"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aa" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行······", indexPath.row];
    return cell;
}

- (UIScrollView *)childScrollView{
    return self.tableView;
}


@end
