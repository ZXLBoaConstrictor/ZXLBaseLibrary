//
//  ZXLAddressManager.m
//  BaseUtilsModule_Example
//
//  Created by 张小龙 on 2018/6/15.
//  Copyright © 2018年 244061043@qq.com. All rights reserved.
//

#import "ZXLAddressManager.h"
#import "ZXLServerAddress.h"

@interface ZXLAddressManager()
@property (nonatomic,strong)ZXLServerAddress * serverAddress;
@end

@implementation ZXLAddressManager

static dispatch_once_t pred = 0;
__strong static ZXLAddressManager * addressManager = nil;

+ (instancetype)manager{
    dispatch_once(&pred, ^{
        addressManager = [[ZXLAddressManager alloc] init];
    });
    return addressManager;
}

+(void)attemptDealloc{
    pred = 0;
    addressManager = nil;
}

-(instancetype)init{
    if (self == [super init]) {
        self.serverAddress = [ZXLServerAddress manager];
        [self setReleaseAddress];
    }
    return self;
}

-(void)setReleaseAddress{
    switch ([ZXLServerAddress manager].releaseType) {
        case ZXLReleasePreProductionType://预发环境地址
        {
            _socketHost         = @"test-link.bestZXL.com";
            _socketPort         = @"5150";
            _address            = @"https://test-web-api.bestZXL.com/";
            
            _bucketName         = @"ZXLapp";
            _endPoint           = @"https://oss-cn-hangzhou.aliyuncs.com";
            _downloadfileURL    = @"https://images2.bestZXL.com/";
        }
            break;
        case ZXLReleaseDevelopmentType: //测试环境
        {
            _socketHost         = @"101.69.254.162";
            _socketPort         = @"5150";
            _address            = @"http://10.10.10.23:8101/";
            
            _bucketName         = @"ZXLapp";
            _endPoint           = @"https://oss-cn-hangzhou.aliyuncs.com";
            _downloadfileURL    = @"https://images2.bestZXL.com/";
        }
            break;
        default:    //正式环境
        {
            _socketHost         = @"link.bestZXL.com";
            _socketPort         = @"5150";
            _address            = @"https://web-api.bestZXL.com/";
            
            _bucketName         = @"ZXL-oss";
            _endPoint           = @"https://oss-cn-hangzhou.aliyuncs.com";
            _downloadfileURL    = @"https://media.bestZXL.com/";
        }
            break;
    }
    
    [[ZXLServerAddress manager] setCompanyHost:@[@"bestZXL.com",@"zhixuezhen.com",@"10.10.10.22",@"101.69.254.162"]];
}

+(NSString *)systemAddress:(ZXLAddressType)addressType{
    switch (addressType) {
            case ZXLHOST:          return [ZXLAddressManager manager].socketHost; break;
            case ZXLPORT:          return [ZXLAddressManager manager].socketPort; break;
            case ZXLURLStr:        return [ZXLAddressManager manager].address;  break;
            case ZXLFileURLStr:    return [ZXLAddressManager manager].downloadfileURL;break;
        default: break;
    }
    return @"";
}
@end
