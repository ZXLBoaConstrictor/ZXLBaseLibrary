//
//  ZXLSettingFunction.m
//  ZXLSettingModule
//
//  Created by 张小龙 on 2018/6/27.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLSettingFunction.h"
#import "ZXLGlobalVariables.h"
#import <UIImage+ZXLExtension.h>

@implementation ZXLSettingFunction

+(NSDictionary *)filesBrowserFileInfo:(ZXLFileType)dataType dateinfo:(id)dateInfo dateURL:(NSString *)dateURL fromAlbum:(BOOL)bFromAlbum{
    
    if (!dateInfo) return nil;
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"%lu",(unsigned long)dataType] forKey:@"dataType"];
    [dict setValue:dateInfo forKey:@"dataInfo"];
    [dict setValue:dateURL forKey:@"dataURL"];
    if (bFromAlbum) {
        [dict setValue:@"1" forKey:@"fromAlbum"];
    }
    return dict;
}

+(NSDictionary *)filesBrowserData:(NSArray *)dataInfo Index:(NSInteger)index{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:dataInfo forKey:@"dataInfo"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)index] forKey:@"index"];
    return dict;
}
@end
