//
//  ViewController.m
//  ZXLBaseLibrary
//
//  Created by 张小龙 on 2018/10/9.
//  Copyright © 2018 张小龙. All rights reserved.
//

#import "ViewController.h"

#define BASEDocument       @"ZXLDocumentFile"
#define FILE_DIRECTORY             [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * fileURL = @"/var/mobile/Containers/Data/Application/49105582-F127-45BC-8875-3A7FE458F08D/Documents/ZXLDocumentFile/ZXLVideo/jlboss2fb8b0f99dd5b05843142c27ade6dfd5.mp4";
    NSString *newURL = @"";

    NSString *folderName = [self systemtFolderName:fileURL];
    if (folderName.length > 0) {
        NSString *tempFolderName = [NSString stringWithFormat:@"/%@/",folderName];
        
        newURL = [fileURL substringFromIndex:[fileURL rangeOfString:tempFolderName].location];
        newURL = [newURL stringByReplacingOccurrencesOfString:tempFolderName withString:@""];
        newURL = [NSString stringWithFormat:@"%@/%@",FILE_DIRECTORY,newURL];
        
        NSLog(@"%@",newURL);
        
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSString *)systemtFolderName:(NSString *)fileURL{
    if ([fileURL rangeOfString:@"var/mobile/Containers/Data/Application/"].location == NSNotFound)
        return @"";
    
    if ([fileURL rangeOfString:@"/Documents/"].location != NSNotFound) {
        return @"Documents";
    }
    
    if ([fileURL rangeOfString:@"/Library/"].location != NSNotFound) {
        return @"Library";
    }
    
    if ([fileURL rangeOfString:@"/tmp/"].location != NSNotFound) {
        return @"tmp";
    }
    
    return @"";
}

@end
