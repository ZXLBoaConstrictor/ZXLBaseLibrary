//
//  ZXLUIScrollView.m
//  Compass
//
//  Created by 张小龙 on 2018/9/5.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import "ZXLUIScrollView.h"
#import <ZXLUtilsDefined.h>
@interface ZXLUIScrollView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation ZXLUIScrollView
- (instancetype)init{
    self = [super init];
    if (self){
        self.delegate = self;
        self.bGestureRecognizer = NO;
    }
    return self;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (!self.bGestureRecognizer) {
        return NO;
    }
    
    if(gestureRecognizer.state != 0) {
        return YES;
    }else {
        return NO;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    ZXLCloseKeyBord(YES);
}
@end
