//
//  ZXLUITableViewViewController.h
//  Compass
//
//  Created by 张小龙 on 2017/4/7.
//  Copyright © 2017年 张小龙. All rights reserved.
//

#import "ZXLUIViewController.h"
@class ZXLUITableView;

@interface ZXLUITableViewViewController : ZXLUIViewController
@property (nonatomic,assign)        Class                           cellClass;
@property (nonatomic,assign)        BOOL                            bShowRefreshHeader;
@property (nonatomic,assign)        BOOL                            bShowRefreshFooter;
@property (nonatomic,assign)        BOOL                            bhaveEmptyView;//有没有空界面展示
@property (nonatomic,copy)          NSString *                      emptyContent;//空界面描述
@property (nonatomic,strong)        ZXLUITableView *               tableView;

//刷新
-(void)onRefresh;

-(CGFloat)tableViewCellHeight:(id)cellData;

@end
