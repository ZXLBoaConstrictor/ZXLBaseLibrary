//
//  NSDictionary+ZXLExtension.m
//  FBSnapshotTestCase
//
//  Created by 张小龙 on 2018/6/22.
//

#import "NSDictionary+ZXLExtension.h"
#import "NSObject+ZXLExtension.h"

@implementation NSDictionary (ZXLExtension)
+ (void)load {
    if (!DEBUG_FLAG) {
        [objc_getClass("__NSDictionaryI") zxlSwizzleMethod:@selector(objectForKey:) swizzledSelector:@selector(replace_objectForKey:)];
        [objc_getClass("__NSDictionaryI") zxlSwizzleMethod:@selector(length) swizzledSelector:@selector(replace_length)];
        [objc_getClass("__NSDictionaryM") zxlSwizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(replace_setObject:forKey:)];
        [objc_getClass("__NSDictionaryM") zxlSwizzleMethod:@selector(setObject:forKeyedSubscript:) swizzledSelector:@selector(replace_setObject:forKeyedSubscript:)];
        [objc_getClass("__NSPlaceholderDictionary") zxlSwizzleMethod:@selector(initWithObjects:forKeys:count:)
                                                  swizzledSelector:@selector(replace_initWithObjects:forKeys:count:)];
    }
}

- (id)replace_objectForKey:(NSString *)key {
    if ([self isKindOfClass:[NSDictionary class]]) {
        return [self replace_objectForKey:key];
    }
    return nil;
}

- (void)replace_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    @try {
        [self replace_setObject:anObject forKey:aKey];
    }
    @catch (NSException *exception) {
        ZXLLogError(exception);
    }
}

- (instancetype)replace_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    id dictionary = nil;
    @try {
        dictionary = [self replace_initWithObjects:objects
                                           forKeys:keys
                                             count:cnt];
    }
    @catch (NSException *exception) {
        ZXLLogError(exception);
        dictionary = nil;
    }
    return dictionary;
}

- (NSUInteger)py_replace_length {
    return 0;
}

- (void)replace_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    @try {
        [self replace_setObject:obj forKeyedSubscript:key];
    }
    @catch (NSException *exception) {
        ZXLLogError(exception);
    }
}

- (NSString*)JSONString{
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error == nil){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] ;
    }
    return nil;
}

- (NSString *)stringValueForKey:(NSString *)key{
    id Value = [self valueForKey:key];
    if ((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSString class]]){
        if ((NSString *)Value != nil && [(NSString *)Value length] > 0){
            return (NSString *)Value;
        }
    }
    
    if ((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSNumber class]] > 0){
        return [NSString stringWithFormat:@"%ld",[Value longValue]];
    }
    return @"";
}

- (NSArray *)arrayValueForKey:(NSString *)key{
    id Value = [self valueForKey:key];
    if ((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSArray class]]){
        return (NSArray *)Value;
    }
    return nil;
}

- (NSDictionary *)dictionaryValueForKey:(NSString *)key{
    id Value = [self valueForKey:key];
    if ((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSDictionary class]]){
        return (NSDictionary *)Value;
    }
    
    return nil;
}

- (BOOL)isApiName:(NSString *)apiName{
    apiName = [apiName lowercaseString];
    NSString * strApiName = [self objectForKey:@"apiName"];
    strApiName = [strApiName lowercaseString];
    
    if (strApiName && [strApiName length] > 0){
        if ([strApiName isEqualToString:apiName]){
            return true;
        }else{
            return [strApiName isEqualToString:[apiName substringFromIndex:1]];
        }
    }
    return false;
}

-(NSInteger)errorNumber{
    if (self && [self count] > 0){
        id Value = [self objectForKey:@"code"];
        
        if (((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSNumber class]])){
            return [[NSString stringWithFormat:@"%ld",[Value longValue]] integerValue];
        }
        
        if ((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSString class]]){
            return [(NSString *)Value integerValue];
        }
    }
    
    return -1;
}

-(BOOL)apiSuccess{
    if ([self errorNumber] == 200){
        return true;
    }
    return false;
}
@end
