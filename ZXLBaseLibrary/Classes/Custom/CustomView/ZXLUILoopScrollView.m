//
//  ZXLUILoopScrollView.m
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/6/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLUILoopScrollView.h"
#import <ZXLUtilsDefined.h>
#import <ZXLSettingDefined.h>
#import <UIImage+ZXLExtension.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import <Masonry/Masonry.h>

@interface ZXLUILoopScrollView()<UIScrollViewDelegate>

@property (nonatomic,assign) BOOL bTapGesture;//图片点击 默认不支持
@property (nonatomic,assign) BOOL bLongPressGesture; //图片长按 默认不支持
@property(nonatomic,assign)ZXLLoopScrollViewStyle loopScrollViewType; //界面类型
@property(nonatomic,assign)NSTimeInterval rollingDelayTime; //滚动时间
@property (nonatomic, strong) UIButton *moreBtn;//右上角更多btn
@end

@implementation ZXLUILoopScrollView

-(instancetype)initCreateView:(ZXLLoopScrollViewStyle)scrollViewType
              tapGesture:(BOOL)tapGesture
        longPressGesture:(BOOL)longPressGesture
             pageControl:(BOOL)bShowControl
            rollingDelay:(NSTimeInterval)time{
    if (self = [super init]) {
        
        self.loopScrollViewType = scrollViewType;
        self.rollingDelayTime = time;
        self.bTapGesture = tapGesture;
        self.bLongPressGesture = longPressGesture;
        self.nCurrentPage = -1;
        
        if (_scrollView == nil){
            _scrollView = ZXLNewObject(UIScrollView);
            _scrollView.showsHorizontalScrollIndicator = NO;
            _scrollView.showsVerticalScrollIndicator = NO;
            _scrollView.scrollsToTop = NO;
            _scrollView.pagingEnabled = YES;
            _scrollView.userInteractionEnabled = YES;
            _scrollView.delegate = self;
            _scrollView.minimumZoomScale = 1.0;
            _scrollView.maximumZoomScale = 3.0;
            
            [self addSubview:_scrollView];
            
            if (@available(iOS 11.0, *)) {
                _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
            
            [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
        if (bShowControl) {
            if (_pagecontrol == nil){
                _pagecontrol = [[UIPageControl alloc]init];
                _pagecontrol.currentPage = 0;//当前页数
                [self addSubview:_pagecontrol];
                
                [_pagecontrol mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self);
                    make.right.equalTo(self);
                    make.top.equalTo(self.mas_bottom).offset(-20);
                    make.height.equalTo(@(10));
                }];
            }
        }
    
        if (self.bTapGesture) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
            //添加tap手势
            [self addGestureRecognizer:tap];
        }
        
        if (self.bLongPressGesture) {
            
            UILongPressGestureRecognizer *longtap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongTap:)];
            [self addGestureRecognizer:longtap];
        }
    }
    return self;
}

-(void)dealloc{
 
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)addObject:(NSArray *)ayObject{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    self.nCurrentPage = -1;
    if (ayObject && [ayObject count] > 0) {
        
        switch (self.loopScrollViewType) {
            case ZXLLoopScrollViewDefault:
            {
                for (NSInteger i = 0; i < [ayObject count]; i++) {
                    UIView * view = [ayObject objectAtIndex:i];
                    if (view && [view isKindOfClass:[UIView class]]) {
                        view.tag = 0x10000 + i;
                        [self.scrollView addSubview:view];
                        
                        [view mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self->_scrollView).offset(i*UIScreenFrameWidth);
                            make.top.equalTo(self->_scrollView);
                            make.width.equalTo(self->_scrollView);
                            make.height.equalTo(self->_scrollView);
                        }];
                    }
                }
            }
                break;
            case ZXLLoopScrollViewPNG:
            case ZXLLoopScrollViewPNGServer:
            {
                for (NSInteger i = 0; i < [ayObject count]; i++) {
                    UIImageView *imageView = (UIImageView *)[self.scrollView viewWithTag:0x10000 + i];
                    if (imageView == nil) {
                        imageView = ZXLNewObject(UIImageView);
                        imageView.contentMode = UIViewContentModeScaleAspectFill;
                        imageView.clipsToBounds = YES;
                        imageView.tag =  0x10000 + i;
                        [self.scrollView addSubview:imageView];
                        
                        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self->_scrollView).offset(i*UIScreenFrameWidth);
                            make.top.equalTo(self->_scrollView);
                            make.width.equalTo(self->_scrollView);
                            make.height.equalTo(self->_scrollView);
                        }];
                    }
                    
                    if (self.loopScrollViewType == ZXLLoopScrollViewPNGServer) {
                        id imageURL = [ayObject objectAtIndex:i];
                        if (imageURL && [imageURL isKindOfClass:[NSString class]] && ((NSString *)imageURL).length > 0) {
                            __block UIImageView * blockImageView = imageView;
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                [blockImageView sd_setImageWithURL:[NSURL URLWithString:[ayObject objectAtIndex:i]] completed:^(UIImage * image, NSError * error, SDImageCacheType cacheType, NSURL * imageURL) {
                                    if (image) {
                                        blockImageView.image = image;
                                    }
                                }];
                            });
                        }
                    }else{
                        id image = [ayObject objectAtIndex:i];
                        if (image && [image isKindOfClass:[UIImage class]]) {
                            imageView.image = image;
                        }
                    }
                }
            }
                break;
            default:
                break;
        }
        
        self.nViewCount = ayObject.count;
        self.scrollView.contentSize = CGSizeMake(self.nViewCount * UIScreenFrameWidth, 0);
        
        if (self.pagecontrol != nil) {
            if (self.nViewCount > 1) {
                self.pagecontrol.numberOfPages = self.nViewCount;
                self.pagecontrol.hidden = NO;
            }else{
                self.pagecontrol.hidden = YES;
            }
        }
    }
}

-(void)scrollToPageIndex:(NSInteger)nIndex{
    if (nIndex < self.nViewCount && nIndex != self.nCurrentPage){
        [_scrollView setContentOffset:CGPointMake(UIScreenFrameWidth * nIndex, 0) animated:YES];
        self.nCurrentPage = nIndex;
        
        if (self.pagecontrol != nil) {
            self.pagecontrol.currentPage = self.nCurrentPage;
        }
    }
}

-(UIView *)getViewIndex:(NSInteger)nIndex{
    if (self.scrollView.subviews.count > nIndex) {
        return [self.scrollView.subviews objectAtIndex:nIndex];
    }
    return nil;
}

- (void)onTap:(UITapGestureRecognizer *)tap{
    if ([((UITapGestureRecognizer *)tap) view] == self){
        if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectImageTap:)]){
            [self.delegate onSelectImageTap:self];
        }
    }
}

-(void)onLongTap:(UILongPressGestureRecognizer *)tap{
    UILongPressGestureRecognizer *tmpTap = (UILongPressGestureRecognizer *)tap;
    if ([tmpTap state] == UIGestureRecognizerStateBegan){
        if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectImageLongTapL:)]){
            [self.delegate onSelectImageLongTapL:self];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LoopscrollViewDidScroll:)]){
        [self.delegate LoopscrollViewDidScroll:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LoopScrollViewWillBeginDragging:)]){
        [self.delegate LoopScrollViewWillBeginDragging:self];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LoopScrollViewWillBeginDecelerating:)]){
        [self.delegate LoopScrollViewWillBeginDecelerating:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / UIScreenFrameWidth;
    if (self.nCurrentPage == index) {
        return;
    }
    
    self.nCurrentPage = index;
    if (self.pagecontrol != nil) {
        self.pagecontrol.currentPage = self.nCurrentPage;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LoopScrollViewDidEndDecelerating:)]){
        [self.delegate LoopScrollViewDidEndDecelerating:self];
    }
}

//Rolling
- (void)startRolling{
    if (self.nViewCount <= 1 || self.rollingDelayTime == 0)
        return;
    
    [self stopRolling];
    
    [self performSelector:@selector(rollingAction) withObject:nil afterDelay:self.rollingDelayTime];
}

- (void)stopRolling{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingAction) object:nil];
}

- (void)rollingAction{
    CGFloat x = (int)_scrollView.contentOffset.x + UIScreenFrameWidth;
    if (x >= _scrollView.contentSize.width){
        x = 0;
    }
    __weak  typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.scrollView.contentOffset = CGPointMake(x, 0);
        weakSelf.nCurrentPage = (int)weakSelf.scrollView.contentOffset.x / UIScreenFrameWidth;
        if (weakSelf.pagecontrol != nil) {
            weakSelf.pagecontrol.currentPage = weakSelf.nCurrentPage;
        }
    } completion:^(BOOL finished) {
        [weakSelf performSelector:@selector(rollingAction) withObject:nil afterDelay:weakSelf.rollingDelayTime];
    }];
}
@end
