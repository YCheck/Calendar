//
//  FriendDeleteMoreView.h
//  EasyToVote
//
//  Created by gu on 16/1/29.
//  Copyright © 2016年 yp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MoreBtnTypeChangeNote,
    MoreBtnTypeDelete,
} MoreBtnType;


@interface FriendDeleteMoreView : UIView

- (instancetype)initWithFrame:(CGRect)frame isJiaJi:(BOOL)isJiaJi;

@property (nonatomic,copy)void(^btnClick)(UIButton *btn);

@end
