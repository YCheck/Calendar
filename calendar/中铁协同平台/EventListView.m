//
//  EventListView.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/20.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "EventListView.h"
#import "EventListTableViewCell.h"
#import "EventModel.h"
@interface EventListView()<UITableViewDelegate>
{
    UITableView *_tableView;
}


@end
@implementation EventListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        [self addSubview:_tableView];
        
    }
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = [[NSMutableArray alloc] initWithArray:dataSource];
    TableViewCellConfigureBlock configureCell = ^(EventListTableViewCell *cell, EventModel *model) {
        [cell configureForCell:model];
    };
    [_tableView registerNib:GetNIB(@"EventListTableViewCell") forCellReuseIdentifier:@"eventListTableViewCell"];
    self.arrayDataSource = [[TableViewDataSource alloc] initWithItems:self.dataSource
                                                       cellIdentifier:@"eventListTableViewCell"
                                                   configureCellBlock:configureCell];
    
    _tableView.dataSource = self.arrayDataSource;
    [_tableView reloadData];
}

#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
