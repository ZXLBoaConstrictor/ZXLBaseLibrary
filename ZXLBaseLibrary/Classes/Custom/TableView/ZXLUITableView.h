//
//  ZXLUITableView.h
//  Compass
//
//  Created by 张小龙 on 2017/4/7.
//  Copyright © 2017年 张小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXLUITableView;
@class ZXLUITableViewCell;

//代理
@protocol  ZXLUITableViewDelegate <NSObject>
@optional
-(void)onRefresh;
-(void)refreshTableViewDataSource;//刷新数据
-(void)reloadTableViewDataSource;//加载数据
-(void)tableviewdidSelectRow:(ZXLUITableView *)tableview data:(id)data;
-(void)tableviewButtonRow:(ZXLUITableView *)tableview type:(NSInteger)type data:(id)data;

//VC界面扩展功能实现
- (NSArray *)tableView:(ZXLUITableView *)tableView editActionsForRowData:(id)data;
- (void)tableViewWillBeginEditing:(ZXLUITableView *)tableView;
- (void)tableViewDidEndEditing:(ZXLUITableView *)tableView;

- (void)tableView:(ZXLUITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowData:(id)data;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (CGFloat)tableViewCellHeight:(id)cellData;
- (UITableViewCellEditingStyle)tableView:(ZXLUITableView *)tableView editingStyleForRowData:(id)data;
@end


@interface ZXLUITableView : UIView <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)        id<ZXLUITableViewDelegate>        delegate;
@property (nonatomic,weak)        id                                scrollDelegate;

@property (nonatomic,readonly)      NSMutableArray *                ayObject;//数据数组
@property (nonatomic,assign)        NSInteger                       nStartPos;//请求页面计数
@property (nonatomic,copy)          NSIndexPath *                   indexPath;//当前选中行

/**刷新显示控制*/
@property (nonatomic,assign)        BOOL                            bShowRefreshHeader;
@property (nonatomic,assign)        BOOL                            bShowRefreshFooter;

/**空数据界面*/
@property (nonatomic,assign)        BOOL                            bhaveEmptyView;//有没有空界面展示
@property (nonatomic,copy)          NSString *                      emptyContent;//空界面描述
@property (nonatomic,strong)        UIView *                        emptyView;

@property (nonatomic,assign)        BOOL                            bFirstRequestData;//是否第一次请求数据(为了多tableView 有刷新清空下 ，不用一次去全部请求数据)
@property (nonatomic,assign)        BOOL                            bHaveSelectionStyle;//Cell 点击效果
@property (nonatomic,readonly)      UITableView *                   tableView;

@property (nonatomic,assign)        BOOL                            bRequestLoading;

/**
 构建函数

 @param cellClass cell类
 @param bShowHeader 是否显示顶部刷新
 @param bShowFooter 是否显示底部加载
 @param bHaveEmpety 是否有空数据界面
 @return ZXLUITableView
 */
-(instancetype)initWithCellClass:(Class)cellClass
       showRefreshHeader:(BOOL)bShowHeader
       showRefreshFooter:(BOOL)bShowFooter
               haveEmpty:(BOOL)bHaveEmpety;


/**
 开始刷新
 */
-(void)beginRefreshing;

/**
 结束刷新
 */
-(void)reloadfinishing;

//返回空数据调用
-(void)dataEmpty;

-(void)reloadData;

-(void)refreshTableViewDataSource;

-(void)reloadTableViewDataSource;

-(void)onButtonCellView:(ZXLUITableViewCell *)cellView Type:(NSInteger)nType;

-(void)setTableViewHeaderView:(UIView *)view;

//添加
-(void)tableViewInsertIndex:(NSIndexPath *)indexPath;
//更新
-(void)tableViewUpdateIndex:(NSIndexPath *)indexPath;
//删除
-(void)tableViewRemoveIndex:(NSIndexPath *)indexPath;

//更新- 根据服务器数据返回更改index数据 （主要是子类实现）
-(void)tableViewUpdateIndexFromRequest:(NSIndexPath *)indexPath;

/**
 *更新-根据H5后台返回的数值刷新对应的View
 *
 *1.H5返回studentId对成长手记页面依据studentId进行刷新
 *
 */
-(void)setNewValueForTableviewViewModel:(NSDictionary*)dict;

/*子类继承 必须实现*/
/** cell 行高度设置 根据cell 数据计算行高度*/
-(CGFloat)tableViewCellHeight:(id)cellData;

@end
