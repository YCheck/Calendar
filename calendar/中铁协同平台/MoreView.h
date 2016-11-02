//
//  MoreView.h
//  中铁协同平台
//
//  Created by gu on 16/7/21.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreViewDelegate <NSObject>

- (void)moreViewDelegate:(NSInteger)tag;

@end

@interface MoreView : UIView

@property (nonatomic , assign) id<MoreViewDelegate>delegate;


@end
