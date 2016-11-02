//
//  MessageModel.h
//  中铁协同平台
//
//  Created by gu on 16/7/24.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    CellTypeText = 0,
    CellTypeImage,
    CellTypeVideo,
    CellTypeVoice,
    CellTypeTime,
    CellTypeMap,//地图
} CellType;

@interface MessageModel : NSObject

@property (nonatomic,strong)NSString *avtar;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,assign)CellType cellType;
@property (nonatomic,assign)BOOL isSelf;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)UIView *chatView;
@property (nonatomic,strong)NSString *message;
@property (nonatomic,assign)NSInteger time;//CellTypeTime专用
@property (nonatomic,assign)NSInteger sendTime;
@property (nonatomic,assign)NSInteger audiolength;
@property (nonatomic,strong)NSDictionary *locationInfo;  //地图信息
@end
