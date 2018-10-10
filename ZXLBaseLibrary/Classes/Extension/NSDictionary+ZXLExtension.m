//
//  NSDictionary+ZXLExtension.m
//  FBSnapshotTestCase
//
//  Created by 张小龙 on 2018/6/22.
//

#import "NSDictionary+ZXLExtension.h"

@implementation NSDictionary (ZXLExtension)
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
