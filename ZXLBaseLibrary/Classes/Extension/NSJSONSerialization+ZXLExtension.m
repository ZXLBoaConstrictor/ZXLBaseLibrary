//
//  NSJSONSerialization+ZXLExtension.m
//  AFNetworking
//
//  Created by 张小龙 on 2019/1/10.
//

#import "NSJSONSerialization+ZXLExtension.h"
#import "NSObject+ZXLExtension.h"

@implementation NSJSONSerialization (ZXLExtension)
+ (void)load {
    if (!DEBUG_FLAG) {
        [self zxlSwizzleClassMethod:@selector(dataWithJSONObject:options:error:) swizzledSelector:@selector(replace_dataWithJSONObject:options:error:)];
        [self zxlSwizzleClassMethod:@selector(JSONObjectWithData:options:error:) swizzledSelector:@selector(replace_JSONObjectWithData:options:error:)];
    }
}

+ (NSData *)replace_dataWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError * _Nullable __autoreleasing *)error {
    @try {
        return [self replace_dataWithJSONObject:obj options:opt error:error];
    }
    @catch (NSException *exception) {
        ZXLLogError(exception);
    }
    return nil;
}

+ (id)replace_JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError * _Nullable __autoreleasing *)error {
    @try {
        return [self replace_JSONObjectWithData:data options:opt error:error];
    }
    @catch (NSException *exception) {
        ZXLLogError(exception);
    }
    return nil;
}
@end
