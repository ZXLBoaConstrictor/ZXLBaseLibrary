//
//  UIViewController+ZXLExtension.m
//  FBSnapshotTestCase
//
//  Created by 张小龙 on 2018/7/2.
//

#import "UIViewController+ZXLExtension.h"

@implementation UIViewController (ZXLExtension)
- (void)creatTitleBtn:(UIBarButtonSystemItem)systemItem
                image:(UIImage *)image
               string:(NSString *)string{
    if (string && string.length > 0){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:string style:UIBarButtonItemStyleDone target:self action:NSSelectorFromString(@"onTitleBtnRight")];
        return;
    }
    
    if (image){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:NSSelectorFromString(@"onTitleBtnRight")];
        return;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:NSSelectorFromString(@"onTitleBtnRight")];
    
}

@end
