//
//  VideoImageView.m
//  中铁协同平台
//
//  Created by gu on 16/7/27.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "VideoImageView.h"

@implementation VideoImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"messageVideo"];
        imageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
    }
    return self;
}

@end
