//
//  ZXLActionSheet.m
//  Compass
//
//  Created by 张小龙 on 2017/12/25.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import "ZXLActionSheet.h"
#import "ZXLUITableView.h"

#import <ZXLUtilsDefined.h>
#import <ZXLProgramSetting.h>
#import <ZXLSettingDefined.h>

#import <Masonry/Masonry.h>

@interface ZXLActionSheetCell()
@property(nonatomic,strong) UILabel                     * titleLabel;
@property(nonatomic,strong) UIView                     * lineView;
@end
@implementation ZXLActionSheetCell

//cell UI creat
-(void)setUpUI{
    if (_titleLabel == nil) {
        _titleLabel = ZXLNewObject(UILabel);
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    if (_lineView == nil) {
        _lineView = ZXLNewObject(UIView);
        _lineView.backgroundColor = [ZXLProgramSetting lineColor];
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0.5*ViewScaleValue));
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-0.5*ViewScaleValue);
        }];
    }
}

//cell set data
-(void)setCellData:(id)data line:(BOOL)bhidden{
    if (data && [data isKindOfClass:[NSString class]]) {
        _titleLabel.text = (NSString *)data;
        _lineView.hidden = bhidden;
    }
}

-(void)setTitleColor:(UIColor *)color{
    if (_titleLabel) {
        _titleLabel.textColor = color;
    }
}

@end


@interface ZXLActionSheet()<ZXLUITableViewDelegate>
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)ZXLUITableView *tableView;
@property(nonatomic,strong)UIButton *cancelBtn;
@end

@implementation ZXLActionSheet
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        if (_bgView == nil) {
            _bgView = ZXLNewObject(UIView);
            _bgView.frame = CGRectMake(0, frame.size.height, frame.size.width, 100*ViewScaleValue + ZXLSafeAreaBottomHeight);
            [self addSubview:_bgView];
        }
        
        if (_tableView == nil) {
            _tableView= [[ZXLUITableView alloc] initWithCellClass:[ZXLActionSheetCell class] showRefreshHeader:NO showRefreshFooter:NO haveEmpty:NO];
            _tableView.tableView.scrollEnabled = NO;
            _tableView.backgroundColor = [UIColor whiteColor];
            _tableView.delegate = self;
            [_bgView addSubview:_tableView];
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self->_bgView);
                make.width.equalTo(@(UIScreenFrameWidth));
                make.bottom.equalTo(self->_bgView).offset(-(58*ViewScaleValue + ZXLSafeAreaBottomHeight));
            }];
        }
        
   
        if (_cancelBtn == nil) {
            _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _cancelBtn.backgroundColor = [UIColor whiteColor];
            _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_cancelBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:_cancelBtn];
            [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self->_bgView);
                make.height.equalTo(@(50*ViewScaleValue + ZXLSafeAreaBottomHeight));
            }];
        }
        
        if (_lineView == nil) {
            _lineView = ZXLNewObject(UIView);
            _lineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
            [_bgView addSubview:_lineView];
            [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self->_bgView);
                make.height.equalTo(@(8*ViewScaleValue));
                make.bottom.equalTo(self->_cancelBtn.mas_top);
            }];
        }
        
    }
    return self;
}

-(CGFloat)tableViewCellHeight:(id)cellData
{
    return 50*ViewScaleValue;
}

-(void)tableviewdidSelectRow:(ZXLUITableView *)tableview data:(id)data{
    
    self.block(tableview.indexPath.row);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        CGRect rect = self->_bgView.frame;
        rect.origin.y = self.frame.size.height;
        self->_bgView.frame = rect;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)showButtons:(NSArray *)ayButton cancel:(NSString *)cancel completion:(void (^)(BOOL finished))completion{
    [_tableView.ayObject removeAllObjects];
    [_tableView.ayObject addObjectsFromArray:ayButton];
    [_tableView reloadData];
    [_tableView.tableView layoutIfNeeded];
    
    CGFloat fHight = ayButton.count*50*ViewScaleValue + 58*ViewScaleValue + ZXLSafeAreaBottomHeight;
    
    [_cancelBtn setTitle:cancel forState:UIControlStateNormal];
    if (ZXLSafeAreaBottomHeight > 0) {
        _cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 25*ViewScaleValue, 0);
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self->_bgView.frame = CGRectMake(0, self.frame.size.height - fHight, self.frame.size.width, fHight);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)onButton:(id)sender{
    if (sender == _cancelBtn) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            CGRect rect = self->_bgView.frame;
            rect.origin.y = self.frame.size.height;
            self->_bgView.frame = rect;
            self.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

-(void)setIndex:(NSInteger)index color:(UIColor *)color{
    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{

        [self->_tableView reloadData];
        [self->_tableView.tableView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        //刷新完成
        NSIndexPath *idexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UITableViewCell *cell = [self->_tableView.tableView cellForRowAtIndexPath:idexPath];
        if (cell && [cell isKindOfClass:[ZXLActionSheetCell class]]) {
            [(ZXLActionSheetCell *)cell setTitleColor:color];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:[UIApplication sharedApplication].keyWindow];
    
    CGFloat fHight = _tableView.ayObject.count*50*ViewScaleValue + 58*ViewScaleValue;

    if (point.y < self.frame.size.height - fHight)
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            CGRect rect = self->_bgView.frame;
            rect.origin.y = self.frame.size.height;
            self->_bgView.frame = rect;
            self.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

+(ZXLActionSheet *)showActionSheetView:(NSArray *)ayButton cancel:(NSString *)cancel finish:(didSelect)finish
{
    ZXLActionSheet * actionSheet = [[ZXLActionSheet alloc] initWithFrame:[[UIApplication sharedApplication] delegate].window.bounds];
    [[[UIApplication sharedApplication] delegate].window addSubview:actionSheet];
    actionSheet.block = finish;
    [actionSheet showButtons:ayButton cancel:cancel completion:nil];
    return actionSheet;
}
@end
