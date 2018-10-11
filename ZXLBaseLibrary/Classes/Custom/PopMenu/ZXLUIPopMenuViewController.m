//
//  ZXLUIPopMenuViewController.m
//  Compass
//
//  Created by 张小龙 on 2017/7/19.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import "ZXLUIPopMenuViewController.h"
#import "ZXLPopMenuCell.h"
#import "ZXLUITableView.h"
#import <Masonry/Masonry.h>
#import "ZXLSettingDefined.h"
#import "ZXLUtilsDefined.h"
#import "ZXLPopMenuSettingModel.h"

@interface ZXLUIPopMenuViewController ()<ZXLUITableViewDelegate>
@property(nonatomic,strong)ZXLUITableView * tableView;
@end

@implementation ZXLUIPopMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_tableView == nil) {
        _tableView= [[ZXLUITableView alloc] initWithCellClass:[ZXLPopMenuCell class] showRefreshHeader:NO showRefreshFooter:NO haveEmpty:NO];
        _tableView.tableView.scrollEnabled = NO;
        _tableView.bHaveSelectionStyle = YES;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [_tableView.ayObject addObjectsFromArray:self.ayMenu];
        [_tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableViewCellHeight:(id)cellData{
    return 43*ViewScaleValue;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

-(void)tableviewdidSelectRow:(ZXLUITableView *)tableview data:(id)data{
    WEAKSELF
     [self dismissViewControllerAnimated:NO completion:^{
         if (weakSelf.select) {
             weakSelf.select(tableview.indexPath.row);
         }
     }];
}


@end
