//
//  ZXLUIViewController.h
//  ZXZ
//
//  Created by 张小龙 on 2017/2/28.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXLUIViewController : UIViewController

@property (nonatomic, assign) CGRect         frame;
@property (nonatomic, assign) BOOL           bTitleTransparent;//顶部透明
@property (nonatomic, assign) BOOL           bBackAction;

- (void)mainInit;//VC 初始化数据

- (void)setValueTitle:(NSString *)strTitle;
- (void)setTitleColor:(UIColor *)color;
- (void)setTitleAlpha:(CGFloat)falpha;
- (void)setTitlebackgroundColor:(UIColor *)color;
- (void)setTitleFrame:(CGRect)titleframe;
- (void)setTitleBringToFront;
- (void)setTitleImage:(UIImage *)image;

- (void)onRequest;
- (void)onBack;
- (void)OnReceive:(NSMutableDictionary *)wParam complete:(BOOL)bResult;//请求返回

@end
