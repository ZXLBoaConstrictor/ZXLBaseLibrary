//
//  ZXLUIPopMenuViewController.h
//  Compass
//
//  Created by 张小龙 on 2017/7/19.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXLPopMenuSettingModel;
typedef void (^didSelect)(NSInteger index);

@interface ZXLUIPopMenuViewController : UIViewController<UIPopoverPresentationControllerDelegate>
@property(nonatomic,strong)NSArray<ZXLPopMenuSettingModel *> *ayMenu;
@property (nonatomic,copy)didSelect select;
@end
