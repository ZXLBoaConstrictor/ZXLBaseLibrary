//
//  ZXLUITableView.m
//  Compass
//
//  Created by 张小龙 on 2017/4/7.
//  Copyright © 2017年 张小龙. All rights reserved.
//

#import "ZXLUITableView.h"
#import "ZXLUITableViewCell.h"
#import "ZXLEmptyView.h"
#import <ZXLUtilsDefined.h>
#import <UIImage+ZXLExtension.h>
#import <ZXLSettingDefined.h>

#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
@interface ZXLUITableView()<ZXLUITableViewCellDelegate>

@end

@implementation ZXLUITableView

-(instancetype)initWithCellClass:(Class)cellClass
               showRefreshHeader:(BOOL)bShowHeader
               showRefreshFooter:(BOOL)bShowFooter
                       haveEmpty:(BOOL)bHaveEmpety{
    if (self = [super init]) {
        self.bShowRefreshFooter = bShowFooter;
        self.bShowRefreshHeader = bShowHeader;
        self.bhaveEmptyView = bHaveEmpety;
        self.bFirstRequestData = YES;
        self.bHaveSelectionStyle = NO;
        self.bRequestLoading = NO;
        self.nStartPos = 1;
        
        if (!_ayObject) {
           _ayObject = [NSMutableArray array];
        }

        //空界面默认设置
        if (bHaveEmpety) {
            if (!ZXLUtilsISNSStringValid(_emptyContent)) {
                _emptyContent = @"这里什么都没有呢";
            }
        }
        
        if (_tableView == nil) {
            _tableView = ZXLNewObject(UITableView);
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            if (@available(iOS 11.0, *)) {
                _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }
            _tableView.backgroundColor = [UIColor clearColor];
            _tableView.dataSource = self;
            _tableView.scrollsToTop = YES;
            _tableView.delegate = self;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [_tableView registerClass:cellClass forCellReuseIdentifier:@"ZXLUITableViewCell"];
            [self addSubview:_tableView];
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
        [self refreshHear];
        [self refreshFooter];
        
        if (_bhaveEmptyView && !_emptyView) {
            _emptyView = ZXLNewObject(ZXLEmptyView);
            [_tableView addSubview:_emptyView];
            [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self->_tableView);
                make.width.equalTo(@(UIScreenFrameWidth));
            }];
            [(ZXLEmptyView *)_emptyView setContent:self.emptyContent];
            _emptyView.hidden = YES;
        }
    }
    return self;
}

-(void)dealloc{

}

-(void)setEmptyView:(UIView *)emptyView{
    if (_emptyView) {
        [_emptyView removeFromSuperview];
        _emptyView = nil;
    }
    
    _emptyView = emptyView;
    [_tableView addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self->_tableView);
        make.width.equalTo(@(UIScreenFrameWidth));
    }];
    [_tableView bringSubviewToFront:_emptyView];
    _emptyView.hidden = YES;
}


-(void)setEmptyContent:(NSString *)emptyContent{
    _emptyContent = emptyContent;
    if ([_emptyView isKindOfClass:[ZXLEmptyView class]]) {
        [(ZXLEmptyView *)_emptyView setContent:emptyContent];
    }
}

-(void)setBShowRefreshFooter:(BOOL)bShowRefreshFooter{
    _bShowRefreshFooter = bShowRefreshFooter;
}

-(void)setBShowRefreshHeader:(BOOL)bShowRefreshHeader{
    _bShowRefreshHeader = bShowRefreshHeader;
}

-(void)beginRefreshing{
    if (self.bFirstRequestData && _bShowRefreshHeader && _tableView.mj_header) {
        [_tableView.mj_header beginRefreshing];
    }
}

/*
 上拉刷新
 */
-(void)refreshHear{
    if (self.tableView == nil)
        return;
    
    if (self.bShowRefreshHeader) {
        if (self.tableView.mj_header == nil) {
            WEAKSELF;
            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                weakSelf.bRequestLoading = YES;
                [weakSelf refreshTableViewDataSource];
            }];
        }
    }else{
        self.tableView.mj_header = nil;
    }
}

/*
 下拉加载
 */
-(void)refreshFooter{
    if (self.tableView == nil)
        return;
    
    if (self.bShowRefreshFooter){
        if (self.tableView.mj_footer == nil) {
            WEAKSELF;
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                weakSelf.bRequestLoading = YES;
                [weakSelf reloadTableViewDataSource];
            }];
        }
    }
    else{
        self.tableView.mj_footer = nil;
    }
}

//防止拖动tableView时产生的BUG
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    UIMenuController * menu = [UIMenuController sharedMenuController];
    if (menu.menuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
}

/*
 刷新数据
 */
-(void)refreshTableViewDataSource{
    self.nStartPos = 1;
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshTableViewDataSource)]) {
        [self.delegate refreshTableViewDataSource];
    }
}

/*
 加载数据
 */
-(void)reloadTableViewDataSource{
    if (self.nStartPos == 1 && self.ayObject.count == 0) {
        self.nStartPos = 1;
    }else{
      self.nStartPos += 1;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadTableViewDataSource)]) {
        [self.delegate reloadTableViewDataSource];
    }
}

/*
 停止数据操作
 */
-(void)reloadfinishing{
    if (_tableView.mj_header && _tableView.mj_header.isRefreshing) {
        self.bRequestLoading = NO;
        [_tableView.mj_header endRefreshing];
    }
    if (_tableView.mj_footer && _tableView.mj_footer.isRefreshing) {
        self.bRequestLoading = NO;
        [_tableView.mj_footer endRefreshing];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return  [self.delegate tableView:tableView heightForHeaderInSection:section];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return  [self.delegate tableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _ayObject.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat  fRowHeight = 0;
    if (indexPath.row < _ayObject.count) {
        fRowHeight = [self tableViewCellHeight:[_ayObject objectAtIndex:indexPath.row]];
        if (fRowHeight == 0 && self.delegate && [self.delegate respondsToSelector:@selector(tableViewCellHeight:)]) {
            fRowHeight = [self.delegate tableViewCellHeight:[_ayObject objectAtIndex:indexPath.row]];
        }
    }
    return fRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"ZXLUITableViewCell";
    ZXLUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle =  self.bHaveSelectionStyle ? UITableViewCellSelectionStyleGray:UITableViewCellSelectionStyleNone;
    cell.delegate = self;

    if ([cell respondsToSelector:@selector(setCellData:line:)] && indexPath.row < _ayObject.count) {
        [cell setCellData:[_ayObject objectAtIndex:indexPath.row] line:(indexPath.row == _ayObject.count - 1)];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollDelegate scrollViewDidScroll:scrollView];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.bHaveSelectionStyle) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    self.indexPath = indexPath;
    if (indexPath.row < _ayObject.count) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableviewdidSelectRow:data:)]) {
            [self.delegate tableviewdidSelectRow:self data:[_ayObject objectAtIndex:indexPath.row]];
        }
    }
}

-(void)onButtonCellView:(ZXLUITableViewCell *)cellView Type:(NSInteger)nType{
    NSIndexPath * indexPath = [_tableView indexPathForCell:cellView];
    if (!indexPath)
        return;
    
    self.indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    if (indexPath.row < [_ayObject count]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableviewButtonRow:type:data:)]){
            [self.delegate tableviewButtonRow:self type:nType data:[_ayObject objectAtIndex:indexPath.row]];
        }
    }
    
}

-(void)setTableViewHeaderView:(UIView *)view{
    _tableView.tableHeaderView = view;
    if (_bhaveEmptyView && _emptyView) {
        [_emptyView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (view) {
                make.top.equalTo(@(view.frame.size.height));
            }else{
                make.top.equalTo(@(0));
            }
        }];
    }
}

-(void)tableViewInsertIndex:(NSIndexPath *)indexPath{
    if (indexPath == nil)
        return;
    
    if (indexPath.row < [_ayObject count]){
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    }
}

-(void)tableViewUpdateIndex:(NSIndexPath *)indexPath{
    if (indexPath == nil)
        return;
    
    if (indexPath.row < [_ayObject count]){
        [_tableView beginUpdates];
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
    }
}

-(void)tableViewUpdateIndexFromRequest:(NSIndexPath *)indexPath{
    
}

-(void)setNewValueForTableviewViewModel:(NSDictionary*)dict{
    
}

-(void)tableViewRemoveIndex:(NSIndexPath *)indexPath{
    if (indexPath == nil)
        return;
    
    BOOL bChange = NO;
    if (indexPath.row < [_ayObject count]){
        [_ayObject removeObjectAtIndex:indexPath.row];
        bChange = YES;
    }
    
    if (bChange){
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [_tableView endUpdates];
    }
}


-(void)reloadData{
    [self reloadfinishing];
    _bFirstRequestData = NO;
    if (self.tableView) {
        [self.tableView reloadData];
    }
    
    if (self.bhaveEmptyView && _emptyView) {
        _emptyView.hidden = ([_ayObject count] > 0);
    }
    
    if (self.tableView.tableHeaderView && !_emptyView.hidden) {
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height + self.tableView.tableHeaderView.frame.size.height);
    }
}

-(void)dataEmpty{
    if (_nStartPos > 1) {
        _nStartPos --;
    }
}

-(CGFloat)tableViewCellHeight:(id)cellData{
    return 0;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.indexPath = indexPath;
    if (indexPath.row >= [_ayObject count])
        return;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) { // 点击了删除
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowData:)]) {
            [self.delegate tableView:self commitEditingStyle:editingStyle forRowData:[_ayObject objectAtIndex:indexPath.row]];
        }
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= [_ayObject count])
        return nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:editActionsForRowData:)]) {
        self.indexPath = indexPath;
        return  [self.delegate tableView:self editActionsForRowData:[_ayObject objectAtIndex:indexPath.row]];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= [_ayObject count])
        return;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewWillBeginEditing:)]) {
        self.indexPath = indexPath;
        return  [self.delegate tableViewWillBeginEditing:self];
    }
}
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath{
    if (indexPath.row >= [_ayObject count])
        return;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewDidEndEditing:)]) {
        return  [self.delegate tableViewDidEndEditing:self];
    }
}

/**
 * 这个方法决定了编辑模式时，每一行的编辑类型
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= [_ayObject count])
        return UITableViewCellEditingStyleNone;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:editingStyleForRowData:)]) {
        return  [self.delegate tableView:self editingStyleForRowData:[_ayObject objectAtIndex:indexPath.row]];
    }
    return UITableViewCellEditingStyleNone;
}

@end
