//
//  UIViewController+ZXLExtension.h
//  FBSnapshotTestCase
//
//  Created by 张小龙 on 2018/7/2.
//

#import <UIKit/UIKit.h>
@protocol ZXLBackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (ZXLExtension)<ZXLBackButtonHandlerProtocol>
- (void)creatTitleBtn:(UIBarButtonSystemItem)systemItem
                image:(UIImage *)image
               string:(NSString *)string;
@end
