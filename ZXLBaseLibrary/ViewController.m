//
//  ViewController.m
//  ZXLBaseLibrary
//
//  Created by 张小龙 on 2018/10/9.
//  Copyright © 2018 张小龙. All rights reserved.
//

#import "ViewController.h"
#import <ZXLBaseLibrary/ZXLUIPopViewManager.h>
#import <ZXLBaseLibrary/ZXLUIPopMenuModel.h>
#import <ZXLBaseLibrary/ZXLUIPickerViewManager.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"menu" style:UIBarButtonItemStyleDone target:self action:@selector(onTitleRight:)];
}

-(void)onTitleRight:(id)sender{
    
    [ZXLUIPickerViewManager showStringPickerWithTitle:@"选择星期" dataSource:@[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"] defaultSelValue:nil resultBlock:^(id selectValue) {
        
    }];
}
@end
