//
//  ZXLWKWebViewViewController.h
//  ZXZ
//
//  Created by 张小龙 on 2017/2/27.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <ZXLUIViewController.h>

@class ZXLTaskInfoModel;

typedef void (^WVJBResponseCallback)(id responseData);

@interface ZXLWKWebViewViewController : ZXLUIViewController

@property (nonatomic, copy)   NSString * uploadTaskID;
@property (nonatomic, readonly)WKWebView * wkWebView;
@property (nonatomic ,copy) NSString * nsWebURL;

-(void)closeAudio;
-(void)onRefresh;
-(void)onRequestURL:(NSString *)strURL;

-(void)addResponseCallback:(WVJBResponseCallback)responseCallback forHandler:(NSString *)handlerName;
-(void)removeResponseCallback:(NSString *)handlerName;
-(void)responseCallback:(NSString *)handlerName object:(id)object;
-(void)submitFinishWithTaskInfo:(ZXLTaskInfoModel *)taskInfo;
@end
