//
//  ZXLUIDatePickerView.h
//  AFNetworking
//
//  Created by 张小龙 on 2019/2/21.
//

#import "ZXLUIPickerBaseView.h"
/// 弹出日期类型
typedef NS_ENUM(NSInteger, ZXLDatePickerMode) {
    // --- 以下4种是系统自带的样式 ---
    // UIDatePickerModeTime
    ZXLDatePickerModeTime,              // HH:mm
    // UIDatePickerModeDate
    ZXLDatePickerModeDate,              // yyyy-MM-dd
    // UIDatePickerModeDateAndTime
    ZXLDatePickerModeDateAndTime,       // yyyy-MM-dd HH:mm
    // UIDatePickerModeCountDownTimer
    ZXLDatePickerModeCountDownTimer,    // HH:mm
    // --- 以下7种是自定义样式 ---
    // 年月日时分
    ZXLDatePickerModeYMDHM,      // yyyy-MM-dd HH:mm
    // 月日时分
    ZXLDatePickerModeMDHM,       // MM-dd HH:mm
    // 年月日
    ZXLDatePickerModeYMD,        // yyyy-MM-dd
    // 年月
    ZXLDatePickerModeYM,         // yyyy-MM
    // 年
    ZXLDatePickerModeY,          // yyyy
    // 月日
    ZXLDatePickerModeMD,         // MM-dd
    // 时分
    ZXLDatePickerModeHM,          // HH:mm
//    // 年月~ 年月(计划完成 区间选择)
//    ZXLDatePickerModeYMYM,      // yyyy-MM~yyyy-MM
//    // 年~ 年
//    ZXLDatePickerModeYY,        // yyyy~yyyy
//    // 月日~ 月日
//    ZXLDatePickerModeMDMD,        // MM-dd~MM-dd
//    // 时分~ 时分
//    ZXLDatePickerModeHMHM,      // HH:mm~HH:mm
};


typedef void(^ZXLDateResultBlock)(NSString *selectValue);
typedef void(^ZXLDateCancelBlock)(void);

@interface ZXLUIDatePickerView : ZXLUIPickerBaseView

- (instancetype)initWithTitle:(NSString *)title
                     dateType:(ZXLDatePickerMode)dateType
              defaultSelValue:(NSString *)defaultSelValue
                      minDate:(NSDate *)minDate
                      maxDate:(NSDate *)maxDate
                 isAutoSelect:(BOOL)isAutoSelect
                   themeColor:(UIColor *)themeColor
                  resultBlock:(ZXLDateResultBlock)resultBlock
                  cancelBlock:(ZXLDateCancelBlock)cancelBlock;

- (void)showWithAnimation:(BOOL)animation;

@end
