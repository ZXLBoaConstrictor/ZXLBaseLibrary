//
//  NSString+Route.m
//  ZXLRouterModule
//
//  Created by 张小龙 on 2018/9/12.
//

#import "NSString+Route.h"

@implementation NSString (ZXLRouter)
+ (instancetype)route:(NSString *)route addParams:(NSDictionary *)params{
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:route] resolvingAgainstBaseURL:NO];
    NSArray *queryItems = urlComponents.queryItems;
    NSMutableArray *queryItemsCopy = [queryItems mutableCopy];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        for (int i = 0; i < queryItems.count; ++i) {
            NSURLQueryItem *item = queryItems[i];
            if ([item.name isEqualToString:key]) {
                [queryItemsCopy removeObject:item];
            }
        }
        NSURLQueryItem *newItem = [[NSURLQueryItem alloc] initWithName:key value:[NSString stringWithFormat:@"%@", obj]];
        [queryItemsCopy addObject:newItem];
    }];
    
    urlComponents.queryItems = queryItemsCopy;
    return [urlComponents.URL path];
}

+ (NSString *)routeInRoutePattern:(NSString *)routePattern{
    NSInteger location = [routePattern rangeOfString:@"?"].location;
    if (location != NSNotFound) {
        return [routePattern substringToIndex:location];
    }
    return routePattern;
}

+(NSDictionary *)paramsInRoutePattern:(NSString *)routePattern{
    NSString * route = [NSString routeInRoutePattern:routePattern];
    if ([route isEqualToString:routePattern]) return nil;
    
    NSString * strWParam = [routePattern substringFromIndex:route.length + 1];
    NSArray  * ayWParam = [strWParam componentsSeparatedByString:@"&"];
    NSMutableDictionary *dictWParam = [NSMutableDictionary dictionary];
    [ayWParam enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSArray * ayComp =  [(NSString *)obj componentsSeparatedByString:@"="];
            NSString * strKey = @"";
            NSString * strValue = @"";
            if (ayComp.count >= 1) {
                strKey = [ayComp firstObject];
            }
            if (ayComp.count == 2) {
                strValue = [ayComp lastObject];
            }
            [dictWParam setValue:strValue forKey:strKey];
        }
    }];
    return dictWParam;
}
@end
