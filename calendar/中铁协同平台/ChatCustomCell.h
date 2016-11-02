

#import <UIKit/UIKit.h>
#import "WFTextView.h"

#define headImageTag 2000000
#define bubbleViewTag 2000001

@interface ChatCustomCell : UITableViewCell{
	UILabel      *dateLabel;
    UIView *moreBtnView;
}

@property (nonatomic, retain) IBOutlet UILabel      *dateLabel;
@property (nonatomic , strong)UIView *view;
@property (nonatomic , strong)UIButton *hiBtn;
@property (nonatomic , assign) BOOL isHis;
@property (nonatomic,copy)void(^btnClick)(NSInteger index);
+ (UIView *)bubbleView:(NSString *)text nickName:(NSString *)nickName headPath:(NSString *)headPath from:(BOOL)fromSelf;
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font width:(NSInteger)width;
+ (WFTextView *)wfTextViewtext:(NSString *)aboveString fromSelf:(BOOL)fromSelf;
@end
