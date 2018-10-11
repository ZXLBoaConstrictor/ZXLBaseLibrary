//
//  ZXLUILoopScrollView.h
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/6/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ZXLLoopScrollViewStyle){
    ZXLLoopScrollViewDefault,//默认的 ->加数组View的
    ZXLLoopScrollViewPNG,//加入图片的数组
    ZXLLoopScrollViewPNGServer,//加图片地址的数组
};

@class ZXLUILoopScrollView;

@protocol ZXLUILoopScrollViewDelegate <NSObject>
@optional
-(void)clickMoreBtn:(ZXLUILoopScrollView *)loopScrollView;
-(void)onSelectImageTap:(ZXLUILoopScrollView *)loopScrollView;
-(void)onSelectImageLongTapL:(ZXLUILoopScrollView *)loopScrollView;
-(void)LoopscrollViewDidScroll:(ZXLUILoopScrollView *)loopScrollView;
-(void)LoopScrollViewDidEndDecelerating:(ZXLUILoopScrollView *)loopScrollView;
-(void)LoopScrollViewWillBeginDragging:(ZXLUILoopScrollView *)loopScrollView;
-(void)LoopScrollViewWillBeginDecelerating:(ZXLUILoopScrollView *)loopScrollView;
@end

@interface ZXLUILoopScrollView : UIView
@property (nonatomic,weak) id<ZXLUILoopScrollViewDelegate> delegate;
@property (nonatomic,readonly) UIScrollView * scrollView; //滚动View
@property (nonatomic,readonly) UIPageControl * pagecontrol; //界面下面的小白点
@property (nonatomic,assign)   NSInteger nViewCount;//界面总数
@property (nonatomic,assign) NSInteger nCurrentPage;//当前界面索引


-(instancetype)initCreateView:(ZXLLoopScrollViewStyle)scrollViewType
              tapGesture:(BOOL)tapGesture
        longPressGesture:(BOOL)longPressGesture
             pageControl:(BOOL)bShowControl
            rollingDelay:(NSTimeInterval)time;

-(void)startRolling;
-(void)addObject:(NSArray *)ayObject;
-(void)scrollToPageIndex:(NSInteger)nIndex;
-(UIView *)getViewIndex:(NSInteger)nIndex;
@end
