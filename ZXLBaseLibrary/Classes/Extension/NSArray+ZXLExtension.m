//
//  NSArray+ZXLExtension.m
//  FBSnapshotTestCase
//
//  Created by 张小龙 on 2018/6/22.
//

#import "NSArray+ZXLExtension.h"

@implementation NSArray (ZXLExtension)
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

- (NSString *)stringAtIndex:(NSUInteger)index{
    int  nTmp = 0;
    if (index < nTmp || index >= [self count] || [self count] == 0){
        return @"";
    }
    
    
    id Value = [self objectAtIndex:index];
    if ((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSString class]]){
        if ((NSString *)Value != nil && [(NSString *)Value length] > 0){
            return (NSString *)Value;
        }
    }
    
    if ((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSNumber class]]){
        return [NSString stringWithFormat:@"%ld",[Value longValue]];
    }
    
    return @"";
}

- (NSArray *)arrayAtIndex:(NSUInteger)index{
    int  nTmp = 0;
    if (index < nTmp || index >= [self count] || [self count] == 0){
        return nil;
    }
    
    id Value = [self objectAtIndex:index];
    if ((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSArray class]]){
        return (NSArray *)Value;
    }
    
    return nil;
}

- (NSDictionary *)dictionaryAtIndex:(NSUInteger)index{
    int  nTmp = 0;
    if (index < nTmp || index >= [self count] || [self count] == 0){
        return nil;
    }
    
    id Value = [self objectAtIndex:index];
    if ((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSDictionary class]]){
        return (NSDictionary *)Value;
    }
    return nil;
}
@end
