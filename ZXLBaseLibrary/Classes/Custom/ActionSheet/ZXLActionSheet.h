//
//  ZXLActionSheet.h
//  Compass
//
//  Created by 张小龙 on 2017/12/25.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXLUITableViewCell.h"

typedef void (^didSelect)(NSInteger nIndex);

@interface ZXLActionSheetCell : ZXLUITableViewCell
-(void)setTitleColor:(UIColor *)color;
@end

@interface ZXLActionSheet : UIView
@property (nonatomic,copy)didSelect block;
-(void)setIndex:(NSInteger)index color:(UIColor *)color;

+(ZXLActionSheet *)showActionSheetView:(NSArray *)ayButton cancel:(NSString *)cancel finish:(didSelect)finish;
@end
