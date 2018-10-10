//
//  NSDictionary+ZXLExtension.h
//  FBSnapshotTestCase
//
//  Created by 张小龙 on 2018/6/22.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ZXLExtension)
- (NSString*)JSONString;
- (NSString *)stringValueForKey:(NSString *)key;
- (NSArray *)arrayValueForKey:(NSString *)key;
- (NSDictionary *)dictionaryValueForKey:(NSString *)key;
- (BOOL)isApiName:(NSString *)apiName;
- (BOOL)apiSuccess;
- (NSInteger)errorNumber;
@end
