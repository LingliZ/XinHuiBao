//
//  GSBroadcastManager.h
//  RtSDK
//
//  Created by Gaojin Hsu on 3/11/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "GSBroadcastRoomDelegate.h"
#import "GSBroadcastQaDelegate.h"
#import "GSBroadcastChatDelegate.h"
#import "GSBroadcastInvestigationDelegate.h"
#import "GSBroadcastLodDelegate.h"
#import "GSBroadcastAudioDelegate.h"
#import "GSBroadcastVideoDelegate.h"
#import "GSBroadcastDocumentDelegate.h"
#import "GSBroadcastDesktopShareDelegate.h"
#import "GSBroadcastHongbaoDelegate.h"
#import "GSConnectInfo.h"
#import "GSDocView.h"
#import "GSQuestion.h"
#import "GSLodItem.h"
#import "GSVideoView.h"









/**
 *  接受问答数据模式
 */
typedef NS_ENUM(NSInteger, GSQAHistoryMode)
{
    /**
     *  接收问答历史数据
     */
    GSQAHistoryModeFetchAll = 0,
    
    /**
     *  只接受加入之后收到的历史问答数据
     */
    GSQAHistoryModeFetchFromNowOn,
};


/**
 采集视频按比例擦肩

 - GSCropMode4x3: 在竖屏采集是，将采集的视频按 w:h = 4:3 的比例裁剪
 - GSCropMode16x9:  在竖屏采集是，将采集的视频按 w:h = 9:16 的比例裁剪
 */
typedef NS_ENUM(NSInteger, GSCropMode)
{
    GSCropMode4x3,
    
    GSCropMode16x9,
};

/**
 *  日志等级
 */
typedef NS_ENUM(NSInteger, GSLogLevel){
    /**
     *  不输出日志
     */
    GSLogLevelOff,
    /**
     *  只输出错误日志
     */
    GSLogLevelError,
    /**
     *  输出错误和警告
     */
    GSLogLevelWarning,
    /**
     *  输出所有级别日志
     */
    GSLogLevelALL,
};


typedef NS_ENUM(NSInteger, GSFetchRoomNumberResult) {
    GSFetchRoomNumberResultSuccess,
    GSFetchRoomNumberResultNetworkError,
    GSFetchRoomNumberResultUnknownError,
};


typedef NS_ENUM(NSInteger, GSFetchLoginInformationResult)
{
    GSFetchLoginInformationResultSuccess,
    GSFetchLoginInformationResultNetworkError,
    GSFetchLoginInformationResultWebcastIDNotFound,
    GSFetchLoginInformationResultUnknowError,
    GSFetchLoginInformationResultJsonError,
};


@interface GSIDCInfo : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, assign) BOOL isCurrentIDC;

@end



/**
 *  GSBroadcastManager 是一个直播管理类，管理着所有的直播相关操作，包括加入直播，退出直播，发送信息等
 */
@interface GSBroadcastManager : NSObject<NSURLSessionDelegate>

/**
 * 初始化单实例
 */
+ (instancetype)sharedBroadcastManager;


/**
 *  通过webcastID获取roomNumber
 *
 *  @param webcastID  webcastID
 *  @param domain     域名
 *  @param completion 获取的结果
 */
- (void)fetchRoomNumberWithWebCastID:(NSString*)webcastID domain:(NSString*)domain completion:(void (^ __nullable)(NSString *roomNumber, GSFetchRoomNumberResult result))completion;


/**
 *  获取登陆相关信息:是否需要登录，是否需要观看密码，是否要第三方验证等信息。
 *
 *  @param domain      域名
 *  @param serviceType 服务类型
 *  @param roomNumber  房间号
 *  @param isSync      是否同步请求
 *  @param completion  登录信息结果
 */
- (void)fetchLoginInfomationWithDomain:(NSString*)domain serviceType:(GSBroadcastServiceType)serviceType roomNuber:(NSString*)roomNumber Synchronous:(BOOL)isSync completion:(void (^ __nullable)(NSDictionary *loginInfo, GSFetchLoginInformationResult result))completion
;

/**
 *  设置SDK日志输出级别
 *
 *  @param level 日志输出级别
 */
- (void)setLogLevel:(GSLogLevel)level;


/**
 * 与直播建立连接，此时并未加入直播，如果想真正加入直播，请在连接成功后调用join方法
 *
 * @param luanchCode 16进制字符串信息
 *
 * @return 操作是否成功
 *
 * @see - connectBroadcastWithConnectInfo:
 *
 */
- (BOOL)connectBroadcastWithLaunchCode:(NSString*)launchCode;


/**
 * 与直播建立连接，此时并未加入直播，如果想真正加入直播，请在连接成功后调用join方法
 * 
 * @param connectInfo 将要连接的房间的信息
 *
 * @return 操作是否成功
 *
 * @see - connectBroadcastWithLaunchCode:
 *
 * @see GSConnectInfo
 *
 */
- (BOOL)connectBroadcastWithConnectInfo:(GSConnectInfo*)connectInfo;


/**
 * 断开直播，清理资源
 */
- (void)invalidate;


#pragma mark -
#pragma mark Room Methods


/**
 * 加入直播
 * 请在合适的时机调用，一般在与直播成功建立连接后调用
 *
 * @return 加入操作是否成功
 *
 */
- (BOOL)join;

/**
 * 离开直播, 并根据bTerminated的值决定是否关闭直播, 如果身份是非组织者,设为NO
 *
 * @param bTerminated 退出直播的同时是否结束直播
 *
 * @return 操作是否成功
 *
 */
- (BOOL)leaveAndShouldTerminateBroadcast:(BOOL)bTerminated;

/**
 * 设置直播状态
 *
 * @param status 直播状态
 *
 * @return 操作是否成功
 *
 * @see GSBroadcastStatus
 *
 */
- (BOOL)setStatus:(GSBroadcastStatus)status;

/**
 * 设置录制模式是否开启
 * 
 * @param status 设置录制状态
 *
 * @return 操作是否成功
 *
 * @see GSBroadcastStatus
 *
 */
- (BOOL)setRecordingStatus:(GSBroadcastStatus)status;


/**
 *  获取直播运行时间，暂停等时间不计入。
 *
 *  @return 时间值，单位秒
 */
- (unsigned int)broadcastRunningTime;


/**
 * 设置直播相关信息
 * 其他用户会从相关回调中接受到该信息
 *
 * @param key 键信息
 *
 * @param value 值信息
 *
 * @return 操作是否成功
 *
 */
- (BOOL)setBroadcastInfo:(NSString*)key value:(long long)value;

/**
 * 打开指定用户麦克风
 *
 * @param userID 被打开麦克风的用户ID
 *
 * @return 操作是否成功
 *
 */
- (BOOL)activateUserMicrophone:(long long)userID;

/**
 * 关闭指定用户麦克风
 *
 * @param userID 被关闭麦克风的用户ID
 *
 * @return 操作是否成功
 *
 */
- (BOOL)inactivateUserMicrophone:(long long)userID;

/**
 * 打开指定用户摄像头
 *
 * @param userID 被打开摄像头的用户ID
 *
 * @return 操作是否成功
 *
 */
- (BOOL)activateUserCamera:(long long)userID;

/** 关闭指定用户摄像头
 *
 * @param userID 被关闭摄像头的用户ID
 *
 * @return 操作是否成功
 *
 */
- (BOOL)inactivateUserCamera:(long long)userID;

/** 踢出用户
 * 
 * @param userID 被踢出的用户ID
 * 
 * @return 操作是否成功
 *
 */
- (BOOL)ejectUser:(long long)userID;

/**
 * 邀请Web用户打开/关闭麦克风
 *
 * @param userID 目标用户的ID
 *
 * @param bOn 布尔值决定是否激活麦克风
 *
 * @return 操作是否成功
 *
 */
- (BOOL)inviteWebUser:(long long)userID toActivateMicrophone:(BOOL)bOn;

/**
 * 开始点名倒计时
 * 
 * @param number 倒计时的起始数
 * 
 * @return 操作是否成功
 *
 */
- (BOOL)checkinCountDownFrom:(int)number;

/**
 * 回应点名，签到
 *
 * @return 操作是否成功
 *
 */
- (BOOL)checkin;




/**
 * 广播一个消息
 *
 * @return 操作是否成功
 *
 */

- (BOOL)publishRoomNotifyBroadcastMsg:(NSString*)msg;




/**
 *  举手
 *
 *  @param extraData 保留字段，目前未使用，可直接传入空字符串
 *
 *  @return 操作是否成功
 */
- (BOOL)handUp:(NSString*)extraData;

/**
 *  手放下
 *
 *  @return 操作是否成功
 */
- (BOOL)handDown;

/**
 *  获取网络优化选项
 *
 *  @return 网络优化选项
 */
- (NSArray*)getIDCArray;

/**
 *  获取当前网络方案
 *
 *  @return 当前网络路线ID
 */
- (NSString*)currentIDC;

/**
 *  设置当前网路优化选项
 *
 *  @param ID 选项ID
 */
- (void)setCurrentIDC:(NSString*)ID;


/**
 重命名某个用户

 @param userID 将要被重命名的用户的userID
 @param newName 新的名字
 @return 操作是否成功
 */
- (BOOL)renameUser:(long long)userID newName:(NSString*)newName;

#pragma mark -
#pragma mark Lod Methods

- (BOOL)stopLod:(NSString*)lodID;


- (BOOL)pushUserQuantity2Web:(BOOL) bPush;


#pragma mark -
#pragma mark Audio Methods

/**
 * 打开自己的麦克风
 *
 * @return 操作是否成功
 *
 */
- (BOOL)activateMicrophone;

/**
 * 关闭自己的麦克风
 *
 * @return 操作是否成功
 *
 */
- (BOOL)inactivateMicrophone;

/**
 * 打开自己的喇叭
 *
 * @return 操作是否成功
 *
 */
- (BOOL)activateSpeaker;

/**
 * 关闭喇叭
 *
 * @return 操作是否成功
 *
 */
- (BOOL)inactivateSpeaker;



/**
 喇叭静音

 @param bMute YES表示静音，NO表示开启

 @return 操作是否成功
 */
- (BOOL)muteSpeaker:(BOOL)bMute;


/**
 麦克风静音
 
 @param bMute YES表示静音，NO表示开启
 
 @return 操作是否成功
 */
- (BOOL)muteMicrophone:(BOOL)bMute;


#pragma mark -
#pragma mark Video Methods


/**
 *  打开自己的摄像头； 不能用这个方法对已经打开的摄像头进行前后切换和设置landscape
 *
 *  @param backCamera 后置摄像头
 *  @param landscape  是否横向采集
 *
 *  @return 操作是否成功
 */
- (BOOL)activateCamera:(BOOL)backCamera landscape:(BOOL)landscape;

/**
 * 关闭自己的摄像头
 *
 * @return 操作是否成功
 *
 */
- (BOOL)inactivateCamera;


/**
 *  前后互切摄像头
 */
- (void)rotateCamera;



/**
 * 接受指定的摄像头视频流
 *
 * @param userID 所要接收的视频的ID
 *
 * @return 操作是否成功
 */
- (BOOL)displayVideo:(long long)userID;

/**
 * 关闭指定的摄像头视频流
 *
 * @param userID 所要拒绝接收的视频ID
 *
 * @return 操作是否成功
 *
 */
- (BOOL)undisplayVideo:(long long)userID;

/**
 * 激活一路视频
 *
 * @param userID 所要设置的视频ID
 *
 * @param active 布尔值决定是否要激活
 *
 */
- (BOOL)setVideo:(long long)userID active:(BOOL)active;


//
///**
// *   切换摄像头
// *
// *  @param backCamera YES表示切到后置摄像头，NO表示使用前置摄像头
// *  @param landscape  YES表示横屏
// */
//- (void)switchToBackCamera:(BOOL)backCamera landScape:(BOOL)landscape;
//


#pragma mark -
#pragma mark as

- (BOOL)closeDesktopShare;

#pragma mark -
#pragma mark doc


-(GSDocument*)publishDocOpenTwo:(NSString*)docFileName;

//-(void)publishDocOpen:(NSString*)docFileName;

/**
 *   发布端发布文档之前先打开文档
 *  @param docFileName 要打开的图片的文件名
 *   @return 返回打开文件的文件docId
 */
-(unsigned int)publishDocOpen:(NSString*)docFileName;







-(BOOL) publishDocRemoteOpen:(NSString*)docFileName  description:(NSString *)description;

/**
 *   发布端跳到文档的指定的页码
 *  @param docId  文档id
 *  @param pageId  页码id
 */
-(BOOL) publishDocGotoPage:(unsigned int)docId pageId:(unsigned int)pageId sync2other:(BOOL)sync2other;


/**
 *   发布端跳到文档的指定的页码的指定的动画步骤
 *  @param docId  文档id
 *  @param pageId  页码id
 *  @param step    当前页的动画步骤
 */
-(BOOL)publishDocGotoAnimation:(unsigned int)docId pageId:(unsigned int)pageId step:(int)step sync2other:(BOOL)sync2other;
-(BOOL)publishDocSaveToServer:(unsigned int)docId;


/**
 *   发布端关闭文档
 *   @param docId  文档的docId
 *   @return 返回关闭文档是否成功
 */
-(BOOL)publishDocClose:(unsigned int)docId;



-(BOOL)publishDocAddAnnotation:(unsigned int)docId  pageId:(unsigned int)pageId GSAnnoBase:(GSAnnoBase*)pAnno;

-(BOOL)publishDocRemoveAnnotation:(unsigned int)docId  pageId:(unsigned int)pageId GSAnnoBase:(GSAnnoBase*)pAnno;




/**
 *   发布端移除所有的标注
 *  @param docId  文档id
 *  @param pageId  页码id
 */
-(BOOL)publishDocRemoveAllAnnotation:(unsigned int)docId  pageId:(unsigned int)pageId;



/**
 *   发布端开始上传文件
 *  @param fileHandle  前面publishDocOpen打开的文件的文件句柄
 */
-(BOOL)publishDocTranslateBegin:(unsigned int  )fileHandle;



/**
 *   发布端上传文件数据
 *  @param fileHandle  上传文件的文件的docId
 *  @param pageHandle  页码id
 *  @param pageWidth   页码的宽度
 *  @param pageHeight  页码的高度
 *  @param bitCounts   图片的位数，32，64
 *  @param titleText   文件的名字
 *  @param fullText    文件的详细名字
 *  @param aniCfg       动画数据
 *  @param pageComment  页码描述内容
 *  @param data         文件数据
 ＊  @return   返回是否操作成功
 */
-(BOOL)publishDocTranslataData:(unsigned int  )fileHandle pageHandle:(unsigned int  )pageHandle pageWidth:(unsigned int  )pageWidth pageHeight:(unsigned int  )pageHeight bitCounts:(int)bitCounts  titleText:(NSString*)titleText fullText:(NSString*)fullText aniCfg:(NSString*)aniCfg pageComment:(NSString*)pageComment data:(NSData*)data;



/**
 *   发布端开始上传结束
 *  @param fileHandle  前面publishDocOpen打开的文件的docId
 *  @param bSuccess  前面publishDocTranslataData操作的返回结果
 ＊  @return   返回是否操作成功
 */
-(BOOL)publishDocTranslateEnd:(unsigned int  )fileHandle bSuccess:(BOOL)bSuccess;


/**
 *   发布端获得当前的打开的文档
 ＊  @return   返回当前打开的文档
 */
-(GSDocument*)publishDocGetCurrentDoc;



#pragma mark -
#pragma mark Chat Methods

/**
 * 发送私人消息给指定用户
 *
 * @param msg 发送的聊天信息数据
 *
 * @param userID 发送对象的ID
 *
 * @return 操作是否成功
 *
 * @see GSChatMessage
 *
 */
- (BOOL)sendMessage:(GSChatMessage*)msg toUser:(long long)userID;

/**
 * 发送消息给嘉宾
 *
 * @param 发送的聊天信息数据
 *
 * @return 操作是否成功
 *
 * @see GSChatMessage
 *
 */
- (BOOL)sendMessageToPanelist:(GSChatMessage*)msg;

/**
 * 发送公共消息
 *
 * @param 发送的聊天信息数据
 *
 * @return 操作是否成功
 *
 * @see GSChatMessage
 *
 */
- (BOOL)sendMessageToPublic:(GSChatMessage*)msg;

/**
 * 设置用户聊天权限
 *
 * @param userID 所要操作的目标用户ID
 *
 * @param enabled 布尔值决定是否禁止该用户的聊天功能
 *
 * @return 操作是否成功
 *
 */
- (BOOL)setUser:(long long)userID chatEnabled:(BOOL)enabled;


#pragma mark -
#pragma mark Qa Methods

/**
 * 发起提问
 *
 * @param questionContent 问题的内容
 *
 * @return 操作是否成功
 *
 */
- (BOOL)askQuestion:(NSString*)questionContent;

/**
 * 回答问题
 *
 * @param questionID 所回答的问题的ID
 *
 * @param answerContent 答案的内容
 *
 * @return 操作是否成功
 *
 */
- (BOOL)answerQuestion:(NSString*)questionID answer:(NSString*)answerContent;

/**
 * 设置问题是否发布
 * 
 * @param questionID 所要修改状态的问题的ID
 *
 * @param isPublished 布尔值决定是否发布该问题
 *
 * @return 操作是否成功
 *
 */
- (BOOL)setQuestion:(NSString*)questionID publish:(BOOL)isPublished;


#pragma mark -
#pragma mark Investigation Methods

/**
 * 提交问卷调查
 *
 * @param investigationID 所要提交的问卷调查的ID
 *
 * @param answersArray 问卷调查的答案，数组的对象为GSInvestigationMyAnswer的实例
 *
 * @return 操作是否成功
 *
 * @see GSInvestigationMyAnswer
 *
 */
- (BOOL)submitInvestigation:(NSString*)investigationID answers:(NSArray*)answersArray;


/**
 * 提交答题卡
 *
 * @param
 *
 * @param  itemIdArray  选中的项目
 *
 * @return 操作是否成功
 *
 * @see GSInvestigationMyAnswer
 *
 */
- (BOOL)cardSubmit:(NSArray*)itemIdArray;


/**
 * 组织者获取主讲人的权限
 *
 * @param
 *
 * @param  userId
 *
 * @return 操作是否成功
 *
 * @see roomGrantPresentor
 *
 */
-(BOOL)roomGrantPresentor:(long long)userId;


 

#pragma mark -
#pragma mark Hongbao

/**
 *  创建随机红包
 *
 *  @param money     金额
 *  @param count     份数
 *  @param timeLimit 有效期限制
 *  @param fixed     是否每份红包等额
 *  @param comment   评论
 *
 *  @return 红包ID
 */
- (NSString*)createHongbaoRandom:(unsigned)money count:(unsigned)count timeLimit:(unsigned)timeLimit fixed:(BOOL)fixed comment:(NSString*)comment;

/**
 *  创建定向红包
 *
 *  @param money           金额
 *  @param timeLimit       有效期限制
 *  @param receiveUserID   接受者userID
 *  @param receiveUserName 接受者userName
 *  @param comment         评论
 *
 *  @return 红包ID
 */
- (NSString*)createHongbaoForSomeBody:(unsigned)money timeLimit:(unsigned)timeLimit receiveUserID:(long long)receiveUserID receiveUserName:(NSString*)receiveUserName comment:(NSString*)comment;


/**
 *  抓红包
 *
 *  @param hongbaoID 红包ID
 *
 *  @return 操作是否成功
 */
- (BOOL)grabHongbao:(NSString*)hongbaoID;

/**
 *  查询哪些人抢到了这个红包
 *
 *  @param hongbaoID 红包ID
 *
 *  @return 操作是否成功
 */
- (BOOL)queryHongbaoGrabList:(NSString*)hongbaoID;

/**
 *  查询本次会议发过的所有红包
 *
 *  @return 操作是否成功
 */
- (BOOL)queryHonbaoList;

/**
 *  查询我抢到过的红包
 *
 *  @return 操作是否成功
 */
- (BOOL)queryMyHongbaoGrabList;


/**
 *  查询红包余额
 *
 *  @return 操作是否成功
 */
- (BOOL)queryHonbaoBalance;


#pragma mark - 
#pragma mark UserInfl

/**
 *  查询用户信息
 *
 *  @param userID 需要查询的用户的userID
 *
 *  @return 返回该用户的用户信息
 */
- (GSUserInfo*) queryUserInfoByID:(long long) userID;

/**
 *  查询自己的信息
 *
 *  @return 自己的用户信息
 */
- (GSUserInfo*) queryMyUserInfo;



#pragma mark -
#pragma mark Properties

/**
 * 设置接收问答模式， 默认为GSQAHistoryModeFetchAll
 *
 * @see GSQAHistoryMode
 *
 */
@property (nonatomic, assign)GSQAHistoryMode qaHistoryMode;

/**
 * 文档显示视图
 *
 * @see GSDocView
 *
 */
@property (nonatomic, weak) GSDocView *documentView;

/**
 *  摄像头预览显示视图
 */
@property (nonatomic, weak) GSVideoView *videoView;

/**
 * 直播代理
 *
 * @see GSBroadcastRoomDelegate
 *
 */
@property (nonatomic, weak)id<GSBroadcastRoomDelegate> broadcastRoomDelegate;

/**
 * 直播桌面共享代理
 *
 * @see GSBroadcastDesktopShareDelegate
 *
 */
@property (nonatomic, weak)id<GSBroadcastDesktopShareDelegate> desktopShareDelegate;

/**
 * 直播音频代理
 *
 * @see GSBroadcastAudioDelegate
 *
 */
@property (nonatomic, weak)id<GSBroadcastAudioDelegate> audioDelegate;

/**
 * 直播视频代理
 *
 * @see GSBroadcastVideoDelegate
 *
 */
@property (nonatomic, weak)id<GSBroadcastVideoDelegate> videoDelegate;

/**
 * 直播文档代理
 *
 * @see GSBroadcastDocumentDelegate
 *
 */
@property (nonatomic, weak)id<GSBroadcastDocumentDelegate> documentDelegate;

/**
 * 直播文字聊天代理
 *
 * @see GSBroadcastChatDelegate
 *
 */
@property (nonatomic, weak)id<GSBroadcastChatDelegate> chatDelegate;

/**
 * 直播问答代理
 *
 * @see GSBroadcastQaDelegate
 *
 */
@property (nonatomic, weak)id<GSBroadcastQaDelegate> qaDelegate;

/**
 * 直播问卷调查代理
 *
 * @see GSBroadcastInvestigationDelegate
 *
 */
@property (nonatomic, weak)id<GSBroadcastInvestigationDelegate> investigationDelegate;

/**
 *  插播代理
 */
@property (nonatomic, weak)id<GSBroadcastLodDelegate> lodDelegate;

/**
 *  红包代理
 */
@property (nonatomic, weak)id<GSBroadcastHongbaoDelegate> hongbaoDelegate;


/**
 *  是否使用后置摄像头
 */
@property (nonatomic, assign) BOOL usingBackCamera;

/**
 *  摄像头是否要landscape状态
 */
@property (nonatomic,  assign) BOOL cameraLandScape;

/**
 *  采集视频的的AVCaptureSession
 */
@property (nonatomic, strong) AVCaptureSession *avsession;

/**
 *  Portrait 模式下采集出的视频裁剪成宽高为4:3比例显示
 */
@property (nonatomic, assign) BOOL croppedWhileCaptureInPortraitMode DEPRECATED_MSG_ATTRIBUTE("建议使用publishVideoCropMode属性");



/**
 采集视频按比例裁剪
 */
@property (nonatomic, assign) GSCropMode publishVideoCropMode;

/**
 *  是否使用硬编
 */
@property (nonatomic, assign) BOOL hardwareAccelerateEncodeSupport;

/**
 *  视频是否使用硬解
 */
@property (nonatomic, assign) BOOL hardwareAccelerateVideoDecodeSupport;

/**
 *  桌面共享是否使用硬解,暂时不支持桌面共享硬解，为以后留的接口
 */
@property (nonatomic, assign) BOOL hardwareAccelerateASDecodeSupport;


/**
 *  是否开启美颜
 */
@property (nonatomic, assign) BOOL beautifyFace;



@property (nonatomic, assign) BOOL isCanCaptureCameraOut;

@end
