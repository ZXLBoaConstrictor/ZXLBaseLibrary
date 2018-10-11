//
//  ZXLProgressView.m
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/7/3.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLProgressView.h"
#define kCCProgressFillColor                [UIColor clearColor]
#define kCCProgressTintColor                [UIColor yellowColor]
#define kCCTrackTintColor                   [UIColor lightGrayColor]

#define kAnimTimeInterval 0.35

@interface ZXLProgressView ()

@property(nonatomic, strong) CAShapeLayer *trackLayer;
@property(nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation ZXLProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

#pragma mark - private
- (void)initSubviews{
    _progressViewStyle = ZXLProgressViewStyleDefault;
    _progressTintColor = kCCProgressTintColor;
    _trackTintColor = kCCTrackTintColor;
    _lineWidth = 10;
    
    _fillColor = kCCProgressFillColor;
    _clockwise = YES;
    _startAngle = - M_PI / 2.0;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.trackLayer = [CAShapeLayer layer];
    self.trackLayer.lineCap = kCALineCapButt;
    self.trackLayer.lineJoin = kCALineCapButt;
    self.trackLayer.lineWidth = _lineWidth;
    self.trackLayer.fillColor = nil;
    self.trackLayer.strokeColor = _trackTintColor.CGColor;
    self.trackLayer.frame = self.bounds;
    [self.layer addSublayer:self.trackLayer];
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.lineCap = kCALineCapButt;
    self.progressLayer.lineJoin = kCALineCapButt;
    self.progressLayer.lineWidth = _lineWidth;
    self.progressLayer.fillColor = _fillColor.CGColor;
    self.progressLayer.strokeColor = _progressTintColor.CGColor;
    self.progressLayer.frame = self.bounds;
    [self.layer addSublayer:self.progressLayer];
    
    self.progressLayer.strokeEnd = 0.0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateLayerPath];
}

#pragma mark - private
- (void)updateLayerPath
{
    if (_progressViewStyle == ZXLProgressViewStyleCircle) {
        
        self.trackLayer.frame = self.bounds;
        self.progressLayer.frame = self.bounds;
        
        CGFloat radius = CGRectGetWidth(self.frame) > CGRectGetHeight(self.frame) ?
        (CGRectGetHeight(self.frame) - _lineWidth) / 2.0 : (CGRectGetWidth(self.frame) - _lineWidth) / 2.0;
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:self.progressLayer.position radius:radius startAngle:_startAngle endAngle:_clockwise ? _startAngle + 2 * M_PI : _startAngle - 2 * M_PI clockwise:_clockwise];
        self.trackLayer.path = bezierPath.CGPath;
        self.progressLayer.path = bezierPath.CGPath;
        
    } else {
        
        self.trackLayer.frame = CGRectMake(0, (CGRectGetHeight(self.frame) - _lineWidth) / 2.0, CGRectGetWidth(self.frame), _lineWidth);
        self.progressLayer.frame = self.trackLayer.frame;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(0, self.progressLayer.position.y)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), self.progressLayer.position.y)];
        self.trackLayer.path = bezierPath.CGPath;
        self.progressLayer.path = bezierPath.CGPath;
    }
}

#pragma mark - setter
- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    _trackTintColor = trackTintColor;
    self.trackLayer.strokeColor = trackTintColor.CGColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressTintColor = progressTintColor;
    self.progressLayer.strokeColor = progressTintColor.CGColor;
}

- (void)setProgressFullTintColor:(UIColor *)progressFullTintColor
{
    _progressFullTintColor = progressFullTintColor;
    if (self.progressLayer.strokeEnd >= 1.0) {
        self.progressLayer.strokeEnd = 1.0;
        self.progressLayer.strokeColor = _progressFullTintColor.CGColor;
    }
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    self.trackLayer.lineWidth = lineWidth;
    self.progressLayer.lineWidth = lineWidth;
    if (_progressViewStyle != ZXLProgressViewStyleCircle) {
        [self updateLayerPath];
    }
}

#pragma mark - setter (ZXLProgressViewStyleCircle)
- (void)setFillColor:(UIColor *)fillColor{
    _fillColor = fillColor;
    self.progressLayer.fillColor = fillColor.CGColor;
}

- (void)setClockwise:(BOOL)clockwise{
    _clockwise = clockwise;
    [self updateLayerPath];
}

- (void)setStartAngle:(CGFloat)startAngle{
    _startAngle = startAngle;
    [self updateLayerPath];
}

- (void)setProgress:(CGFloat)progress{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setProgress:progress animated:NO];
    });
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    if (animated) {  // 这里的动画可以直接使用CABasicAnimation
        NSString *animationKey = @"progressAnimation";
        CABasicAnimation *basicAnim = [self.layer animationForKey:animationKey];
        if (basicAnim) {
            basicAnim.duration = kAnimTimeInterval;
            basicAnim.toValue = @(progress);
        } else {
            basicAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            basicAnim.fromValue = @(self.progressLayer.strokeEnd);
            basicAnim.toValue = @(progress);
            basicAnim.duration = 4 * kAnimTimeInterval;
            basicAnim.removedOnCompletion = YES;
        }
        [self.progressLayer addAnimation:basicAnim forKey:animationKey];
    } else {
        self.progressLayer.strokeEnd = progress;
        if (self.progressLayer.strokeEnd >= 1.0 && _progressFullTintColor) {
            self.progressLayer.strokeEnd = 1.0;
            self.progressLayer.strokeColor = _progressFullTintColor.CGColor;
        }
    }
}
@end
