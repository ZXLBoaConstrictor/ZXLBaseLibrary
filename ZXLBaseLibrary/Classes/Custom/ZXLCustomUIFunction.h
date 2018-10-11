//
//  ZXLCustomUIFunction.h
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/6/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 提示框 strMsg可以传NSString或者NSAttributedString

FOUNDATION_EXPORT void ZXLMessageBox(id<NSObject> strMsg);

FOUNDATION_EXPORT void ZXLMessageTitle(id<NSObject> strMsg,NSString* strTitle);

FOUNDATION_EXPORT void ZXLMessageBlock(id<NSObject> strMsg,NSString* strTitle, NSArray* ayBtn,void (^block)(int index));

FOUNDATION_EXPORT void ZXLHTMLMessageBlock(id<NSObject> strMsg,NSString* strTitle, NSArray* ayBtn,void (^block)(int index));

FOUNDATION_EXPORT void ZXLMessageBlockWithDelegate(id<NSObject> strMsg,NSString* strTitle, NSArray* ayBtn,BOOL bHTML,id delegate, void (^block)(int index));
