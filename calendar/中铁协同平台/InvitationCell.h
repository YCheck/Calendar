//
//  InvitationCell.h
//  Finance
//
//  Created by apple on 15-2-6.
//  Copyright (c) 2015年 inwhoop. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InvitationForGroupDelegate <NSObject>

-(void)addpeople:(NSString *)peopleid;
-(void)removepeople:(NSString *)peopleid;

@end

@interface InvitationCell : UITableViewCell

@property(nonatomic,retain) NSDictionary *invitationdic;
@property (nonatomic, assign) id<InvitationForGroupDelegate> delegate;
@end
