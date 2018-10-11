//
//  ZXLThirdtPartyManager.m
//  ZXLThirdPartyModule
//
//  Created by 张小龙 on 2018/6/26.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLThirdtPartyManager.h"
#import "ZXLThirdPartyShareModel.h"
#import <ZXLUtilsDefined.h>
#import <ZXLRouter.h>
#import <NSString+Route.h>

#import <SVProgressHUD/SVProgressHUD.h>

#import <WechatOpenSDK/WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>

#define kWTShareQQSuccess @"0"
#define kWTShareQQFail    @"-4"


//微信Appid
#define ZXLZXZWeiXinAppId       @"wx16d282cd9c64b218"
//腾讯Appid
#define ZXLZXZTencentAppId      @"101366857"

@interface ZXLThirdtPartyManager()<WXApiDelegate,TencentSessionDelegate,TencentLoginDelegate>
@property (nonatomic, strong) TencentOAuth * tencentOAuth;
@property (nonatomic, copy) SendThirdLoginInfo sendThirdLoginInfo;
@property (nonatomic, strong) ZXLThirdPartyShareModel *shareModel;
@end

@implementation ZXLThirdtPartyManager

+ (ZXLThirdtPartyManager *)manager{
    static dispatch_once_t pred = 0;
    __strong static ZXLThirdtPartyManager * manager = nil;
    dispatch_once(&pred, ^{
        manager = [[ZXLThirdtPartyManager alloc] init];
    });
    return manager;
}

-(instancetype)init{
    if (self = [super init]) {
        //微信注册
        [ZXLThirdtPartyManager registerWeiXinAppId];
        
        //QQ注册
        NSString *tencentAppId = [ZXLThirdtPartyManager tencentAppId];
        if (ZXLUtilsISNSStringValid(tencentAppId)) {
           self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:tencentAppId andDelegate:self];
        }
    }
    return self;
}

+(NSString *)weiXinAppId{
    return ZXLZXZWeiXinAppId;
}

+(void)registerWeiXinAppId{
    NSString *strAppId = [ZXLThirdtPartyManager weiXinAppId];
    if (ZXLUtilsISNSStringValid(strAppId)) {
        [WXApi registerApp:strAppId];
    }
}

+(NSString *)tencentAppId{
    return ZXLZXZTencentAppId;
}

-(BOOL)isWXAppInstalled{
    return [WXApi isWXAppInstalled];
}

-(BOOL)isQQInstalled{
    return [QQApiInterface isQQInstalled];
}

-(BOOL)openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    BOOL bResult = YES;
    NSString *tencentAppId = [ZXLThirdtPartyManager tencentAppId];
    NSString *weiXinAppId = [ZXLThirdtPartyManager weiXinAppId];
    if ((ZXLUtilsISNSStringValid(weiXinAppId) &&[url.relativeString rangeOfString:weiXinAppId].location != NSNotFound) || (ZXLUtilsISDictionaryValid(options) && [options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"])){
        bResult = [WXApi handleOpenURL:url delegate:self];
    }
    else if ((ZXLUtilsISNSStringValid(tencentAppId)&&[url.relativeString rangeOfString:tencentAppId].location != NSNotFound) || (ZXLUtilsISDictionaryValid(options) && [options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.mqq"])){
        
        NSString * urlStr = url.absoluteString;
        NSArray * array = [urlStr componentsSeparatedByString:@"error="];
        if (array.count > 1) {
            NSString * lastStr = [array lastObject];
            NSArray * lastStrArray = [lastStr componentsSeparatedByString:@"&"];
            
            NSString * resultStr = [lastStrArray firstObject];
            if ([resultStr isEqualToString:kWTShareQQSuccess]) {
                [SVProgressHUD showInfoWithStatus:@"分享成功"];//分享成功-QQ
            }else if ([resultStr isEqualToString:kWTShareQQFail]){
                [SVProgressHUD showInfoWithStatus:@"取消分享"];
            }
        }
        
        bResult = [TencentOAuth HandleOpenURL:url];
    }
    
    return bResult;
}

#pragma mark - WXApiDelegate 从微信那边分享过来传回一些数据调用的方法
/*! @brief 发送一个sendReq后，收到微信的回应
 *
 // 成功回来
 // errCode  0
 // type     0
 
 // 取消分享回来
 // errCode -2
 // type 0
 
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 */
-(void) onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (resp.errCode == 0) {
            [SVProgressHUD showWithStatus:@"微信登录中"];
            NSString *code = aresp.code;
            if (self.sendThirdLoginInfo) {
                self.sendThirdLoginInfo(code, @"nil");
                self.sendThirdLoginInfo = nil;
            }
        }else{
            ZXLLog(@"微信授权失败!");
            [SVProgressHUD showErrorWithStatus:@"微信授权失败"];
        }
    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]){
        if (resp.errCode == 0) {
            [SVProgressHUD showInfoWithStatus:@"分享成功"];//分享成功-WX
        }else{
            [SVProgressHUD showInfoWithStatus:@"取消分享"];
        }
        
    }
}

#pragma mark - TencentSessionDelegate

//委托
- (void)tencentDidLogin{
    [_tencentOAuth getUserInfo];
}

- (void)getUserInfoResponse:(APIResponse *)response{
    if (response.retCode == URLREQUEST_SUCCEED){
        [SVProgressHUD showWithStatus:@"QQ登录中"];
        if (self.sendThirdLoginInfo) {
            self.sendThirdLoginInfo([_tencentOAuth accessToken], @"nil");
            self.sendThirdLoginInfo = nil;
        }
    }
    else{
        ZXLLog(@"QQ授权失败!");
        [SVProgressHUD showErrorWithStatus:@"QQ授权失败"];
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled{
    
}

- (void)tencentDidNotNetWork{
    
}

-(void)shareTo:(ZXLShareType)type shareInfo:(ZXLThirdPartyShareModel *)model{
    self.shareModel = model;
    switch (type) {
        case ZXLShareTypeWeiXinSession:
        case ZXLShareTypeWeiXinTimeline:
        {
            if (![self isWXAppInstalled]) {
                [SVProgressHUD showInfoWithStatus:@"未安装微信!"];
                return;
            }
            
            WXMediaMessage * message = [WXMediaMessage message];
            message.title = model.title;
            [message setThumbImage:[model thumbImage]];
            message.description = model.content;
            
            WXWebpageObject * ext = [WXWebpageObject object];
            ext.webpageUrl = model.urlString;
            message.mediaObject = ext;
            
            SendMessageToWXReq * req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = (type == ZXLShareTypeWeiXinSession ? WXSceneSession: WXSceneTimeline);
            [WXApi sendReq:req];
            
        }
            break;
        case ZXLShareTypeQQ:
        {
            //检查是否安装了QQ
            if (![self isQQInstalled]) {
                [SVProgressHUD showInfoWithStatus:@"未安装QQ!"];
                return;
            }
            
            QQApiNewsObject * newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:model.urlString]
                                                                 title:model.title
                                                           description:model.content
                                                      previewImageData:UIImageJPEGRepresentation([model thumbImage], 0.5f)];
            
            SendMessageToQQReq *req = [[SendMessageToQQReq alloc]init];
            req.message = newsObj;
            req.type = ESENDMESSAGETOQQREQTYPE;
            //将内容分享到qq
            [QQApiInterface sendReq:req];
            
        }
            break;
        case ZXLShareTypeMessage:
        {
            NSMutableDictionary *pDict = [NSMutableDictionary dictionary];
            [pDict setValue:@"test" forKey:@"title"];
            [pDict setValue:[NSString stringWithFormat:@"%@%@ 点击链接查看邀请",model.title,model.urlString] forKey:@"body"];
            [[ZXLRouter manager] present:[NSString route:@"messageCompose" addParams:pDict]];
        }
            break;
        default:
            break;
    }
}

-(void)getUserInfoWithLoginType:(ZXLThirdPartyLoginType)type loginReturnInfo:(SendThirdLoginInfo)loginReturnInfo{
    self.sendThirdLoginInfo = loginReturnInfo;
    
    switch (type) {
        case ZXLThirdPartyLoginTypeWeiXin:
        {
            //构造SendAuthReq结构体
            SendAuthReq* req =[[SendAuthReq alloc ] init ];
            req.scope = @"snsapi_userinfo" ;
            //第三方向微信终端发送一个SendAuthReq消息结构
            [WXApi sendReq:req];
        }
            break;
        case ZXLThirdPartyLoginTypeTencent:
        {
            if (self.tencentOAuth) {
                [self.tencentOAuth authorize:@[/** 获取用户信息 */
                                           kOPEN_PERMISSION_GET_USER_INFO,
                                           /** 移动端获取用户信息 */
                                           kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                           /** 获取登录用户自己的详细信息 */
                                           kOPEN_PERMISSION_GET_INFO]];
            }

        }
            break;
            
        default:
            break;
    }
}
@end
