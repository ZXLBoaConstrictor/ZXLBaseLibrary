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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * str = @"  aa aa   ";
    NSCharacterSet  *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    str = [str stringByTrimmingCharactersInSet:set];

    NSLog(@"%@",str);
    // Do any additional setup after loading the view, typically from a nib.
}

@end
