//
//  ZXLUITableViewViewController.m
//  Compass
//
//  Created by 张小龙 on 2017/4/7.
//  Copyright © 2017年 张小龙. All rights reserved.
//

#import "ZXLUITableViewViewController.h"
#import "ZXLUITableView.h"
#import <NSDictionary+ZXLExtension.h>

#import <Masonry/Masonry.h>

@interface ZXLUITableViewViewController ()<ZXLUITableViewDelegate>

@end

@implementation ZXLUITableViewViewController

-(void)mainInit{
    [super mainInit];
    
    self.bShowRefreshFooter = YES;
    self.bShowRefreshHeader = YES;
    self.bhaveEmptyView = YES;
}

-(ZXLUITableView *)tableView{
    if (!_tableView) {
        _tableView = [[ZXLUITableView alloc] initWithCellClass:self.cellClass showRefreshHeader:self.bShowRefreshHeader showRefreshFooter:self.bShowRefreshFooter haveEmpty:self.bhaveEmptyView];
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(@(self.frame.origin.y));
            make.height.equalTo(@(self.frame.size.height));
        }];
        
        //空界面数据设置
        if (self.emptyContent) {
            _tableView.emptyContent = self.emptyContent;
        }
    }
    return _tableView;
}


-(CGFloat)tableViewCellHeight:(id)cellData{
    return 0;
}

-(void)refreshTableViewDataSource{
    self.tableView.nStartPos = 1;
    [self onRequest];
}

-(void)reloadTableViewDataSource{
    
    [self onRequest];
}

-(void)onRequest{
    
}

-(void)onRefresh{
    
    self.tableView.nStartPos = 1;
    self.tableView.bRequestLoading = YES;
    [self onRequest];
}

-(void)OnReceive:(NSMutableDictionary *)wParam complete:(BOOL)bResult{
    
    [super OnReceive:wParam complete:bResult];
    
    //刷新获取数据后 请求成功清空数据
    if ([wParam apiSuccess] && bResult&& self.tableView.bRequestLoading && self.tableView.nStartPos == 1) {
        [self.tableView.ayObject removeAllObjects];
    }
    
    [self.tableView reloadfinishing];
}


@end
