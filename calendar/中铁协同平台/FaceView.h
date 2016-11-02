//
//  faceView.h
//  微他
//
//  Created by 微他 on 14-8-13.
//  Copyright (c) 2014年 微他. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceViewDelegate <NSObject>

- (void)faceViewDelegate:(NSInteger)tag;

@end

@interface FaceView : UIView<UIScrollViewDelegate>

@property (nonatomic , assign) id<FaceViewDelegate>delegate;

@end
