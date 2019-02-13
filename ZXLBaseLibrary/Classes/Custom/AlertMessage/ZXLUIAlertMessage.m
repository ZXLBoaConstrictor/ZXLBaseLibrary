//
//  ZXLUIAlertMessage.m
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/6/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLUIAlertMessage.h"
#import <ZXLUtilsDefined.h>
#import <ZXLProgramSetting.h>
#import <ZXLRouter.h>

void ZXLUIAlertMessageBox(id <NSObject> message) {
    ZXLUIAlertMessageTitle(message, nil);
}

void ZXLUIAlertMessageTitle(id <NSObject> message, NSString *title) {
    ZXLUIAlertMessageBlock(message, title, nil, nil);
}

void ZXLUIAlertMessageBlock(id <NSObject> message, NSString *title, NSArray *buttons, void (^block)(int)) {
    ZXLUIAlertMessageBlockWithDelegate(message, title, buttons, NO, nil, block);
}

void ZXLUIAlertHTMLMessageBlock(id <NSObject> message, NSString *title, NSArray *buttons, void (^block)(int)) {
    ZXLUIAlertMessageBlockWithDelegate(message, title, buttons, YES, nil, block);
}

void ZXLUIAlertMessageBlockWithDelegate(id <NSObject> message, NSString *title, NSArray *buttons, BOOL bHTML, id delegate, void (^block)(int)) {
    NSCAssert(([message isKindOfClass:[NSString class]] || [message isKindOfClass:[NSAttributedString class]]), @"类型错误, message必须是NSString或者NSAttributedString");
    if (!([message isKindOfClass:[NSString class]] || [message isKindOfClass:[NSAttributedString class]])) {
        return;
    }
    if (title == nil || [title length] < 1) {
        title = [NSString stringWithFormat:@"%@", @"温馨提示"];
    }

    NSString *rightStr = @"确定";
    NSString *leftStr = @"";
    if (buttons) {
        if ([buttons count] == 2) {
            leftStr = buttons[0];
            rightStr = buttons[1];
        }

        if ([buttons count] == 1) {
            rightStr = buttons[0];
        }
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];

    if ([message isKindOfClass:[NSAttributedString class]]) {
        [alertController setValue:message forKey:@"attributedMessage"];
    } else {
        if (bHTML) {
            NSAttributedString *messageAtt = [[NSAttributedString alloc] initWithData:[(NSString *)message dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            [alertController setValue:messageAtt forKey:@"attributedMessage"];
        } else {
            alertController.message = (NSString *)message;
        }
    }

    if (ZXLUtilsISNSStringValid(leftStr)) {
        UIAlertAction *leftAlert = [UIAlertAction actionWithTitle:leftStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (block) {
                block(0);
            }
        }];

        [leftAlert setValue:[ZXLProgramSetting tipsBlackColor] forKey:@"_titleTextColor"];
        [alertController addAction:leftAlert];
    }

    UIAlertAction *rightAlert = [UIAlertAction actionWithTitle:rightStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (block) {
            block(1);
        }
    }];

    [rightAlert setValue:[ZXLProgramSetting mainColor] forKey:@"_titleTextColor"];
    [alertController addAction:rightAlert];
    [ZXLRouter presentViewController:alertController animated:YES completion:nil];
}
