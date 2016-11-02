//
//  NSString+NSString_ILExtension.m
//  ILCoretext
//
//  Created by 阿虎 on 14/10/22.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "NSString+NSString_ILExtension.h"

@implementation NSString (NSString_ILExtension)

- (NSString *)replaceCharactersAtIndexes:(NSArray *)indexes withString:(NSString *)aString
{
    NSAssert(indexes != nil, @"%s: indexes 不可以为nil", __PRETTY_FUNCTION__);
    NSAssert(aString != nil, @"%s: aString 不可以为nil", __PRETTY_FUNCTION__);
    
    NSUInteger offset = 0;
    NSMutableString *raw = [self mutableCopy];
    
    NSInteger prevLength = 0;
    for(NSInteger i = 0; i < [indexes count]; i++)
    {
        @autoreleasepool {
            NSRange range = [[indexes objectAtIndex:i] rangeValue];
            prevLength = range.length;
            
            range.location -= offset;
            [raw replaceCharactersInRange:range withString:aString];
            offset = offset + prevLength - [aString length];
        }
    }
    
    return raw;
}

- (NSMutableArray *)itemsForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index
{
    if ( !pattern )
        return nil;
    
    NSError *error = nil;
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                     options:NSRegularExpressionCaseInsensitive error:&error];
    if (error)
    {
       
    }
    else
    {
        NSMutableArray *results = [[NSMutableArray alloc] init];
        NSRange searchRange = NSMakeRange(0, [self length]);
        [regx enumerateMatchesInString:self options:0 range:searchRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            NSRange groupRange =  [result rangeAtIndex:index];
            NSString *match = [self substringWithRange:groupRange];
            if ([self isImage:match]) {
                [results addObject:match];
            }
            
        }];
       
        return results;
    }
    
    return nil;
}

- (BOOL)isImage:(NSString *)match
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:nil];
    NSString *str= [NSString stringWithContentsOfFile:plistPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [str componentsSeparatedByString:@"\n"];
    //                zemoji
    UIImage *faceImage = nil;
    for (int j=0; j<array.count; j++) {
        NSString *string = array[j];
        NSRange rang1 = [string rangeOfString:@"["];
        NSRange rang2 = [string rangeOfString:@"]"];
        NSString *imageName = [string substringWithRange:NSMakeRange(rang1.location, rang2.location - rang1.location + 1)];
        if ([match isEqualToString:imageName]) {
            faceImage = [UIImage imageNamed:[string substringToIndex:rang1.location - 1]];
            break;
        }
    }
    if (faceImage == nil) {
        return NO;
    }else
        return YES;

}


@end
