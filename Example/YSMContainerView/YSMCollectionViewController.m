//
//  YSMCollectionViewController.m
//  YSMContainerView_Example
//
//  Created by duanzengguang on 2018/11/15.
//  Copyright © 2018年 yisimeng. All rights reserved.
//

#import "YSMCollectionViewController.h"

@interface YSMCollectionViewController ()

@end

@implementation YSMCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - YSMContainrerChildControllerDelegate
- (UIScrollView *)childScrollView{
    return self.collectionView;
}

@end
