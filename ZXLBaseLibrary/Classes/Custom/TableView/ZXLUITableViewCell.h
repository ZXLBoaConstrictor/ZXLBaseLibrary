//
//  ZXLUITableViewCell.h
//  Compass
//
//  Created by 张小龙 on 2017/4/7.
//  Copyright © 2017年 张小龙. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXLUITableViewCell;

#define ZXLUITableViewCellBtnTag   0x10000

//协议
@protocol ZXLUITableViewCellDelegate <NSObject>
@optional
-(void)onButtonCellView:(ZXLUITableViewCell *)cellView Type:(NSInteger)nType;
@end


@interface ZXLUITableViewCell : UITableViewCell
@property (nonatomic,weak)id<ZXLUITableViewCellDelegate>     delegate; //代理
//cell UI creat
-(void)setUpUI;

//cell set data
-(void)setCellData:(id)data line:(BOOL)bhidden;

-(void)onButton:(id)sender;

@end
