//
//  ZXLTableView.m
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/9/10.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLTableView.h"
#import <NSDictionary+ZXLExtension.h>
@implementation ZXLTableView


-(void)refreshTableViewDataSource{
    self.nStartPos = 1;
    [self onRequest];
}

-(void)reloadTableViewDataSource{
    
    self.nStartPos ++;
    [self onRequest];
}

-(void)onRequest{
    
}

-(void)onRefresh{
    self.nStartPos = 1;
    self.bRequestLoading = YES;
    [self onRequest];
}

- (void)OnReceive:(NSMutableDictionary *)wParam complete:(BOOL)bResult{
    //刷新获取数据后 请求成功清空数据
    if ([wParam apiSuccess] && bResult && self.nStartPos == 1) {
        [self.ayObject removeAllObjects];
    }
    
    [self reloadfinishing];
}

@end
