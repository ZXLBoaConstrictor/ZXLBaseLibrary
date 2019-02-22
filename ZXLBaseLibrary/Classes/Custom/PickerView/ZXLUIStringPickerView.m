//
//  ZXLUIStringPickerView.m
//  AFNetworking
//
//  Created by 张小龙 on 2019/2/21.
//

#import "ZXLUIStringPickerView.h"
#import "ZXLSettingDefined.h"

typedef NS_ENUM(NSInteger, ZXLStringPickerMode) {
    ZXLStringPickerComponentSingle,  // 单列
    ZXLStringPickerComponentMore     // 多列
};

@interface ZXLUIStringPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
// 字符串选择器
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) ZXLStringPickerMode type;
@property (nonatomic, strong) NSArray *dataSourceArr;
// 单列选择的值
@property (nonatomic, strong) NSString *selectValue;
// 多列选择的值
@property (nonatomic, strong) NSMutableArray *selectValueArr;

// 是否开启自动选择
@property (nonatomic, assign) BOOL isAutoSelect;
// 主题色
@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, copy) ZXLStringResultBlock resultBlock;
@property (nonatomic, copy) ZXLStringCancelBlock cancelBlock;

@end

@implementation ZXLUIStringPickerView

- (NSArray *)dataSourceArr {
    if (!_dataSourceArr) {
        _dataSourceArr = [NSArray array];
    }
    return _dataSourceArr;
}

- (NSMutableArray *)selectValueArr {
    if (!_selectValueArr) {
        _selectValueArr = [[NSMutableArray alloc]init];
    }
    return _selectValueArr;
}

#pragma mark - 初始化自定义字符串选择器
- (instancetype)initWithTitle:(NSString *)title
                   dataSource:(id)dataSource
              defaultSelValue:(id)defaultSelValue
                 isAutoSelect:(BOOL)isAutoSelect
                   themeColor:(UIColor *)themeColor
                  resultBlock:(ZXLStringResultBlock)resultBlock
                  cancelBlock:(ZXLStringCancelBlock)cancelBlock {
    if (self = [super init]) {
        self.title = title;
        self.isAutoSelect = isAutoSelect;
        self.themeColor = !themeColor ?[UIColor blackColor]:themeColor;;
        self.resultBlock = resultBlock;
        self.cancelBlock = cancelBlock;
        _isDataSourceValid = YES;
        [self configDataSource:dataSource defaultSelValue:defaultSelValue];
        if (_isDataSourceValid) {
            [self initUI];
        }
    }
    return self;
}

#pragma mark - 设置数据源
- (void)configDataSource:(id)dataSource defaultSelValue:(id)defaultSelValue {
    // 1.先判断传入的数据源是否合法
    if (!dataSource) {
        _isDataSourceValid = NO;
    }
    NSArray *dataArr = nil;
    if ([dataSource isKindOfClass:[NSArray class]] && [dataSource count] > 0) {
        dataArr = [NSArray arrayWithArray:dataSource];
    } else if ([dataSource isKindOfClass:[NSString class]] && [dataSource length] > 0) {
        NSString *plistName = dataSource;
        NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:nil];
        dataArr = [[NSArray alloc] initWithContentsOfFile:path];
        if (!dataArr || dataArr.count == 0) {
            _isDataSourceValid = NO;
        }
    } else {
        _isDataSourceValid = NO;
    }
    // 判断数组是否合法（即数组的所有元素是否是同一种数据类型）
    if (_isDataSourceValid) {
        Class itemClass = [[dataArr firstObject] class];
        for (id obj in dataArr) {
            if (![obj isKindOfClass:itemClass]) {
                _isDataSourceValid = NO;
                break;
            }
        }
    }
    if (!_isDataSourceValid) {
        return;
    }
    // 2. 给数据源赋值
    self.dataSourceArr = dataArr;
    
    // 3. 根据数据源 数组元素的类型，判断选择器的显示类型
    if ([[self.dataSourceArr firstObject] isKindOfClass:[NSString class]]) {
        self.type = ZXLStringPickerComponentSingle;
    } else if ([[self.dataSourceArr firstObject] isKindOfClass:[NSArray class]]) {
        self.type = ZXLStringPickerComponentMore;
    }
    // 4. 给选择器设置默认值
    if (self.type == ZXLStringPickerComponentSingle) {
        if (defaultSelValue && [defaultSelValue isKindOfClass:[NSString class]] && [defaultSelValue length] > 0 && [self.dataSourceArr containsObject:defaultSelValue]) {
            self.selectValue = defaultSelValue;
        } else {
            self.selectValue = [self.dataSourceArr firstObject];
        }
        NSInteger row = [self.dataSourceArr indexOfObject:self.selectValue];
        // 默认滚动的行
        [self.pickerView selectRow:row inComponent:0 animated:NO];
    } else if (self.type == ZXLStringPickerComponentMore) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSInteger i = 0; i < self.dataSourceArr.count; i++) {
            NSString *selValue = nil;
            if (defaultSelValue && [defaultSelValue isKindOfClass:[NSArray class]] && [defaultSelValue count] > 0 && i < [defaultSelValue count] && [self.dataSourceArr[i] containsObject:defaultSelValue[i]]) {
                [tempArr addObject:defaultSelValue[i]];
                selValue = defaultSelValue[i];
            } else {
                [tempArr addObject:[self.dataSourceArr[i] firstObject]];
                selValue = [self.dataSourceArr[i] firstObject];
            }
            NSInteger row = [self.dataSourceArr[i] indexOfObject:selValue];
            // 默认滚动的行
            [self.pickerView selectRow:row inComponent:i animated:NO];
        }
        self.selectValueArr = [tempArr copy];
    }
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    self.titleLabel.text = self.title;
    // 添加字符串选择器
    [self.alertView addSubview:self.pickerView];
    if (self.themeColor && [self.themeColor isKindOfClass:[UIColor class]]) {
        [self setupThemeColor:self.themeColor];
    }
}

#pragma mark - 字符串选择器
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, self.alertView.frame.size.width, kPickerHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        // 设置子视图的大小随着父视图变化
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.type) {
        case ZXLStringPickerComponentSingle:
            return 1;
            break;
        case ZXLStringPickerComponentMore:
            return self.dataSourceArr.count;
            break;
            
        default:
            break;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (self.type) {
        case ZXLStringPickerComponentSingle:
            return self.dataSourceArr.count;
            break;
        case ZXLStringPickerComponentMore:
            return [self.dataSourceArr[component] count];
            break;
            
        default:
            break;
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (self.type) {
        case ZXLStringPickerComponentSingle:
        {
            self.selectValue = self.dataSourceArr[row];
            // 设置是否自动回调
            if (self.isAutoSelect) {
                if(self.resultBlock) {
                    self.resultBlock(self.selectValue);
                }
            }
        }
            break;
        case ZXLStringPickerComponentMore:
        {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSInteger i = 0; i < self.selectValueArr.count; i++) {
                if (i == component) {
                    [tempArr addObject:self.dataSourceArr[component][row]];
                } else {
                    [tempArr addObject:self.selectValueArr[i]];
                }
            }
            self.selectValueArr = tempArr;
            
            // 设置是否自动回调
            if (self.isAutoSelect) {
                if(self.resultBlock) {
                    self.resultBlock([self.selectValueArr copy]);
                }
            }
        }
            break;
            
        default:
            break;
    }
}

// 自定义 pickerView 的 label
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    //设置分割线的颜色
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    //label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:18.0f];
    // 字体自适应属性
    label.adjustsFontSizeToFitWidth = YES;
    // 自适应最小字体缩放比例
    label.minimumScaleFactor = 0.5f;
    if (self.type == ZXLStringPickerComponentSingle) {
        label.frame = CGRectMake(0, 0, self.alertView.frame.size.width, 35.0f);
        label.text = self.dataSourceArr[row];
    } else if (self.type == ZXLStringPickerComponentMore) {
        label.frame = CGRectMake(0, 0, self.alertView.frame.size.width / [self.dataSourceArr[component] count], 35.0f);
        label.text = self.dataSourceArr[component][row];
    }
    
    return label;
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0f;
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    [self dismissWithAnimation:YES];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
    [self dismissWithAnimation:YES];
    // 点击确定按钮后，执行block回调
    if(_resultBlock) {
        if (self.type == ZXLStringPickerComponentSingle) {
            _resultBlock(self.selectValue);
        } else if (self.type == ZXLStringPickerComponentMore) {
            _resultBlock(self.selectValueArr);
        }
    }
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    //1. 获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = UIScreenFrameHeight;
        self.alertView.frame = rect;
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= kPickerHeight + kTopViewHeight + ZXLSafeAreaBottomHeight;
            self.alertView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += kPickerHeight + kTopViewHeight + ZXLSafeAreaBottomHeight;
        self.alertView.frame = rect;
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
