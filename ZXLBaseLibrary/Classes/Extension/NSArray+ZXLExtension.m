//
//  NSArray+ZXLExtension.m
//  FBSnapshotTestCase
//
//  Created by 张小龙 on 2018/6/22.
//

#import "NSArray+ZXLExtension.h"
#import "NSObject+ZXLExtension.h"

@implementation NSArray (ZXLExtension)
+ (void)load{
    if (!DEBUG_FLAG) {
        [[self class] zxlSwizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(replace_objectAtIndex:)];
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

- (id)replace_objectAtIndex:(NSUInteger)index{
    if (index < 0 || index >= [self count] || [self count] == 0){
        return nil;
    }
    
   return [self replace_objectAtIndex:index];
}

@end
