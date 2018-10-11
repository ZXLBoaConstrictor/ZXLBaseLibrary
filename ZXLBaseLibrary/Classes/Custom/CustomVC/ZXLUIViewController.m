//
//  ZXLUIViewController.m
//  ZXZ
//
//  Created by 张小龙 on 2017/2/28.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import "ZXLUIViewController.h"
#import <ZXLUtilsDefined.h>
#import <ZXLSettingDefined.h>
#import <UIImage+ZXLExtension.h>
#import <ZXLGlobalVariables.h>

#import <Masonry/Masonry.h>

@interface ZXLUIViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *titleView;
@end

@implementation ZXLUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self mainInit];
    }
    
    return self;
}

-(void)dealloc{
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    
    _titleView = nil;
    _titleLabel = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([UIApplication sharedApplication].statusBarStyle == UIStatusBarStyleLightContent) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//设置title颜色
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];//设置title颜色
    }
}

//初始化数据
- (void)mainInit{
    self.bTitleTransparent = NO;
    self.bBackAction = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    if (self.bTitleTransparent){
        self.frame = self.view.bounds;
    }
    else{
        self.frame = CGRectMake(0, system_titleViewHeight , self.view.bounds.size.width, self.view.bounds.size.height - system_titleViewHeight);
    }
    
    if (_titleView == nil){
        _titleView = ZXLNewObject(UIImageView);
        _titleView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.view);
            make.width.equalTo(self.view);
            make.height.equalTo(@(system_titleViewHeight));
        }];
    }
    
    if (_titleLabel == nil){
        _titleLabel = ZXLNewObject(UILabel);
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self->_titleView).insets(UIEdgeInsetsMake(system_titleStatusBarHeight, 0, 0, 0));
        }];
    }
    
    if (_bBackAction) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage ZXLImageNamed:@"Titlebackbg.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 70*ViewScaleValue, 30*ViewScaleValue);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
        [button addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    [self setTitlebackgroundColor:self.bTitleTransparent?[UIColor clearColor]:[UIColor whiteColor]];
    
    [self onRequest];
  
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if (_titleView) {
        [self.view bringSubviewToFront:_titleView];
    }
}

- (void)onRequest{
    
}

- (void)onBack{
    
}

- (void)OnReceive:(NSMutableDictionary *)wParam complete:(BOOL)bResult{

}

- (void)setTitleAlpha:(CGFloat)falpha{
    _titleLabel.alpha = falpha;
}


- (void)setTitlebackgroundColor:(UIColor *)color{
    _titleView.backgroundColor = color;
}

- (void)setTitleFrame:(CGRect)titleframe{
    _titleView.frame = titleframe;
}

- (void)setValueTitle:(NSString *)strTitle{
    _titleLabel.text = strTitle;
}

- (void)setTitleColor:(UIColor *)color{
    _titleLabel.textColor = color;
}

- (void)setTitleImage:(UIImage *)image{
    _titleView.image = image;
}

- (void)setTitleBringToFront{
    [self.view bringSubviewToFront:_titleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
