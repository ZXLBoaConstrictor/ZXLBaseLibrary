//
//  NSString+Route.h
//  ZXLRouterModule
//
//  Created by 张小龙 on 2018/9/12.
//

#import <Foundation/Foundation.h>

@interface NSString (ZXLRouter)
+ (instancetype)route:(NSString *)route addParams:(NSDictionary *)params;
+ (NSString *)routeInRoutePattern:(NSString *)routePattern;
+ (NSDictionary *)paramsInRoutePattern:(NSString *)routePattern;
@end
