//
//  ChatViewController.h
//  Finance
//
//  Created by 微他 on 15-1-26.
//  Copyright (c) 2015年 inwhoop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ChatViewController : BaseViewController

//判断0－单聊 1－群聊
@property (nonatomic,assign) NSInteger msgtype;

//发送对象账号
@property (nonatomic , retain) NSString *tagid;

//发送对象头像 用于存消息列表最后一条消息
@property (nonatomic , retain) NSString *tagHeadPath;

//发送对象昵称 用于存消息列表最后一条消息
@property (nonatomic , retain) NSString *tagNick;

@end
