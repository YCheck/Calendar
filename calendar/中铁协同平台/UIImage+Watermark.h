//
//  UIImage+Watermark.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/29.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Watermark)
/*
    加水印
    img:image对象
    name:水印文字
 */
+(UIImage *)watermarkImage:(UIImage *)img withName:(NSString *)name;

@end
