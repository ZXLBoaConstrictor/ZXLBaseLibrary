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

//https://github.com/onegray/UIViewController-BackButtonHandler

@implementation UINavigationController (ZXLExtension)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        for(UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return NO;
}

@end
