//
//  TableViewDataSource.h
//  同约同往
//
//  Created by admin on 15/7/31.
//  Copyright (c) 2015年 YCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// 用于配置当前Cell的数据
// id cell表示什么类型的Cell
// id item表示什么类型的模型对象
typedef void (^TableViewCellConfigureBlock)(id cell, id item);
@interface TableViewDataSource : NSObject<UITableViewDataSource, UICollectionViewDataSource>
@property (nonatomic,retain) NSDictionary *reusableViewDic;
// 参数1：用以数据源的控制，主要是通过改数组来控制当前tableView或者collectionView显示Cell的数量
// 参数2：当前需要显示的cell的重用标示
// 参数3：用以配置当前cell数据的block
- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

// 通过indexPath来获取当前具体的某一个对象
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
@end
