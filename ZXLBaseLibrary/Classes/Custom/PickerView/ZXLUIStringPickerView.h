//
//  ZXLUIStringPickerView.h
//  AFNetworking
//
//  Created by 张小龙 on 2019/2/21.
//

#import "ZXLUIPickerBaseView.h"
typedef void(^ZXLStringResultBlock)(id selectValue);
typedef void(^ZXLStringCancelBlock)(void);

@interface ZXLUIStringPickerView : ZXLUIPickerBaseView
@property (nonatomic, assign) BOOL isDataSourceValid;// 数据源是否合法

- (instancetype)initWithTitle:(NSString *)title
                   dataSource:(id)dataSource
              defaultSelValue:(id)defaultSelValue
                 isAutoSelect:(BOOL)isAutoSelect
                   themeColor:(UIColor *)themeColor
                  resultBlock:(ZXLStringResultBlock)resultBlock
                  cancelBlock:(ZXLStringCancelBlock)cancelBlock;

- (void)showWithAnimation:(BOOL)animation;
@end
