//
//  ChatViewController.m
//  Finance
//
//  Created by 微他 on 15-1-26.
//  Copyright (c) 2015年 inwhoop. All rights reserved.
//

#import "ChatViewController.h"
#import "SpaceViewController.h"
#import "BottomView.h"
#import "ChatCustomCell.h"
#import "UIImage+GLTool.h"
#import "FriendDeleteMoreView.h"
#import "AppointViewController.h"
#import "ChooseLocationViewController.h"
//#import "RSKImageCropViewController.h"
//#import "XmppManager.h"
//#import "StockManager.h"

//#import "HZAreaPickerView.h"
#import <MobileCoreServices/MobileCoreServices.h>
//#import "RSKImageCropper.h"
//#import <NH_ToolKit/NH_CacheManager.h>
//#import <NH_ToolKit/NH_Tool.h>
#import "GTMBase64.h"
//#import "FC_Tools.h"
#import <AVFoundation/AVFoundation.h>
#import "ClickImage.h"
//#import "FC_UserInfoViewController.h"
//#import "AppDelegate.h"
//#import "GroupModel.h"
//#import "FC_GroupViewController.h"
#import "MessageModel.h"
#import "VideoImageView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CycleScrollViewController.h"
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,BottomViewDelegate,UITextFieldDelegate, UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,AVAudioPlayerDelegate>
{
    BottomView *_bottomView;
    UITableView *_tableView;
    NSMutableArray *_chatArr;
    NSString *_userName;
    NSString *_userHeadPath;
    NSInteger _lastTime;
    NSMutableDictionary *_indicatorViewDic;
    UIImageView *_tempImageView;
    NSTimer *_playTimer;
    AVAudioPlayer *_player;
    BOOL _isJiaji;
}

@end

#define voiceTag 99999999
#define chatViewTag 10000

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isJiaji = NO;
    [self initDataSource];
    [self initInterface];
}

- (void)initdata{

}

- (void)initDataSource
{
    _userName = @"小张";
    _msgtype = 0;
    _tagid = @"2";
    _tagHeadPath = @"";
    _userHeadPath = @"";
    _tagNick = @"小李";
    _chatArr = [NSMutableArray array];
    
}

- (void)initInterface
{
    CGFloat bottom = 50;
    _bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - bottom - 64, CGRectGetWidth(self.view.bounds), 50)];
    _bottomView.clipsToBounds = YES;
    _bottomView.delegate = self;
    [self.view addSubview:_bottomView];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - bottom - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewWillBeginDragging:)];
    [_tableView addGestureRecognizer:tap];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"announcement"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"announcement_select"] forState:UIControlStateSelected];
    btn.frame = CGRectMake(0, 0, 26, 26);
    [btn addTarget:self action:@selector(announcementBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *announcement = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(menuBtnClick)];
    self.navigationItem.rightBarButtonItems = @[menu,announcement];
}

- (void)announcementBtnClick:(UIButton *)sender
{
    sender.selected = YES;
    [self gotoSpaceVC];
}

- (void)menuBtnClick
{
    FriendDeleteMoreView *view = [[FriendDeleteMoreView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds isJiaJi:_isJiaji];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    [view setBtnClick:^(UIButton *btn) {
        if (btn.tag == 2) {
            _isJiaji = !_isJiaji;
        }else
            [self gotoSpaceVC];
    }];
}

- (void)gotoSpaceVC
{
    SpaceViewController *vc = [[SpaceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)msgAdd:(NSArray *)arr isrefresh:(BOOL)isrefresh
{
    /*
    for (int i=0; i<arr.count; i++) {
        NSString *userid = _msgtype == 0?arr[i][@"tagid"]:arr[i][@"userid"];
        //判断时间
        if (_lastTime == 0) {
            [_chatArr addObject:@{@"date": arr[i][@"sendtime"]}];
            _lastTime = [arr[i][@"sendtime"] integerValue];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_chatArr count] - 1 inSection:0];
            [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else if ([arr[i][@"sendtime"] integerValue] - _lastTime > 300) {
            [_chatArr addObject:@{@"date": arr[i][@"sendtime"]}];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_chatArr count] - 1 inSection:0];
            [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        //判断是谁发的信息
        if ([arr[i][@"issend"] integerValue] == 1) {
            if ([arr[i][@"msgtype"] isEqualToString:@"1"]) {//我的消息是文字
                UIView *chatView = [ChatCustomCell bubbleView:arr[i][@"message"] nickName:_userName headPath:_userHeadPath from:YES];
                [_chatArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:chatView, @"view",@"self", @"speaker",arr[i][@"message"],@"message",arr[i][@"sendtime"],@"sendtime",userid,@"userid", nil]];
            }else if ([arr[i][@"msgtype"] isEqualToString:@"2"]){//我的消息是图片
                UIView *chatView = [ChatCustomCell bubbleView:[self imageView:arr[i][@"message"]] nickName:_userName headPath:_userHeadPath from:YES];
                [_chatArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:chatView, @"view",@"self", @"speaker",arr[i][@"message"],@"message",arr[i][@"sendtime"],@"sendtime",userid,@"userid", nil]];
            }else if([arr[i][@"msgtype"] isEqualToString:@"3"]){//我的消息是语音
                UIView *chatView = [ChatCustomCell bubbleView:[self voiceImageview:[arr[i][@"audiolength"] integerValue] fromself:YES] nickName:_userName headPath:_userHeadPath from:YES];
                [_chatArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:chatView, @"view",@"self", @"speaker",arr[i][@"message"],@"message",arr[i][@"sendtime"],@"sendtime",arr[i][@"audiolength"] ,@"audiolength",userid,@"userid", nil]];
            }
        }else
        {
            if ([arr[i][@"msgtype"] isEqualToString:@"1"]) {//他的消息是文字
                UIView *chatView;
                if (_msgtype == 0) {
                    chatView =[ChatCustomCell bubbleView:arr[i][@"message"] nickName:_tagNick headPath:_tagHeadPath from:NO];
                }else
                {
                    chatView =[ChatCustomCell bubbleView:arr[i][@"message"] nickName:arr[i][@"usernick"] headPath:arr[i][@"headpath"] from:NO];
                }
                [_chatArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:chatView, @"view",@"self", @"speaker",arr[i][@"message"],@"message",arr[i][@"sendtime"],@"sendtime",userid,@"userid", nil]];
            }else if ([arr[i][@"msgtype"] isEqualToString:@"2"]){//他的消息是图片
                UIView *chatView = [ChatCustomCell bubbleView:[self imageView:arr[i][@"message"]] nickName:arr[i][@"usernick"] headPath:arr[i][@"headpath"] from:NO];
                [_chatArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:chatView, @"view",@"self", @"speaker",arr[i][@"message"],@"message",arr[i][@"sendtime"],@"sendtime",userid,@"userid", nil]];;
            }else if([arr[i][@"msgtype"] isEqualToString:@"3"]){//他的消息是语音
                                UIView *chatView = [ChatCustomCell bubbleView:[self voiceImageview:[arr[i][@"audiolength"] integerValue] fromself:NO] nickName:arr[i][@"usernick"] headPath:arr[i][@"headpath"] from:NO];
                                [_chatArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:chatView, @"view",@"self", @"speaker",arr[i][@"message"],@"message",arr[i][@"sendtime"],@"sendtime",arr[i][@"audiolength"] ,@"audiolength",userid,@"userid", nil]];
            }
        }
        
        //记录当前消息时间
        _lastTime = [arr[i][@"sendtime"] integerValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_chatArr count] - 1 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    //    [_tableView reloadData];
    if (isrefresh) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_chatArray.count - _count inSection:0];
//        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        //        _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, _tableView.contentOffset.y + 10);
    }else
    {
        if (_chatArr.count > 1) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_chatArr count] - 1 inSection:0];
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        
    }
    _lastTime = [[arr lastObject][@"sendtime"] integerValue];
     */
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _chatArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *msgModel = _chatArr[indexPath.row];
    if (msgModel.cellType == CellTypeTime)
    {
        return 36;
    }else if (msgModel.chatView != nil)
    {
        UIView *chatView = msgModel.chatView;
        if (msgModel.isSelf) {
            return chatView.frame.size.height + 60;
        }else
            return chatView.frame.size.height;
        
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIbentify = @"cell";
    ChatCustomCell *cell = (ChatCustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIbentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatCustomCell" owner:self options:nil] lastObject];
    }
    MessageModel *msgModel = _chatArr[indexPath.row];
    if (msgModel.cellType != CellTypeTime) {
        cell.dateLabel.hidden = YES;
    }
    if(msgModel.chatView != nil)
    {
        UIView *chatView = msgModel.chatView;
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, chatView.frame.size.height);
        cell.view = [[UIView alloc] initWithFrame:cell.bounds];
        cell.view.tag = indexPath.row + chatViewTag;
        cell.view = chatView;
        cell.view.clipsToBounds = YES;
    
        UIImageView *bubView = (UIImageView *)[chatView viewWithTag:bubbleViewTag];
        //添加手势
        UITapGestureRecognizer *bubViewsingPress =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handliSingle:)];
        //代理
        bubViewsingPress.delegate = self;
        bubViewsingPress.numberOfTapsRequired = 1;
        
        [bubView addGestureRecognizer:bubViewsingPress];
        
        UIImageView *headImageView = (UIImageView *)[chatView viewWithTag:headImageTag];
        //添加手势
        UITapGestureRecognizer *headImageViewsingPress =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handliSingle:)];
        //代理
        headImageViewsingPress.delegate = self;
        headImageViewsingPress.numberOfTapsRequired = 1;
        
        [headImageView addGestureRecognizer:headImageViewsingPress];
        
    }else if(msgModel.cellType == CellTypeTime)
    {
        //时间
        NSString *timeString = [self dateWithTimeIntervalSince1970:msgModel.time];
        CGSize size = [ChatCustomCell sizeWithString:timeString font:[UIFont boldSystemFontOfSize:11] width:200];
        [cell.dateLabel setText:timeString];
        cell.dateLabel.frame = CGRectMake((ScreenWidth - size.width + 7) / 2 , 16, size.width + 7, 20);
        cell.dateLabel.backgroundColor = [UIColor colorWithRed:211 / 255.0 green:211 / 255.0 blue:211 / 255.0 alpha:1];
        cell.dateLabel.textColor = [UIColor whiteColor];
        cell.dateLabel.textAlignment = NSTextAlignmentCenter;
        [cell.dateLabel setFont:[UIFont boldSystemFontOfSize:11]];
        cell.dateLabel.layer.cornerRadius = 4;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    if (msgModel.isSelf) {
        cell.isHis = NO;
        [cell setBtnClick:^(NSInteger index) {
            if (index == 0) {
                [self gotoSpaceVC];
            }else if (index == 1)
            {
                [self menuBtnClck];
            }else if (index == 2)
            {
                AppointViewController *vc = LOAD_NIB(@"AppointViewController");
                [self.navigationController pushViewController:vc animated:YES];
            }else if (index == 3)
            {
                if (msgModel.cellType == CellTypeText) {
                    [self sengMessage:msgModel.message celltype:CellTypeText];
                }
                
            }else if (index == 4)
            {
                [self gotoSpaceVC];
            }
        }];
    }else
        cell.isHis = YES;
    
    UIView *bubbleView = [cell.contentView viewWithTag:bubbleViewTag];
    bubbleView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesClick:)];
    [bubbleView addGestureRecognizer:longGes];
    
    
    return cell;
}

- (void)longGesClick:(UILongPressGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateEnded) {
        
    }
}

- (void)menuBtnClck
{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"我要休息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"我要委托人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"我要配件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alter addAction:action1];
    [alter addAction:action2];
    [alter addAction:action3];
    [alter addAction:cancel];
    [self presentViewController:alter animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"ReceiveMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryHistory:) name:@"QueryHistory" object:nil];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:RGB(46, 122, 201) size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
}

- (void)queryHistory:(NSNotification *)info
{
    NSDictionary *dic = [info object];
    for (int i=0; i<_chatArr.count; i++) {
        if ([_chatArr[i][@"message"] isEqualToString:dic[@"message"]] && [_chatArr[i][@"sendtime"] isEqualToString:dic[@"sendtime"]]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.view endEditing:YES];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    //得到键盘高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - keyboardRect.size.height - 50, CGRectGetWidth(self.view.bounds), 50);
    _tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 50 - keyboardRect.size.height);
    //滚动至当前行
    if (_chatArr.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_chatArr.count - 1 inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 50, CGRectGetWidth(self.view.bounds), 50);
    _tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 50);
    [_tableView reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [_bottomView reloadInputView];
}

- (void)sengMessage:(id)message celltype:(CellType)celltype
{
    if(celltype == CellTypeText)
    {
        if ([message isEqualToString:@""] || message == nil) {
            return;
        }
    }
    NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
    
    // 发送后生成泡泡显示出来
    if (nowTime - _lastTime > 300) {
        MessageModel *msgModel = [[MessageModel alloc] init];
        msgModel.cellType = CellTypeTime;
        _lastTime = nowTime;
        msgModel.time = nowTime;
        [_chatArr addObject:msgModel];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_chatArr count] - 1 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    UIView *chatView;
    MessageModel *msgModel = [[MessageModel alloc] init];
    msgModel.sendTime = nowTime;
    msgModel.userId = @"1";
    msgModel.isSelf = YES;
    msgModel.cellType = celltype;
    [_chatArr addObject:msgModel];
    if (celltype == CellTypeText) {
        chatView =  [ChatCustomCell bubbleView:message nickName:nil headPath:_userHeadPath from:YES];
        msgModel.message = message;
    }else if (celltype == CellTypeImage)
    {
        chatView =  [ChatCustomCell bubbleView:[self imageView:message] nickName:nil headPath:_userHeadPath from:YES];
        msgModel.message = [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(message,0.5)];
    }else if (celltype == CellTypeVoice)
    {
        chatView =  [ChatCustomCell bubbleView:[self voiceImageview:[message[@"audiolength"] integerValue] fromself:YES] nickName:nil headPath:_userHeadPath from:YES];
        msgModel.message = [GTMBase64 stringByEncodingData:message[@"voice"]];
        msgModel.audiolength = [message[@"audiolength"] integerValue];
    }else if (celltype == CellTypeVideo)
    {
        chatView =  [ChatCustomCell bubbleView:[self videoImageView:[(NSURL *)message path]] nickName:nil headPath:_userHeadPath from:YES];
        msgModel.message = [(NSURL *)message path];
    }else if (celltype == CellTypeMap)
    {
        chatView =  [ChatCustomCell bubbleView:[self mapLocationImageView:message] nickName:nil headPath:_userHeadPath from:YES];
        msgModel.locationInfo = message;
    }
    
    msgModel.chatView = chatView;
    //发生信息菊花
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    indicatorView.center = CGPointMake(12.5, chatView.center.y + 19 / 2);
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_indicatorViewDic setObject:indicatorView forKey:[NSString stringWithFormat:@"%ld",(long)nowTime]];
    [chatView addSubview:indicatorView];
//    [indicatorView startAnimating];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_chatArr count] - 1 inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    [self receiveMessage:msgModel];
//    XmppManager *xmppManager = [XmppManager instance];
//    xmppManager.delegate = self;
//    if(_msgtype == 0)
//    {
//        NSDictionary *dic;
//        if ([message isKindOfClass:[NSString class]]) {
//             dic = @{@"usernick":_userName,
//                                  @"msgtype":@"1",
//                                  @"sendTag":[NSString stringWithFormat:@"%ld",(long)nowTime],
//                                  @"headpath":_userHeadPath,
//                                  @"tagid":_tagid,
//                                  @"message":message,
//                     @"type":[NSString stringWithFormat:@"%ld",(long)_msgtype],
//                     @"groupname":_tagNick,
//                     @"groupphoto":_tagHeadPath,
//                     @"audiopath":@"",
//                     @"audiolength":@"0"
//                                  };
//        }else if ([message isKindOfClass:[UIImage class]])
//        {
//            UIImage *image = (UIImage *)message;
//            NSString *imageStr = [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(image,0.5)];
//            dic = @{@"usernick":_userName,
//                    @"msgtype":@"2",
//                    @"sendTag":[NSString stringWithFormat:@"%ld",(long)nowTime],
//                    @"headpath":_userHeadPath,
//                    @"tagid":_tagid,
//                    @"message":imageStr,
//                    @"type":[NSString stringWithFormat:@"%ld",(long)_msgtype],
//                    @"groupname":_tagNick,
//                    @"groupphoto":_tagHeadPath,
//                    @"audiopath":@"",
//                    @"audiolength":@"0"
//                    };
//        }else if ([message isKindOfClass:[NSDictionary class]])
//        {
//            NSDictionary *voiceDic = (NSDictionary *)message;
//            NSString *voice = [GTMBase64 stringByEncodingData:voiceDic[@"voice"]];
//            dic = @{@"usernick":_userName,
//                    @"msgtype":@"3",
//                    @"sendTag":[NSString stringWithFormat:@"%ld",(long)nowTime],
//                    @"headpath":_userHeadPath,
//                    @"tagid":_tagid,
//                    @"message":voice,
//                    @"type":[NSString stringWithFormat:@"%ld",(long)_msgtype],
//                    @"groupname":_tagNick,
//                    @"groupphoto":_tagHeadPath,
//                    @"audiopath":[NSString stringWithFormat:@"/ddcj/audio/%ld.mp3",(long)nowTime],
//                    @"audiolength":voiceDic[@"audiolength"]
//                    };
//        }
//        [xmppManager sendMessage:dic];
//    }
    
}

- (void)sendMessageisSuccess:(BOOL)isSuccess dic:(NSDictionary *)dic
{
    /*
    UIActivityIndicatorView *indicatorView = _indicatorViewDic[dic[@"sendTag"]];
    
    NSLog(@"%@",indicatorView);
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (isSuccess) {
        StockManager *sockManager = [[StockManager alloc] init];
        [tempDic setObject:_tagid forKey:@"tagid"];
        if(_msgtype == 0)
        {
            //保存单聊记录
            [sockManager saveChatmsg:tempDic];
            //保存最后一条消息
            [tempDic setObject:_tagHeadPath forKey:@"headpath"];
            [tempDic setObject:_tagNick forKey:@"usernick"];
            [sockManager savenotify:tempDic];
        }
    }else
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        imageView.center = CGPointMake(12.5, indicatorView.superview.center.y + 7);
        imageView.image = [UIImage imageNamed:@"发送失败"];
//        imageView.tag = signTag;
        [indicatorView.superview addSubview:imageView];
    }
    [indicatorView stopAnimating];
    [_indicatorViewDic removeObjectForKey:dic[@"sendTag"]];
    */
}

- (void)receiveMessage:(MessageModel *)model
{
     id message;
     if (model.cellType == CellTypeText) {
         message = model.message;
     }else if (model.cellType == CellTypeImage)
     {
         message = [self imageView:model.message];
     }else if (model.cellType == CellTypeVoice)
     {
         message = [self voiceImageview:model.audiolength  fromself:NO];
     }else if (model.cellType == CellTypeVideo)
     {
         message = [self videoImageView:model.message];
     }
     UIView *chatView = [ChatCustomCell bubbleView:message nickName:_tagNick headPath:_tagHeadPath from:NO];
    MessageModel *msgModel = [[MessageModel alloc] init];
    msgModel.chatView = chatView;
    msgModel.message = model.message;
    msgModel.audiolength = model.audiolength;
    [_chatArr addObject:msgModel];
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_chatArr count] - 1 inSection:0];
     [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
     [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
     
}

//- (void)receiveMessage:(MessageModel *)model
//{
//    /*
//    NSDictionary *dic = [info userInfo];
//    if (!([dic[@"notifytype"] integerValue] == _msgtype)) {
//        return;
//    }
//    id message;
//    if ([dic[@"msgtype"] isEqualToString:@"1"]) {
//        message = dic[@"message"];
//    }else if ([dic[@"msgtype"] isEqualToString:@"2"])
//    {
//        message = [self imageView:dic[@"message"]];
//    }else if ([dic[@"msgtype"] isEqualToString:@"3"])
//    {
//        message = [self voiceImageview:[dic[@"audiolength"] integerValue]  fromself:NO];
//    }
//    UIView *chatView = [ChatCustomCell bubbleView:message nickName:dic[@"usernick"] headPath:dic[@"headpath"] from:NO];
//    [_chatArr addObject:@{@"view":chatView,@"message":dic[@"message"],@"audiolength":dic[@"audiolength"]}];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_chatArr count] - 1 inSection:0];
//    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//    StockManager *stockManager = [[StockManager alloc] init];
//    [stockManager clearnotifyunread:_tagid];
//     */
//}

- (id)imageView:(id)message
{
    UIImage *image;
    if ([message isKindOfClass:[NSString class]]) {
        NSData *imageData = [GTMBase64 decodeString:message];
        image = [UIImage imageWithData:imageData];
    }else if ([message isKindOfClass:[UIImage class]])
    {
        image = (UIImage *)message;
    }
    CGFloat scale = [self image:image viewWidth:100];
    ClickImage *imageView = [[ClickImage alloc] initWithFrame:CGRectMake(0, 0, image.size.width / scale, image.size.height / scale)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.canClick = YES;
    imageView.image = image;
    return imageView;
}


- (CGFloat)image:(UIImage *)image viewWidth:(CGFloat)viewWidth
{
    CGFloat scale = 1;
    scale = image.size.width / viewWidth;
    scale =  image.size.height / viewWidth > scale?image.size.height / viewWidth:scale;
    if (scale != 0) {
        return scale;
    }else
        return 1;
    
}

- (id)voiceImageview:(NSInteger)time fromself:(BOOL)fromself
{
    UIView *voiceBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    voiceBgview.userInteractionEnabled = NO;
    if (fromself) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, 20, 20)];
        imageView.image = [UIImage imageNamed:@"chat_animation_white3"];
        imageView.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"chat_animation_white1"],
                                     [UIImage imageNamed:@"chat_animation_white2"],
                                     [UIImage imageNamed:@"chat_animation_white3"],nil];
        imageView.animationDuration = 1;
        imageView.animationRepeatCount = 0;
        imageView.tag = voiceTag;
        [voiceBgview addSubview:imageView];
        UILabel *playtime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 20)];
        playtime.font = [UIFont systemFontOfSize:14];
        playtime.text = [NSString stringWithFormat:@"%lds",(long)time];
        playtime.textColor = [UIColor whiteColor];
        [voiceBgview addSubview:playtime];
    }else
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
        imageView.image = [UIImage imageNamed:@"chat_animation3"];
        imageView.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"chat_animation1"],
                                     [UIImage imageNamed:@"chat_animation2"],
                                     [UIImage imageNamed:@"chat_animation3"],nil];
        imageView.animationDuration = 1;
        imageView.animationRepeatCount = 0;
        imageView.tag = voiceTag;
        [voiceBgview addSubview:imageView];
        UILabel *playtime = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 40, 20)];
        playtime.font = [UIFont systemFontOfSize:14];
        playtime.text = [NSString stringWithFormat:@"%lds",(long)time];
        playtime.textColor = [UIColor colorWithRed:138 / 255.0 green:147 / 255.0 blue:157 / 255.0 alpha:1];
        [voiceBgview addSubview:playtime];
    }
    
    return voiceBgview;
}

- (void)handliSingle:(UIGestureRecognizer *)gesture
{
    UIImageView *imageView = (UIImageView *)[gesture.view viewWithTag:voiceTag];
    UIImageView *headImageView = (UIImageView *)[gesture.view viewWithTag:headImageTag];
    if (imageView) {
        if ([_tempImageView isAnimating]) {
            [_tempImageView stopAnimating];
            if (_playTimer) {
                [_playTimer invalidate];
            }
        }
        [imageView startAnimating];
        _tempImageView = imageView;
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:[gesture locationInView:_tableView]];
        MessageModel *model = _chatArr[indexPath.row];
        NSInteger time = model.audiolength;
        _playTimer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(stopPlayvoice) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_playTimer forMode:NSRunLoopCommonModes];
        NSLog(@"%@",_chatArr[indexPath.row]);
        NSData *voiceData = [GTMBase64 decodeString:model.message];
        _player = [[AVAudioPlayer alloc]initWithData:voiceData error:nil];
        _player.volume = 1.0f;
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
        _player.delegate = self;
        [_player play];
    }else if(headImageView)
    {
//        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:[gesture locationInView:_tableView]];
//        //跳转个人资料
//        NSString *userid = _chatArr[indexPath.row][@"userid"];
//        FC_UserInfoViewController *vc = [[FC_UserInfoViewController alloc]init];
//        vc.touserid = userid;
//        [[AppDelegate sharedAppDelegate].navigationCtr pushViewController:vc animated:YES];
    }
}

- (void)stopPlayvoice
{
    if ([_tempImageView isAnimating]) {
        [_tempImageView stopAnimating];
    }
    if (_player && _player.isPlaying) {
        [_player stop];
    }
    if (_playTimer) {
        [_playTimer invalidate];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{

    [self stopPlayvoice];
}


- (id)videoImageView:(NSString *)url
{
    UIImage *image = [self getThumbnailImage:url];
    CGFloat scale = [self image:image viewWidth:100];
    VideoImageView *imageView = [[VideoImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width / scale, image.size.height / scale)];
    imageView.image = image;
    imageView.url = url;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo:)];
    [imageView addGestureRecognizer:tap];
    return imageView;
    
}


- (id)mapLocationImageView:(NSDictionary *)dic{
    UIImage *image = [UIImage imageWithData:dic[@"imageData"]];
    CGFloat scale = [self image:image viewWidth:100];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width / scale, image.size.height / scale)];
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height - 25, imageView.frame.size.width, 25)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:9];
    label.backgroundColor = [UIColor blackColor];
    label.alpha = 0.5;
    label.numberOfLines = 2;
    label.text = dic[@"address"];
    
    [imageView addSubview:label];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToMapView:)];
    [imageView addGestureRecognizer:tap];
    return imageView;
}

#pragma mark --点击地图类型信息
- (void)pushToMapView:(UITapGestureRecognizer *)tap{
    
    UIImageView *imageView = (UIImageView *)tap.view;
    ChatCustomCell *chatCell = (ChatCustomCell *)imageView.superview.superview.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:chatCell];
    MessageModel *msgModel = _chatArr[indexPath.row];
    ChooseLocationViewController *chooseMapVC = [ChooseLocationViewController new];
    chooseMapVC.coorDic = msgModel.locationInfo;
    chooseMapVC.type = MapTypeMessageClicked;
    [self.navigationController pushViewController:chooseMapVC animated:YES];
}

- (void)playVideo:(UITapGestureRecognizer *)tap
{
    VideoImageView *imageView = (VideoImageView *)tap.view;
    NSURL *videoURL = [NSURL fileURLWithPath:imageView.url];
    MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [moviePlayerController.moviePlayer prepareToPlay];
    moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)dateWithTimeIntervalSince1970:(NSInteger )dateline
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日 hh:mm"];
    NSTimeInterval time= dateline;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    return [formatter stringFromDate:detaildate];
}


/**

 选择图片
 
**/

//#pragma mark - 选取照片和拍照
-(void)sendPhoto:(NSInteger)type
{
    
    // 判断设备是否支持相册
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        NSLog(@"设备不支持访问相册");
        
        return ;
    }
    //判断设备是否支持照相机
    
    UIImagePickerController * mipc = [[UIImagePickerController alloc] init];
    switch (type) {
        case 0:
            mipc.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
        case 1:
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                NSLog(@"设备不支持访问照相机");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示！"
                                                                message:@"设备不支持访问照相机"
                                                               delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return;
            }
            mipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
            break;
        case 2:
            break;
        default:
            break;
    }
    mipc.delegate = self;//委托
    mipc.allowsEditing = NO;//是否可编辑照片
    mipc.mediaTypes=[NSArray arrayWithObjects:@"public.image",nil];
    // 设置可用媒体类型
    [self presentViewController:mipc animated:YES completion:^(void){
        //        NSLog(@"1");
        //        NSLog(@"%@",NSHomeDirectory());
    }];
}

#pragma mark - <UIImagePickerControllerDelegate>代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        // video url:
        // file:///private/var/mobile/Applications/B3CDD0B2-2F19-432B-9CFA-158700F4DE8F/tmp/capture-T0x16e39100.tmp.9R8weF/capturedvideo.mp4
        // we will convert it to mp4 format
        NSURL *mp4 = [self _convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"failed to remove file, error:%@.", error);
            }
        }
        [self sengMessage:mp4 celltype:CellTypeVideo];
        
    }else
    {
        UIImage *image = info[UIImagePickerControllerEditedImage] == nil?info [UIImagePickerControllerOriginalImage]:info[UIImagePickerControllerEditedImage];
        [self sengMessage:(id)image celltype:CellTypeImage];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --文本
- (void)sengMessageText:(NSString *)text
{
    [self sengMessage:text celltype:CellTypeText];
}

#pragma mark --音频
- (void)sendVoice:(NSDictionary *)dic
{
    [self sengMessage:(id)dic celltype:CellTypeVoice];
}

#pragma mark --位置
- (void)sendLocation
{
    ChooseLocationViewController *chooseMapVC = [ChooseLocationViewController new];
    chooseMapVC.chooseLocaiton = ^(NSDictionary *locationInfo, UIImage *locationImage){
        NSData *imageData = UIImageJPEGRepresentation(locationImage, 1.0);
        NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithDictionary:locationInfo];
        [info setValue:imageData forKey:@"imageData"];
        [self sengMessage:(id)info celltype:CellTypeMap];
    };
    chooseMapVC.type = MapTypeChooseLocation;
    [self.navigationController pushViewController:chooseMapVC animated:YES];
}

#pragma mark --成员位置
- (void)sendMemberLocation
{
    ChooseLocationViewController *chooseMapVC = [ChooseLocationViewController new];
    chooseMapVC.type = MapTypeMember;
    [self.navigationController pushViewController:chooseMapVC animated:YES];
}

#pragma mark --文件
- (void)sendFile
{
    [self gotoSpaceVC];
}

#pragma mark --视频
- (void)sendVideo
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
    [self presentViewController:imagePicker animated:YES completion:NULL];
}



- (NSURL *)_convert2Mp4:(NSURL *)movUrl
{
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        NSString *mp4Path = [NSString stringWithFormat:@"%@/%d%d.mp4", [self dataPath], (int)[[NSDate date] timeIntervalSince1970], arc4random() % 100000];
        mp4Url = [NSURL fileURLWithPath:mp4Path];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}


- (NSString*)dataPath
{
    NSString *dataPath = [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer", NSHomeDirectory()];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dataPath]){
        [fm createDirectoryAtPath:dataPath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    return dataPath;
}

-(UIImage *)getThumbnailImage:(NSString *)videoURL

{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
