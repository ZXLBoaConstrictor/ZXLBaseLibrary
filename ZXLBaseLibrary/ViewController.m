//
//  ViewController.m
//  ZXLBaseLibrary
//
//  Created by 张小龙 on 2018/10/9.
//  Copyright © 2018 张小龙. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import <ZXLBaseLibrary/ZXLExtensionModule.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:@"2019-01-21 00:00:00"];
    
    if (datestr.isYesterday) {
        NSLog(@"isYesterday");
    }
  
    // Do any additional setup after loading the view, typically from a nib.
}

@end
