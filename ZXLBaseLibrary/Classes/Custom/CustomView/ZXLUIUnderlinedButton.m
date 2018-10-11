//
//  ZXLUIUnderlinedButton.m
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/6/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLUIUnderlinedButton.h"
#import <ZXLSettingDefined.h>

@implementation ZXLUIUnderlinedButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.flineheight = 2*ViewScaleValue;
    }
    return self;
}

-(void)dealloc{
    self.lineColor = nil;
}



- (void) drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if (self.selected){
        
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(contextRef, 2*ViewScaleValue);
        // set to same colour as text
        CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
        
        CGContextMoveToPoint(contextRef,MAX(0, (rect.size.width - 13*ViewScaleValue)/2)  , rect.size.height - 2.5*ViewScaleValue);
        
        CGContextAddLineToPoint(contextRef, (rect.size.width - 13*ViewScaleValue)/2 + 13*ViewScaleValue , rect.size.height - 2.5*ViewScaleValue);
        
        CGContextDrawPath(contextRef, kCGPathStroke);
    }
}


@end
