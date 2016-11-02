

#import "ChatCustomCell.h"
#import "YMTextData.h"
#import "YMTextView.h"
#import "WFTextView.h"
#import "YMButton.h"
#import "ContantHead.h"
#import "PYButton.h"
//#import "FC_Tools.h"
//#import <NH_ToolKit/NH_CacheManager.h>

@interface ChatCustomCell ()<UIGestureRecognizerDelegate>
{
    UIImageView *_avatar;
    UILabel *_nickName;
    UILabel *_profile;
    UILabel *_role;
    UIButton *_cardBtn;
}
@end

@implementation ChatCustomCell

@synthesize dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    moreBtnView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth - 259 - 50, self.height - 55, 259, 55)];
    moreBtnView.backgroundColor = HEXCOLOR(0x5c5c5c);
    moreBtnView.layer.cornerRadius = 6;
    moreBtnView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.contentView addSubview:moreBtnView];
    NSArray *arr = @[@"邀请审核",@"菜单",@"委派",@"重发",@"已读"];
    CGFloat x = 2;
    for (int i=0; i<arr.count; i++) {
        PYButton *btn = [PYButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.frame = CGRectMake(x, 0, 55, moreBtnView.height);
        }else
            btn.frame = CGRectMake(x, 0, 50, moreBtnView.height);
        [btn setType:PYButtonTypeBothSides_center labelPoint:CGPointMake(btn.width / 2, btn.height / 2 + 12) imagePoint:CGPointMake(btn.width / 2, btn.height / 2 - 12)];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreBtnView addSubview:btn];
        x = CGRectGetMaxX(btn.frame);
        if (i < arr.count - 1) {
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(x, 0, 0.5, moreBtnView.height)];
            lineview.backgroundColor = [UIColor whiteColor];
            [moreBtnView addSubview:lineview];
        }
    }
}

- (void)btnClick:(UIButton *)sender
{
    if (_btnClick) {
        _btnClick(sender.tag);
    }
}

- (void)setIsHis:(BOOL)isHis
{
    _isHis = isHis;
    moreBtnView.hidden = isHis;
}

- (void)setView:(UIView *)view
{
    if (_view != view) {
        [_view removeFromSuperview];
        _view = nil;
        _view = view;
    }
    [self.contentView addSubview:_view];
}

/*
 生成泡泡UIView
 */
#pragma mark -
#pragma mark Table view methods


//消息视图
+ (UIView *)bubbleView:(id)message nickName:(NSString *)nickName headPath:(NSString *)headPath from:(BOOL)fromSelf
{
    if ([message isKindOfClass:[NSString class]]) {
        return [self bubbleViewNickName:nickName headPath:headPath from:fromSelf returnview:[self wfTextViewtext:(NSString *)message fromSelf:NO]];
    }else if ([message isKindOfClass:[UIImageView class]])
    {
        return [self bubbleViewNickName:nickName headPath:headPath from:fromSelf returnview:message];
    }else if ([message isKindOfClass:[UIView class]])
    {
        return [self bubbleViewNickName:nickName headPath:headPath from:fromSelf returnview:message];
    }
    return nil;
}


+ (UIView *)bubbleViewNickName:(NSString *)nickName headPath:(NSString *)headPath from:(BOOL)fromSelf returnview:(id)returnview
{
    BOOL isImageView = NO;
    if ([returnview isKindOfClass:[UIImageView class]]) {
        isImageView = YES;
    }
    UIView *returnView = returnview;
    //    returnView.delegate = self;
    NSLog(@"%@",NSStringFromCGRect(returnView.frame));
    //    returnView.backgroundColor = [UIColor clearColor];
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectZero];
    cellView.backgroundColor = [UIColor clearColor];
    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"chat_right_bg":@"chat_left_bg" ofType:@"png"]];
    UIImageView *bubbleImageView;
    if(fromSelf)
    {
        bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:13 topCapHeight:25]];
    }else
    {
        bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:20 topCapHeight:25]];
    }
    bubbleImageView.userInteractionEnabled = YES;
    bubbleImageView.tag = bubbleViewTag;
    [bubbleImageView addSubview:returnView];
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.userInteractionEnabled = YES;
    headImageView = [self setImageView:headImageView];
//    [headImageView sd_setImageWithURL:[NSURL URLWithString:headPath]];
    headImageView.image = [UIImage imageNamed:@"头像"];
    headImageView.backgroundColor = [UIColor blackColor];
    headImageView.tag = headImageTag;
    CGFloat height = isImageView?returnView.frame.size.height + 16: returnView.frame.size.height + 29;
    if(fromSelf){
        returnView.frame= CGRectMake(8.0f, isImageView?8:14.5, returnView.frame.size.width, returnView.frame.size.height);
        bubbleImageView.frame = CGRectMake(30, 19, returnView.frame.size.width+30.0f, height);
        //        returnView.center = CGPointMake(CGRectGetMidX(returnView.bounds) + 15, CGRectGetMidY(returnView.bounds) + 12.67);
        cellView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 90 - bubbleImageView.frame.size.width, 0.0f,bubbleImageView.frame.size.width+85.0f, bubbleImageView.frame.size.height + 19.0f);
        headImageView.frame = CGRectMake(CGRectGetMaxX(bubbleImageView.frame), 19, 45.0f, 45.0f);
    }
    else{
        returnView.frame= CGRectMake(21.0f, isImageView?8:14.5, returnView.frame.size.width, returnView.frame.size.height);
        
        headImageView.frame = CGRectMake(15.0f, 19, 45.0f, 45.0f);
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = nickName;
        label.textColor = HEXCOLOR(0x999999);
        label.tag = 999;
        label.font = [UIFont boldSystemFontOfSize:12];
        label.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + 14, CGRectGetMinY(headImageView.frame), 200, 20);
        label.textAlignment = NSTextAlignmentLeft;
        
        [cellView addSubview:label];
        bubbleImageView.frame = CGRectMake(60.0f, CGRectGetMaxY(label.frame), returnView.frame.size.width+30.0f, height);
        cellView.frame = CGRectMake(0, 0.0f, 320,CGRectGetMaxY(bubbleImageView.frame));
    }
    
    headImageView.layer.cornerRadius = headImageView.frame.size.width / 2;
    headImageView.layer.masksToBounds = YES;
    [cellView addSubview:bubbleImageView];
    [cellView addSubview:headImageView];
    [bubbleImageView addSubview:returnView];
    //    cellView.backgroundColor = [UIColor redColor];
    
    return cellView;

}


+ (UIImageView *)setImageView:(UIImageView *)imageView
{
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imageView.contentMode =  UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imageView.clipsToBounds  = YES;
    return imageView;
}

#define MAX_X 190
+ (WFTextView *)wfTextViewtext:(NSString *)aboveString fromSelf:(BOOL)fromSelf
{
    CGFloat width = [self sizeWithString:aboveString font:[UIFont systemFontOfSize:16] width:1000].width;
    YMTextData *ymData = [[YMTextData alloc] init];
    ymData.showShuoShuo = aboveString;
    if(width > MAX_X)
    {
        width = MAX_X;
    }
    WFTextView *textView = [[WFTextView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:MAX_X withUnFoldState:YES];//展开
    //    textView.delegate = self;
    textView.attributedData = ymData.attributedDataWF;
    textView.isFold = ymData.foldOrNot;
    textView.isDraw = YES;
    [textView setOldString:ymData.showShuoShuo andNewString:ymData.completionShuoshuo fromSelf:fromSelf];
    BOOL foldOrnot = NO;
    float hhhh = foldOrnot?ymData.shuoshuoHeight:ymData.unFoldShuoHeight;
    textView.frame = CGRectMake(0, 0, textView.frame.size.width, hhhh - 5);
    textView.tag=hhhh;
    return textView;
}

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font width:(NSInteger)width
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 1000)//显示的最大容量
                                       options: NSStringDrawingUsesLineFragmentOrigin //描述字符串的附加参数
                                    attributes:@{NSFontAttributeName: font}//描述字符串的参数
                                       context:nil];//上下文
    //返回值
    return rect.size;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state

}



@end
