//
//  ZXLUIPopTipsViewController.m
//  Compass
//
//  Created by 张小龙 on 2018/2/9.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import "ZXLUIPopTipsViewController.h"
#import <ZXLUtilsDefined.h>
#import <ZXLSettingDefined.h>
#import <Masonry/Masonry.h>
@interface ZXLUIPopTipsViewController ()<UIPopoverPresentationControllerDelegate>
@property(nonatomic,strong)UILabel * tipsLabel;
@end

@implementation ZXLUIPopTipsViewController

-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = ZXLNewObject(UILabel);
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.view addSubview:_tipsLabel];
        [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@(EtalonSpacing));
            make.right.equalTo(self.view).offset(-EtalonSpacing);
            make.bottom.equalTo(self.view).offset(-EtalonSpacing);
        }];
    }
    return _tipsLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    self. tipsLabel.text = self.tipsText;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.superview.clipsToBounds = NO;
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
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    
    return UIModalPresentationNone;
}

@end
