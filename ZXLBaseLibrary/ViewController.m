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
#import <ZXLBaseLibrary/ZXLUIAlertMessage.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"menu" style:UIBarButtonItemStyleDone target:self action:@selector(onTitleRight:)];
}

-(void)onTitleRight:(id)sender{
    ZXLMessageBox(@"123123");
//    NSMutableArray *ayMenu = [NSMutableArray array];
//    ZXLUIPopMenuModel *oneModel = [[ZXLUIPopMenuModel alloc] init];
//    oneModel.title = @"第一个";
//    oneModel.textAlignment = NSTextAlignmentCenter;
//    oneModel.font = [UIFont systemFontOfSize:12.0f];
//    oneModel.textColor = [UIColor redColor];
//    [ayMenu addObject:oneModel];
//
//    ZXLUIPopMenuModel *tModel = [[ZXLUIPopMenuModel alloc] init];
//    tModel.title = @"第二个";
//    [ayMenu addObject:tModel];
//
//    ZXLUIPopMenuModel *sModel = [[ZXLUIPopMenuModel alloc] init];
//    sModel.title = @"第三个";
//    [ayMenu addObject:sModel];
//
//    ZXLUIPopMenuModel *fModel = [[ZXLUIPopMenuModel alloc] init];
//    fModel.title = @"第四个";
//    [ayMenu addObject:fModel];
//
//    [ZXLUIPopViewManager showMenu:ayMenu width:80 cellHeight:43 cornerRadius:6 barButtonItem:sender complete:^(NSInteger index) {
//
//    }];
}
@end
