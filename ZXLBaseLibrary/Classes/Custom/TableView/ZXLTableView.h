//
//  ZXLTableView.h
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/9/10.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLUITableView.h"

@interface ZXLTableView : ZXLUITableView

//数据请求
-(void)onRequest;

//刷新
-(void)onRefresh;

- (void)OnReceive:(NSMutableDictionary *)wParam complete:(BOOL)bResult;
@end
