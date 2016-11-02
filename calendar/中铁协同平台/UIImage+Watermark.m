//
//  UIImage+Watermark.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/29.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "UIImage+Watermark.h"

@implementation UIImage (Watermark)

+(UIImage *)watermarkImage:(UIImage *)img withName:(NSString *)name
{
    
    
    NSString *mark = name;
    int w = img.size.width;
    int h = img.size.height;
    UIGraphicsBeginImageContext(img.size);
    
    
    [img drawInRect:CGRectMake(0, 0, w, h)];
//    CGContextSetFillColorWithColor(img, [UIColor blackColor].CGColor);
    
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    NSDictionary *attr = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],  //设置字体
                           NSForegroundColorAttributeName :[UIColor grayColor],     //设置字体颜色
                           NSParagraphStyleAttributeName:style
                           };
    //    [mark drawInRect:CGRectMake(0,0 ,50 ,14 ) withAttributes:attr];         //左上角
    //    [mark drawInRect:CGRectMake(w - 50, 0,50 ,14 ) withAttributes:attr];      //右上角
    [mark drawInRect:CGRectMake(0, h - 25 ,w, 25) withAttributes:attr];  //右下角
    //    [mark drawInRect:CGRectMake(0, h - 14 , 50,14 ) withAttributes:attr];    //左下角
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //绘制半透明背景色
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    UIColor *bgColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    CGContextSetStrokeColorWithColor(context, bgColor.CGColor);
//    CGContextSetFillColorWithColor(context, bgColor.CGColor);
//    CGRect bgRect = CGRectMake(0, h - 25 ,w, 25);
//    CGContextAddRect(context, bgRect);
//    CGContextDrawPath(context, kCGPathFillStroke);
    return aimg;
}



@end
