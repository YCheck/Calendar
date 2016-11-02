//
//  ViewController.h
//  test
//
//  Created by 张鹏 on 14-4-30.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScrollViewType) {
    ScrollViewType_DefaultViewController,
    ScrollViewType_MailViewController,
};

@interface CycleScrollViewController : UIViewController

@property (nonatomic,retain) NSString *titleName;
@property (nonatomic,assign) int index;
@property (nonatomic,retain) UIView *animation;

- (instancetype)initWithMixids:(NSArray *)mixId currentIndex:(int)index;

- (instancetype)initWithMixIDs:(NSArray *)mixIDs
                  currentIndex:(int)index
                          type:(ScrollViewType)type
                    dataSource:(NSMutableDictionary *)dic;

@end
