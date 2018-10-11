//
//  ZXLSettingDefined.h
//  ZXLSettingModule
//
//  Created by 张小龙 on 2018/6/27.
//

#ifndef ZXLSettingDefined_h
#define ZXLSettingDefined_h


/**
 界面适配比列
 */
#define ViewScaleValue    ([UIScreen mainScreen].bounds.size.width/375.0f)

/**
 屏幕宽
 */
#define UIScreenFrameWidth  ([UIScreen mainScreen].bounds.size.width)
/**
 屏幕高
 */
#define UIScreenFrameHeight  ([UIScreen mainScreen].bounds.size.height)

//phone x 底部高度
#define ZXLSafeAreaBottomHeight (UIScreenFrameHeight == 812.0 ? 34 : 0)

/**
界面标准
 */
#define EtalonSpacing (12*ViewScaleValue)

#endif
