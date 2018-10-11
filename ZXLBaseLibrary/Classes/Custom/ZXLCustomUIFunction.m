//
//  ZXLCustomUIFunction.m
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/6/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLCustomUIFunction.h"
#import <ZXLUtilsDefined.h>
#import <ZXLProgramSetting.h>
#import <ZXLRouter.h>

void ZXLMessageBox(id <NSObject> strMsg) {
    ZXLMessageTitle(strMsg, nil);
}

void ZXLMessageTitle(id <NSObject> strMsg, NSString *strTitle) {
    ZXLMessageBlock(strMsg, strTitle, nil, nil);
}

void ZXLMessageBlock(id <NSObject> strMsg, NSString *strTitle, NSArray *ayBtn, void (^block)(int)) {
    ZXLMessageBlockWithDelegate(strMsg, strTitle, ayBtn, NO, nil, block);
}

void ZXLHTMLMessageBlock(id <NSObject> strMsg, NSString *strTitle, NSArray *ayBtn, void (^block)(int)) {
    ZXLMessageBlockWithDelegate(strMsg, strTitle, ayBtn, YES, nil, block);
}

void ZXLMessageBlockWithDelegate(id <NSObject> strMsg, NSString *strTitle, NSArray *ayBtn, BOOL bHTML, id delegate, void (^block)(int)) {
    NSCAssert(([strMsg isKindOfClass:[NSString class]] || [strMsg isKindOfClass:[NSAttributedString class]]), @"类型错误, strMsg必须是NSString或者NSAttributedString");
    if (!([strMsg isKindOfClass:[NSString class]] || [strMsg isKindOfClass:[NSAttributedString class]])) {
        return;
    }
    if (strTitle == nil || [strTitle length] < 1) {
        strTitle = [NSString stringWithFormat:@"%@", @"温馨提示"];
    }

    NSString *nsOk = @"确定";
    NSString *nsCancel = @"";
    if (ayBtn) {
        if ([ayBtn count] == 2) {
            nsCancel = ayBtn[0];
            nsOk = ayBtn[1];
        }

        if ([ayBtn count] == 1) {
            nsOk = ayBtn[0];
        }
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:strTitle message:nil preferredStyle:UIAlertControllerStyleAlert];

    if ([strMsg isKindOfClass:[NSAttributedString class]]) {
        [alertController setValue:strMsg forKey:@"attributedMessage"];
    } else {
        if (bHTML) {
            NSAttributedString *messageAtt = [[NSAttributedString alloc] initWithData:[(NSString *)strMsg dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            [alertController setValue:messageAtt forKey:@"attributedMessage"];
        } else {
            alertController.message = (NSString *)strMsg;
        }
    }

    if (ZXLUtilsISNSStringValid(nsCancel)) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:nsCancel style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (block) {
                block(0);
            }
        }];

        [cancel setValue:[ZXLProgramSetting tipsBlackColor] forKey:@"_titleTextColor"];
        [alertController addAction:cancel];
    }

    UIAlertAction *ok = [UIAlertAction actionWithTitle:nsOk style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (block) {
            block(1);
        }
    }];

    [ok setValue:[ZXLProgramSetting mainColor] forKey:@"_titleTextColor"];
    [alertController addAction:ok];
    [ZXLRouter presentViewController:alertController animated:YES completion:nil];
}
