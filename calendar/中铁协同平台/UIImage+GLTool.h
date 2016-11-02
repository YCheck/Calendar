//
//  UIImage+GLTool.h
//  EasyToVote
//
//  Created by gu on 16/1/12.
//  Copyright © 2016年 yp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GLTool)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)createQRImageWithQRStr:(NSString *)str withSize:(CGFloat) size;
+ (UIImage *)fetchLunchImage;//得到启动图
@end
