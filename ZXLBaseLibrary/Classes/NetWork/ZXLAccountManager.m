//
//  ZXLAccountManager.m
//  AFNetworking
//
//  Created by 张小龙 on 2019/3/7.
//

#import "ZXLAccountManager.h"

@implementation ZXLAccountManager

+(instancetype)manager{
    static dispatch_once_t pred = 0;
    __strong static ZXLAccountManager * manager = nil;
    dispatch_once(&pred, ^{
        manager = [[ZXLAccountManager alloc] init];
    });
    return manager;
}

-(void)setAccountData:(NSDictionary *)responseData{
    
}
@end
