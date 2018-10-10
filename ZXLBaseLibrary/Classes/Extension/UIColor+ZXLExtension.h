//
//  UIColor+ZXLExtension.h
//  ZXLExtensionModule
//
//  Created by 张小龙 on 2018/6/27.
//

#import <UIKit/UIKit.h>
@interface UIColor (ZXLExtension)

/**
 *  @brief  获取UIColor色彩，根据Hex;
 *
 *  @param hexString 字符串（Hex）;
 *
 *  @return UIColor
 */
+ (UIColor *) colorWithHexString: (NSString *) hexString;

+ (UIColor *) colorWithHexString: (NSString *) hexString alpha:(CGFloat)alpha;
@end
