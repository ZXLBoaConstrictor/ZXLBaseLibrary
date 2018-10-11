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

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_tipsLabel) {
        _tipsLabel = ZXLNewObject(UILabel);
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.text = self.tipsText;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.view addSubview:_tipsLabel];
        [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@(10*ViewScaleValue));
            make.right.equalTo(self.view).offset(-10*ViewScaleValue);
            make.bottom.equalTo(self.view).offset(-10*ViewScaleValue);
        }];
    }
    
    // Do any additional setup after loading the view.
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
