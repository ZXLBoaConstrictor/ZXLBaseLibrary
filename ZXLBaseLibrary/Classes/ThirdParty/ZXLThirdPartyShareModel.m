//
//  ZXLThirdPartyShareModel.m
//  Compass
//
//  Created by 张小龙 on 2017/8/10.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import "ZXLThirdPartyShareModel.h"
#import <ZXLUtilsDefined.h>
@implementation ZXLThirdPartyShareModel
-(UIImage *)thumbImage{
    if (ZXLUtilsISNSStringValid(self.thumbImageURL) && [self.thumbImageURL hasPrefix:@"http"]) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbImageURL]];
        data = UIImageJPEGRepresentation([UIImage imageWithData:data], 0.1);
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            return image;
        }
    }
    return nil;
}
@end
