//
//  ZXLMessageComposeViewController.m
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/7/4.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLMessageComposeViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface ZXLMessageComposeViewController ()<MFMessageComposeViewControllerDelegate>

@end

@implementation ZXLMessageComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageComposeDelegate = self;
    
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            [SVProgressHUD showSuccessWithStatus:@"短信发送成功!"];
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            [SVProgressHUD showSuccessWithStatus:@"短信发送失败!"];
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            [SVProgressHUD showSuccessWithStatus:@"短信取消发送!"];
            break;
        default:
            break;
    }
}
@end
