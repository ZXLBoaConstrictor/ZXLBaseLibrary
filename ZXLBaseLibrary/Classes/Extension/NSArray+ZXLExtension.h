//
//  NSArray+ZXLExtension.h
//  FBSnapshotTestCase
//
//  Created by 张小龙 on 2018/6/22.
//

#import <Foundation/Foundation.h>

@interface NSArray (ZXLExtension)
- (NSString*)JSONString;
- (NSString *)stringAtIndex:(NSUInteger)index;
- (NSArray *)arrayAtIndex:(NSUInteger)index;
- (NSDictionary *)dictionaryAtIndex:(NSUInteger)index;
@end
