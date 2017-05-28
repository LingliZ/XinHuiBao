//
//  GXLiveCastViewController.m
//  GXApp
//
//  Created by zhudong on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "XHBLiveCastViewController.h"
#import <RtSDK/RtSDK.h>
#import "UIView+GXLoadingTips.h"
#import "IQKeyboardManager.h"
#import "GXQuestionAndAnswerView.h"
#import "XHBCommonSize.h"
#import "XHBInteractionView.h"


@interface XHBLiveCastViewController ()<GSBroadcastQaDelegate, GSBroadcastRoomDelegate, GSBroadcastVideoDelegate, GSBroadcastDesktopShareDelegate, GSBroadcastAudioDelegate, UIAlertViewDelegate>
@property (nonatomic,assign) BOOL hasOrientation;
@property (nonatomic,assign) CGRect videoViewRect;
@property (nonatomic,strong) GSVideoView *videoView;
@property (nonatomic,strong) UIView *videoControlView;
@property (nonatomic,strong) GSConnectInfo *connectInfo;
@property (strong, nonatomic) GSBroadcastManager *broadcastManager;
@property (assign, nonatomic) long long currentActiveUserID; // 当前激活的视频ID
@property (assign, nonatomic)BOOL isCameraVideoDisplaying;
@property (assign, nonatomic)BOOL isLodVideoDisplaying;
@property (assign, nonatomic)BOOL isDesktopShareDisplaying;
@property (nonatomic,strong) UIView *coverView;
@property (atomic,assign) BOOL isInvalidate;
@property (atomic,strong) NSMutableArray *questionArray;
@property (nonatomic,assign) long long userId;
@property (nonatomic,assign) long long personCount;
@property (nonatomic,strong) UILabel *personCountLabel;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) GXQuestionAndAnswerView *questionView;
@property (nonatomic,strong) UILabel *countLable;
@end

@implementation XHBLiveCastViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.questionArray = [NSMutableArray array];
    self.isInvalidate = NO;
    self.navigationController.navigationBar.translucent = YES;
    [self initBroadCastManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self timer];
}
- (void)initBroadCastManager
{
    self.broadcastManager = [GSBroadcastManager sharedBroadcastManager];
    self.questionView.broadcastManager = self.broadcastManager;
    self.broadcastManager.broadcastRoomDelegate = self;
    self.broadcastManager.videoDelegate = self;
    self.broadcastManager.desktopShareDelegate = self;
    self.broadcastManager.audioDelegate = self;
    self.broadcastManager.qaDelegate = self;
    
    if (![_broadcastManager connectBroadcastWithConnectInfo:self.connectInfo]) {
        [self.coverView removeFromSuperview];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"WrongConnectInfo", @"参数配置不正确") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频直播";
    [self setupUI];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
}
- (void)keyboardWillChangeFrameNotification:(NSNotification *)notify{
    NSDictionary *keyboardDict = notify.userInfo;
    CGRect keyboardFrame = [keyboardDict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    ;
    CGFloat offsetY = keyboardFrame.origin.y - kScreenSize.height;
    self.view.transform = CGAffineTransformMakeTranslation(0, offsetY);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.coverView removeFromSuperview];
    [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
    [self.broadcastManager invalidate];
    [self.timer invalidate];
    self.timer = nil;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
    [self.broadcastManager invalidate];
}

- (GSConnectInfo *)connectInfo{
    if (_connectInfo == nil) {
        _connectInfo = [[GSConnectInfo alloc] init];
        _connectInfo.domain = @"guoxin.gensee.com";
        _connectInfo.serviceType = GSBroadcastServiceTypeWebcast;
        
        NSString *nameStr;
        if ([GXUserInfoTool isLogin]) {
            NSString *accountStr = [NSString stringWithFormat:@"%zd", [[GXUserInfoTool getLoginAccount] integerValue]];
            nameStr = [NSString stringWithFormat:@"%@",[accountStr  substringToIndex:2]];
            if (accountStr.length > 4) {
                for (int i = 0; i < accountStr.length - 4; i++) {
                    nameStr = [NSString stringWithFormat:@"%@*",nameStr];
                }
            }
            
            nameStr = [NSString stringWithFormat:@"%@%@",nameStr,[accountStr substringFromIndex:(accountStr.length - 2)]];
        }else{
            nameStr = [NSString stringWithFormat:@"游客%04zd", arc4random_uniform(10000)];
        }
        [GXUserdefult setObject:nameStr forKey:@"nameStr"];
        _connectInfo.nickName = nameStr;
        _connectInfo.loginName = nameStr;
        _connectInfo.loginPassword = @"333333";
    
        _connectInfo.roomNumber = @"77097255";
//         _connectInfo.roomNumber = @"48690876";
        _connectInfo.watchPassword = @"333333";
        _connectInfo.oldVersion = YES;
    }
    return _connectInfo;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
    [self.broadcastManager invalidate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.isInvalidate) {
            [self.broadcastManager invalidate];
            GXLog(@"self.broadcastManager invalidate");
        }
    });
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark GSBroadcastRoomDelegate

// 直播初始化代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastConnectResult:(GSBroadcastConnectResult)result
{
    switch (result) {
        case GSBroadcastConnectResultSuccess:
        {
 
            // 直播初始化成功，加入直播
            [self.broadcastManager activateSpeaker];
            [self.broadcastManager setLogLevel:GSLogLevelError];
            BOOL result = [self.broadcastManager join];
            
            if (!result) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:  @"操作过于频繁,请退出直播后重新进入" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                alertView.delegate = self;
                [alertView show];
            }
            break;

            
        case GSBroadcastConnectResultInitFailed:
            
        case GSBroadcastConnectResultJoinCastPasswordError:
            
        case GSBroadcastConnectResultWebcastIDInvalid:
            
        case GSBroadcastConnectResultRoleOrDomainError:
            
        case GSBroadcastConnectResultLoginFailed:
            
        case GSBroadcastConnectResultNetworkError:
            
        case GSBroadcastConnectResultWebcastIDNotFound:
            
        default:
            {
                [self.coverView removeFromSuperview];
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:  NSLocalizedString(@"BroadcastConnectionError",  @"直播连接失败提示") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",  @"确认") otherButtonTitles:nil, nil];
                [alertView show];
            }
            break;
        }
    }
}

/*
 直播连接代理
 rebooted为YES，表示这次连接行为的产生是由于根服务器重启而导致的重连
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastJoinResult:(GSBroadcastJoinResult)joinResult selfUserID:(long long)userID rootSeverRebooted:(BOOL)rebooted;
{
    
    NSString * errorMsg = nil;
    
    switch (joinResult) {
            
            /**
             *  直播加入成功
             */
            
        case GSBroadcastJoinResultSuccess:
        {
            GXLog(@"加入直播成功");
            // 服务器重启导致重连的相应处理
            // 服务器重启的重连，直播中的各种状态将不再保留，如果想要实现重连后恢复之前的状态需要在本地记住，然后再重连成功后主动恢复。i
            
            [self.coverView removeFromSuperview];
            if (rebooted) {
                
                
            }
            
            break;
        }
            
            /**
             *  未知错误
             */
        case GSBroadcastJoinResultUnknownError:
            errorMsg = @"未知错误";
            break;
            /**
             *  直播已上锁
             */
        case GSBroadcastJoinResultLocked:
            errorMsg = @"直播已上锁";
            break;
            /**
             *  直播组织者已经存在
             */
        case GSBroadcastJoinResultHostExist:
            errorMsg = @"直播组织者已经存在";
            break;
            /**
             *  直播成员人数已满
             */
        case GSBroadcastJoinResultMembersFull:
            errorMsg = @"直播成员人数已满";
            break;
            /**
             *  音频编码不匹配
             */
        case GSBroadcastJoinResultAudioCodecUnmatch:
            errorMsg = @"音频编码不匹配";
            break;
            /**
             *  加入直播超时
             */
        case GSBroadcastJoinResultTimeout:
            errorMsg = @"加入直播超时";
            break;
            /**
             *  ip被ban
             */
        case GSBroadcastJoinResultIPBanned:
            errorMsg = @"ip地址被ban";
            
            break;
            /**
             *  组织者还没有入会，加入时机太早
             */
        case GSBroadcastJoinResultTooEarly:
            errorMsg = @"直播尚未开始";
            break;
            
        default:
        {
            [self.coverView removeFromSuperview];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:  NSLocalizedString(@"BroadcastConnectionError",  @"直播连接失败提示") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",  @"确认") otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
    }
    
}


// 直播状态改变代理
- (void)broadcastManager:(GSBroadcastManager *)manager didSetStatus:(GSBroadcastStatus)status
{
    
}

// 自己离开直播代理
- (void)broadcastManager:(GSBroadcastManager*)manager didSelfLeaveBroadcastFor:(GSBroadcastLeaveReason)leaveReason
{
    [_broadcastManager invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark GSBroadcastVideoDelegate

// 视频模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveVideoModuleInitResult:(BOOL)result
{
    
}

// 摄像头是否可用代理
- (void)broadcastManager:(GSBroadcastManager*)manager isCameraAvailable:(BOOL)isAvailable
{
    
}

// 摄像头打开代理
- (void)broadcastManagerDidActivateCamera:(GSBroadcastManager*)manager
{
    
}

// 摄像头关闭代理
- (void)broadcastManagerDidInactivateCamera:(GSBroadcastManager*)manager
{
    
}

// 收到一路视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserJoinVideo:(GSUserInfo *)userInfo
{
    // 判断是否是插播，插播优先级比摄像头视频大
    if (userInfo.userID == LOD_USER_ID)
    {
        //为了删掉最后一帧的问题， 收到新数据的时候GSVideoView的videoLayer自动创建
        [_videoView.videoLayer removeFromSuperlayer];
        _videoView.videoLayer = nil;
        
        // 如果之前有摄像头视频作为直播视频，先要取消订阅摄像头视频
        if (_isCameraVideoDisplaying) {
            [_broadcastManager undisplayVideo:_currentActiveUserID];
        }
        
        [_broadcastManager displayVideo:LOD_USER_ID];
        _isLodVideoDisplaying = YES;
    }
}

// 某个用户退出视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserQuitVideo:(long long)userID
{
    // 判断是否是插播结束
    if (userID == LOD_USER_ID)
    {
        //为了删掉最后一帧的问题， 收到新数据的时候GSVideoView的videoLayer自动创建
        [_videoView.videoLayer removeFromSuperlayer];
        _videoView.videoLayer = nil;
        
        _isLodVideoDisplaying = NO;
        
        // 如果之前有摄像头视频在直播，需要恢复之前的直播视频
        if (_currentActiveUserID != 0) {
            [_broadcastManager displayVideo:_currentActiveUserID];
        }
        
        
    }
    
}

// 某一路摄像头视频被激活
- (void)broadcastManager:(GSBroadcastManager*)manager didSetVideo:(GSUserInfo*)userInfo active:(BOOL)active
{
    
    if (active)
    {
        // 桌面共享和插播的优先级比摄像头视频大
        if (!_isDesktopShareDisplaying && !_isLodVideoDisplaying) {
            
            // 订阅当前激活的视频
            [_broadcastManager displayVideo:userInfo.userID];
            _currentActiveUserID = userInfo.userID;
            _isCameraVideoDisplaying = YES;
            _videoView.videoLayer.hidden = NO;
        }
    }
    else
    {
        if (userInfo.userID == _currentActiveUserID) {
            _isCameraVideoDisplaying = NO;
            _currentActiveUserID = 0;
            [_broadcastManager undisplayVideo:userInfo.userID];
            _videoView.videoLayer.hidden = YES;
        }
    }
}

// 某一路视频被订阅代理
- (void)broadcastManager:(GSBroadcastManager*)manager didDisplayVideo:(GSUserInfo*)userInfo
{
    
}

// 某一路视频取消订阅代理
- (void)broadcastManager:(GSBroadcastManager*)manager didUndisplayVideo:(long long)userID
{
}


// 摄像头或插播视频每一帧的数据代理，软解
- (void)broadcastManager:(GSBroadcastManager*)manager userID:(long long)userID renderVideoFrame:(GSVideoFrame*)videoFrame
{
    // 指定Videoview渲染每一帧数据
    [_videoView renderVideoFrame:videoFrame];
}


// 硬解数据从这个代理返回
- (void)OnVideoData4Render:(long long)userId width:(int)nWidth nHeight:(int)nHeight frameFormat:(unsigned int)dwFrameFormat displayRatio:(float)fDisplayRatio data:(void *)pData len:(int)iLen
{
    
    
    // 指定Videoview渲染每一帧数据
    [_videoView hardwareAccelerateRender:pData size:iLen dwFrameFormat:dwFrameFormat];
}

/**
 *  手机摄像头开始采集数据
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 */
- (BOOL)broadcastManagerDidStartCaptureVideo:(GSBroadcastManager*)manager
{
    return NO;
}

/**
 手机摄像头停止采集数据
 */
- (void)broadcastManagerDidStopCaptureVideo:(GSBroadcastManager*)manager
{
}
#pragma mark -
#pragma mark GSBroadcastDesktopShareDelegate

// 桌面共享视频连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveDesktopShareModuleInitResult:(BOOL)result;
{
}

// 开启桌面共享代理
- (void)broadcastManager:(GSBroadcastManager*)manager didActivateDesktopShare:(long long)userID
{
    _isDesktopShareDisplaying = YES;
    
    _videoView.videoLayer.hidden = YES;
    _videoView.movieASImageView.hidden = NO;
    
    // 桌面共享时，需要主动取消订阅当前直播的摄像头视频
    if (_currentActiveUserID != 0) {
        [_broadcastManager undisplayVideo:_currentActiveUserID];
    }
}


// 桌面共享视频每一帧的数据代理, 软解数据
- (void)broadcastManager:(GSBroadcastManager*)manager renderDesktopShareFrame:(UIImage*)videoFrame
{
    // 指定Videoview渲染每一帧数据
    if (_isDesktopShareDisplaying) {
        [_videoView renderAsVideoByImage:videoFrame];
    }
    
}

/**
 *  桌面共享每一帧的数据, 硬解； 暂不支持
 *
 */
- (void)OnAsData:(unsigned char*)data dataLen: (unsigned int)dataLen width:(unsigned int)width height:(unsigned int)height
{
    
}

// 桌面共享关闭代理
- (void)broadcastManagerDidInactivateDesktopShare:(GSBroadcastManager*)manager
{
    _videoView.videoLayer.hidden = YES;
    _videoView.movieASImageView.hidden = YES;
    
    // 如果桌面共享前，有摄像头视频在直播，需要在结束桌面共享后恢复
    if (_currentActiveUserID != 0)
    {
        _videoView.videoLayer.hidden = NO;
        [_broadcastManager displayVideo:_currentActiveUserID];
    }
    _isDesktopShareDisplaying = NO;
}

#pragma mark -
#pragma mark GSBroadcastAudioDelegate

// 音频模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveAudioModuleInitResult:(BOOL)result
{
    
}

// 问题的状态改变代理，包括收到一个新问题，问题被发布，取消发布等
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager question:(GSQuestion*)question updatesOnStatus:(GSQaStatus)status
{
    
    switch (status) {
        case GSQaStatusNewAnswer:
        {
            [_questionArray addObject:question];
        }
            
            break;
            
        case GSQaStatusQuestionPublish:
        {
            if (question.ownerID!= self.currentActiveUserID) {
                [_questionArray addObject:question];
            }
        }
            break;
            
            
        case GSQaStatusQuestionCancelPublish:
        {
#pragma mark--待处理
            for (int i=0; i<[_questionArray count]; i++) {
                if ([question.questionID isEqualToString:((GSQuestion*)self.questionArray[i]).questionID]) {
                    [_questionArray removeObjectAtIndex:i];
                }
            }
            break;
        }
            
            break;
            
        case GSQaStatusNewQuestion:
        {
            // 如果是自己提的问题，可以看到，如果是别人提的问题，要发布了才能看到
//            [_questionArray addObject:question];
            if (question.ownerID == self.currentActiveUserID) {
                [_questionArray addObject:question];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveOtherUser:(GSUserInfo*)userInfo
{
    self.personCount++;
    self.countLable.text = [NSString stringWithFormat:@"(在线%zd人)",2000 + self.personCount];
}


- (void)broadcastManager:(GSBroadcastManager*)manager didLoseOtherUser:(long long)userID
{
    self.personCount--;
    self.countLable.text = [NSString stringWithFormat:@"(在线%zd人)",2000 + self.personCount];
}

- (NSTimer *)timer{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshQuestions) userInfo:nil repeats:true];
    }
    return _timer;
}

- (void)refreshQuestions{
    self.questionView.questionsArrayM = self.questionArray;
}
    
- (void)setupUI
{
    self.videoViewRect = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, kScreenSize.width, kVideoHeight);
    self.videoView = [[GSVideoView alloc]initWithFrame:self.videoViewRect];
    [self.view addSubview:self.videoView];
    UIView *controlV = [[UIView alloc] init];
    controlV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:controlV];
    [controlV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.videoView);
        make.height.equalTo(@(kVideoControlViewHeight));
    }];
    [self.view bringSubviewToFront:controlV];
    controlV.hidden = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"sp_icon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(controlBtnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [controlV addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(controlV);
        make.right.equalTo(controlV).offset(-kMargin);
    }];

    self.videoControlView = controlV;
    self.hasOrientation = NO;
    //单击显示控制页面
    UITapGestureRecognizer *oneTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTapAction)];
    oneTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.videoView addGestureRecognizer:oneTapGestureRecognizer];
    //双击全屏
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rotationVideoView)];
    tapGes.numberOfTapsRequired = 2;
    [self.videoView addGestureRecognizer:tapGes];
    self.videoView.videoViewContentMode = GSVideoViewContentModeRatioFit;
    
    XHBInteractionView *centerView = [[XHBInteractionView alloc] init];
    [self.view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(kBtnViewHeight));
    }];
    self.countLable = centerView.countLable;
    GXQuestionAndAnswerView *questonV = [[GXQuestionAndAnswerView alloc] init];
    self.questionView = questonV;
    __weak typeof (self) weakSelf = self;
    questonV.questionViewDelegate = ^(BOOL isOpen){
        if (isOpen) {
            [weakSelf timer];
        }else{
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
        }
    };
    
    
    [self.view addSubview:questonV];
    NSInteger questionH = SCREEN_MAX_LENGTH - 64 - kBtnViewHeight - kVideoHeight;
    [questonV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(centerView.mas_bottom);
        make.height.equalTo(@(questionH));
    }];
    
    
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    coverView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [coverView showLoadingWithTitle:@"正在加载中..."];
    self.coverView = coverView;
    [self.view addSubview:coverView];
}
- (void)controlBtnClick{
    [self rotationVideoView];
}

#pragma mark - videoView
- (void)oneTapAction{
    [self.view endEditing:YES];
    self.videoControlView.hidden = NO;
    self.videoControlView.alpha = 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.videoControlView.alpha = 0;
        } completion:^(BOOL finished) {
            self.videoControlView.hidden = YES;
        }];
        
    });
}

- (void)rotationVideoView {
    [self.view endEditing:YES];//收起键盘
    //强制旋转
    if (!self.hasOrientation) {
        [self.view bringSubviewToFront:self.videoView];
        [self.view bringSubviewToFront:self.videoControlView];
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
            self.videoView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
            self.hasOrientation = YES;

            self.navigationController.navigationBarHidden = YES;
            [UIApplication sharedApplication].statusBarHidden = YES;
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformInvert(CGAffineTransformMakeRotation(0));
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            self.videoView.frame = self.videoViewRect;
            self.hasOrientation = NO;
            self.navigationController.navigationBarHidden = NO;
            [UIApplication sharedApplication].statusBarHidden = NO;
        }];
    }
}

@end
