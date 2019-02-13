//
//  ZXLUIPopMenuViewController.h
//  Compass
//
//  Created by 张小龙 on 2017/7/19.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXLUIPopMenuModel;
typedef void (^ZXLUIPopMenuCompleteSelect)(NSInteger index);

@interface ZXLUIPopMenuViewController : UIViewController<UIPopoverPresentationControllerDelegate>
@property(nonatomic,strong)NSArray<ZXLUIPopMenuModel *> *menu;
@property (nonatomic,copy)ZXLUIPopMenuCompleteSelect select;
@property (nonatomic,assign)CGFloat cellHeight;
@end
