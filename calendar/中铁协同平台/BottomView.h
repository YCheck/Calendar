//
//  BottomView.h
//  Finance
//
//  Created by 微他 on 15-1-26.
//  Copyright (c) 2015年 inwhoop. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomViewDelegate <NSObject>

- (void)sengMessageText:(NSString *)text;//文本
- (void)sendPhoto:(NSInteger)type;//照片
- (void)sendVoice:(NSDictionary *)dic;//语音
- (void)sendLocation;//位置;
- (void)sendFile;//位置;
- (void)sendMemberLocation;//成员位置;
- (void)sendVideo;//视频;
@end

@interface BottomView : UIView

@property (nonatomic , assign) id<BottomViewDelegate>delegate;

- (void)reloadInputView;

@end
