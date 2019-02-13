//
//  ZXLUIAlertMessage.h
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/6/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 提示框 strMsg可以传NSString或者NSAttributedString

FOUNDATION_EXPORT void ZXLUIAlertMessageBox(id<NSObject> message);

FOUNDATION_EXPORT void ZXLUIAlertMessageTitle(id<NSObject> message,NSString* title);

FOUNDATION_EXPORT void ZXLUIAlertMessageBlock(id<NSObject> message,NSString* title, NSArray* buttons,void (^block)(int index));

FOUNDATION_EXPORT void ZXLUIAlertHTMLMessageBlock(id<NSObject> message,NSString* title, NSArray* buttons,void (^block)(int index));

FOUNDATION_EXPORT void ZXLUIAlertMessageBlockWithDelegate(id<NSObject> message,NSString* title, NSArray* buttons,BOOL bHTML,id delegate, void (^block)(int index));
