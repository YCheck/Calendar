//
//  BottomView.m
//  Finance
//
//  Created by 微他 on 15-1-26.
//  Copyright (c) 2015年 inwhoop. All rights reserved.
//

#import "BottomView.h"
#import "GLUIPlaceHolderTextView.h"
#import "FaceView.h"
#import "MoreView.h"
#import "Mp3Recorder.h"
#import "EaseRecordView.h"
#import "EMAudioRecorderUtil.h"
@interface BottomView ()<UITextViewDelegate,FaceViewDelegate,Mp3RecorderDelegate,MoreViewDelegate>
{
    GLUIPlaceHolderTextView *_textView;
    FaceView *_faceView;
    MoreView *_moreView;
    BOOL isbeginVoiceRecord;
    Mp3Recorder *MP3;
    NSInteger playTime;
    NSTimer *playTimer;
    
}

/**
 *  录音的附加页面
 */
@property (strong, nonatomic) UIView *recordView;

@end

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initInterface];
        MP3 = [[Mp3Recorder alloc]initWithDelegate:self];
    }
    return self;
}

- (UIView *)recordView
{
    if (_recordView == nil) {
        _recordView = [[EaseRecordView alloc] initWithFrame:CGRectMake(90, 130, 140, 140)];
    }
    
    return _recordView;
}

- (void)initInterface
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0.5)];
    view.backgroundColor = [UIColor colorWithRed:203 / 255.0 green:203 / 255.0 blue:203 / 255.0 alpha:1];
    [self addSubview:view];
    
    UIButton *smileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [smileBtn setBackgroundImage:[UIImage imageNamed:@"btn_smile"] forState:UIControlStateNormal];
    [smileBtn setBackgroundImage:[UIImage imageNamed:@"btn_smile1"] forState:UIControlStateSelected];
    smileBtn.frame = CGRectMake(ScreenWidth - 78, 13.5, 23, 23);
    [smileBtn addTarget:self action:@selector(smileClick:) forControlEvents:UIControlEventTouchUpInside];
    smileBtn.tag = 99;
    [self addSubview:smileBtn];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:[UIImage imageNamed:@"btn_photo"] forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"btn_photo1"] forState:UIControlStateSelected];
    moreBtn.frame = CGRectMake(smileBtn.right + 8, 13.5, 40, 23);
    [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.tag = 98;
    [self addSubview:moreBtn];
    
    UIButton *volBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [volBtn setBackgroundImage:[UIImage imageNamed:@"btn_vol"] forState:UIControlStateNormal];
    [volBtn setBackgroundImage:[UIImage imageNamed:@"btn_keybord"] forState:UIControlStateSelected];
    volBtn.frame = CGRectMake(7, 11.5, 36, 27);
    volBtn.tag = 100;
    [volBtn addTarget:self action:@selector(volBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:volBtn];
    
    _textView = [[GLUIPlaceHolderTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(volBtn.frame) + 7, 9, CGRectGetMinX(smileBtn.frame) - CGRectGetMaxX(volBtn.frame) - 14, 32)];
    _textView.placeholder = @"我也说一句";
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.cornerRadius = 4;
    _textView.textColor = HEXCOLOR(0x343434);
    _textView.font = [UIFont systemFontOfSize:16];
    [self addSubview:_textView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"按住说话" forState:UIControlStateNormal];
    [button setTitle:@"松开发送" forState:UIControlStateHighlighted];
//    [button setTitleColor:HEXCOLOR() forState:UIControlStateNormal];
//    [button setTitleColor:HEXCOLOR() forState:UIControlStateHighlighted];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.layer.borderColor = _textView.layer.borderColor;
    button.layer.borderWidth = _textView.layer.borderWidth;
    button.layer.cornerRadius = _textView.layer.cornerRadius;
    button.frame = _textView.frame;
    button.hidden = YES;
    button.tag = 101;
    [button addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [button addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [button addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [self addSubview:button];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendBtn.frame = moreBtn.frame;
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:[UIColor colorWithRed:0 green:122 / 255.0 blue:255 / 255.0 alpha:1]];
    sendBtn.tag = 102;
    sendBtn.layer.cornerRadius = 4;
    sendBtn.hidden = YES;
    [sendBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES) {
        [_delegate sengMessageText:_textView.text];
        _textView.text = nil;
        [self textViewDidChange:_textView];
//        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    UIButton *button = (UIButton *)[self viewWithTag:102];
    if (textView.text.length > 0) {
        button.hidden = NO;
    }else
    {
        button.hidden = YES;
    }
}

- (void)sendMessage:(UIButton *)sender
{
    [_delegate sengMessageText:_textView.text];
    _textView.text = nil;
    [self textViewDidChange:_textView];
//    [_textView resignFirstResponder];
}

- (void)volBtnClick:(UIButton *)sender
{
    [_textView resignFirstResponder];
    [self reloadInputView];
    sender.selected = !sender.selected;
    UIButton *button = (UIButton *)[self viewWithTag:101];
    if (sender.selected) {
        button.hidden = NO;
    }else
    {
        button.hidden = YES;
    }
    
}

//-------------------录音

- (void)beginRecordVoice:(UIButton *)sender
{
    
    self.recordView.center = self.superview.center;
    [self.superview addSubview:_recordView];
    [self.superview bringSubviewToFront:_recordView];
    sender.backgroundColor = [UIColor greenColor];
    [MP3 startRecord];
    playTime = 0;
    playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    ((EaseRecordView *)self.recordView).recorder = MP3.recorder;
    [(EaseRecordView *)self.recordView  recordButtonTouchDown];
}

- (void)endRecordVoice:(UIButton *)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    if (playTimer) {
        [MP3 stopRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
    [(EaseRecordView *)self.recordView recordButtonTouchUpInside];
    [self.recordView removeFromSuperview];
}

- (void)countVoiceTime
{
    UIButton *volbutton = (UIButton *)[self viewWithTag:101];
    playTime ++;
    if (playTime>=60) {
        [self endRecordVoice:volbutton];
        
    }
}

- (void)cancelRecordVoice:(UIButton *)button
{
    if (playTimer) {
        [MP3 cancelRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
//    [UUProgressHUD dismissWithError:@"Cancel"];
    [(EaseRecordView *)self.recordView recordButtonTouchUpOutside];
    [self.recordView removeFromSuperview];
}

- (void)RemindDragExit:(UIButton *)button
{
    NSLog(@"取消发送");
    [(EaseRecordView *)self.recordView recordButtonDragOutside];
}

- (void)RemindDragEnter:(UIButton *)button
{
    NSLog(@"上滑取消");
    [(EaseRecordView *)self.recordView recordButtonDragInside];
}

//-------------------

- (void)smileClick:(UIButton *)sender
{
    UIButton *button = (UIButton *)[self viewWithTag:101];
    UIButton *volbutton = (UIButton *)[self viewWithTag:100];
    UIButton *morebutton = (UIButton *)[self viewWithTag:98];
    morebutton.selected = NO;
    button.hidden = YES;
    volbutton.selected = NO;
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        //        [_textField resignFirstResponder];
        _faceView = [[FaceView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 216)];
        _faceView.delegate = self;
        _textView.inputView = _faceView;
        [_textView reloadInputViews];
        [_textView becomeFirstResponder];
    }else
    {
        _textView.inputView = nil;
        [_textView reloadInputViews];
        [_textView becomeFirstResponder];
    }
}

- (void)faceViewDelegate:(NSInteger)tag
{
    // 获得光标所在的位置
    NSInteger location = _textView.selectedRange.location;
    // 将UITextView中的内容进行调整（主要是在光标所在的位置进行字符串截取，再拼接你需要插入的文字即可）
    NSString *content = _textView.text;
    if (tag == 118) {
        if (location == 0) {
            return;
        }
        NSString *result = [NSString stringWithFormat:@"%@%@",[content substringToIndex:location - 1],[content substringFromIndex:location]];
        _textView.text = result;
        NSRange range;
        range.location = location - 1;
        range.length = 0;
        _textView.selectedRange = range;
        [self textViewDidChange:_textView];
        return;
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:nil];
    NSString *str= [NSString stringWithContentsOfFile:plistPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [str componentsSeparatedByString:@"\n"];
    
    NSString *string = array[tag];
    NSRange rang1 = [string rangeOfString:@"["];
    NSRange rang2 = [string rangeOfString:@"]"];
    
    NSString *result = [NSString stringWithFormat:@"%@%@%@",[content substringToIndex:location],[string substringWithRange:NSMakeRange(rang1.location, rang2.location - rang1.location + 1)],[content substringFromIndex:location]];
    // 将调整后的字符串添加到UITextView上面
    _textView.text = result;
    NSRange range;
    range.location = location + [[string substringWithRange:NSMakeRange(rang1.location, rang2.location - rang1.location + 1)] length];
    range.length = 0;
    _textView.selectedRange = range;
    [self textViewDidChange:_textView];
    //    _textView.text = [NSString stringWithFormat:@"%@%@",_textView.text,array[tag]];
//    [self changeTextViewHight:nil];
}

- (void)reloadInputView
{
    if (_faceView) {
        [_faceView removeFromSuperview];
    }
    if (_moreView) {
        [_moreView removeFromSuperview];
    }
    _moreView = nil;
    _faceView = nil;
    _textView.inputView = nil;
    UIButton *button = (UIButton *)[self viewWithTag:99];
    button.selected = NO;
    UIButton *morebButton = (UIButton *)[self viewWithTag:98];
    morebButton.selected = NO;
}

- (void)moreBtnClick:(UIButton *)sender
{
    UIButton *button = (UIButton *)[self viewWithTag:101];
    UIButton *volbutton = (UIButton *)[self viewWithTag:100];
    UIButton *smilebutton = (UIButton *)[self viewWithTag:99];
    smilebutton.selected = NO;
    button.hidden = YES;
    volbutton.selected = NO;
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        //        [_textField resignFirstResponder];
        _moreView = [[MoreView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 216)];
        _moreView.delegate = self;
        _textView.inputView = _moreView;
        [_textView reloadInputViews];
        [_textView becomeFirstResponder];
    }else
    {
        _textView.inputView = nil;
        [_textView reloadInputViews];
        [_textView becomeFirstResponder];
    }
}

- (void)moreViewDelegate:(NSInteger)tag
{
    [self reloadInputView];
    [_textView resignFirstResponder];
    switch (tag) {
        case 0:
            [_delegate sendPhoto:1];
            break;
        case 1:
            [_delegate sendPhoto:0];
            break;
        case 2:
            [_delegate sendVideo];
            break;
        case 3:
            [_delegate sendFile];
            break;
        case 4:
            [_delegate sendLocation];
            break;
        case 5:
            [_delegate sendMemberLocation];
            break;
        default:
            break;
    }
}

#pragma mark - Mp3RecorderDelegate

//回调录音资料
- (void)endConvertWithData:(NSData *)voiceData
{
//    UIButton *button = (UIButton *)[self viewWithTag:101];
    [_delegate sendVoice:@{@"voice":voiceData,
                          @"audiolength":[NSString stringWithFormat:@"%ld",(long)playTime + 1]
                          }];
    //[self.delegate UUInputFunctionView:self sendVoice:voiceData time:playTime+1];
   // [UUProgressHUD dismissWithSuccess:@"Success"];
    
    //缓冲消失时间 (最好有block回调消失完成)
//    button.enabled = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        button.enabled = YES;
//    });
}

- (void)failRecord
{
//    UIButton *button = (UIButton *)[self viewWithTag:101];
    //[UUProgressHUD dismissWithSuccess:@"Too short"];
    
    //缓冲消失时间 (最好有block回调消失完成)
//    button.enabled = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        button.enabled = YES;
//    });
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
