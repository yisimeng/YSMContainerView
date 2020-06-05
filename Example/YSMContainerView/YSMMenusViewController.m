//
//  YSMMenusViewController.m
//  YSMContainerView_Example
//
//  Created by duanzengguang on 2020/3/17.
//  Copyright © 2020 yisimeng. All rights reserved.
//

#import "YSMMenusViewController.h"

static NSString * const kMenusCategoryCellId = @"kMenusCategoryCellId";
static NSString * const kMenusDetailCellId = @"kMenusDetailCellId";

@interface YSMMenusViewController ()<UITableViewDataSource>

@property (nonatomic, strong) UITableView * categoryTableView;
@property (nonatomic, strong) UITableView * detailTableView;

@end

@implementation YSMMenusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.categoryTableView];
    [self.view addSubview:self.detailTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.categoryTableView]) {
        return 10;
    }
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.categoryTableView]) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMenusCategoryCellId forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"分类 %ld", indexPath.row];
        return cell;
    }else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMenusDetailCellId forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"详情 %ld", indexPath.row];
        return cell;
    }
}

- (UITableView *)categoryTableView{
    if (_categoryTableView == nil) {
        CGRect frame = CGRectMake(0, 0, 100, self.view.frame.size.height);
        _categoryTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _categoryTableView.dataSource = self;
        _categoryTableView.rowHeight = 50;
        [_categoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kMenusCategoryCellId];
    }
    return _categoryTableView;
}
- (UITableView *)detailTableView{
    if (_detailTableView == nil) {
        CGRect frame = CGRectMake(100, 0, self.view.frame.size.width-100, self.view.frame.size.height);
        _detailTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _detailTableView.dataSource = self;
        _detailTableView.rowHeight = 100;
        [_detailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kMenusDetailCellId];
    }
    return _detailTableView;
}

#pragma mark - YSMContainrerChildControllerDelegate
- (UIScrollView *)childScrollView{
    return self.detailTableView;
}

@end
