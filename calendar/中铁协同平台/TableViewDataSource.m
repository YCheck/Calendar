//
//  TableViewDataSource.m
//  同约同往
//
//  Created by admin on 15/7/31.
//  Copyright (c) 2015年 YCheng. All rights reserved.
//

#import "TableViewDataSource.h"
@interface TableViewDataSource ()
// 当前数据数组
@property (nonatomic, strong) NSArray *items;
// 当前cell重用标示
@property (nonatomic, copy) NSString *cellIdentifier;
// 当前配置cell的block
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@end

@implementation TableViewDataSource
- (id)init
{
    return nil;
}


- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        _items = anItems;
        _cellIdentifier = aCellIdentifier;
        _configureCellBlock = [aConfigureCellBlock copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[(NSUInteger)indexPath.row];
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    // 获取当前某一行的对象
    id item = [self itemAtIndexPath:indexPath];
    // 通过调用该block配置当前cell显示的内容
    self.configureCellBlock(cell, item);
    return cell;
}

#pragma mark UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    // 获取当前某一行的对象
    id item = [self itemAtIndexPath:indexPath];
    // 通过调用该block配置当前cell显示的内容
    self.configureCellBlock(cell, item);
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
    }
    return reusableview;
}

@end
