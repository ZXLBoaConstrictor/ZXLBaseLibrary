//
//  ZXLThirdPartyShareModel.h
//  Compass
//
//  Created by 张小龙 on 2017/8/10.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZXLThirdPartyShareModel : NSObject
@property (nonatomic, copy)   NSString *title; //分享title
@property (nonatomic, copy)   NSString *content; //内容
@property (nonatomic, copy)   NSString *urlString;//URL
@property (nonatomic, copy)   NSString *thumbImageURL; //缩略图

-(UIImage *)thumbImage;
@end
