//
//  ZXLAccountManager.h
//  AFNetworking
//
//  Created by 张小龙 on 2019/3/7.
//

#import <Foundation/Foundation.h>

@interface ZXLAccountManager : NSObject
@property (nonatomic,copy)NSString * token; //token
@property (nonatomic,copy)NSString * refreshToken; //refreshToken
@property (nonatomic,assign) BOOL isLogin; //登录状态

+(instancetype)manager;

-(void)setAccountData:(NSDictionary *)responseData;
@end
