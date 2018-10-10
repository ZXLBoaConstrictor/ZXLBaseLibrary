//
//  ZXLRouter.m
//  FBSnapshotTestCase
//
//  Created by 张小龙 on 2018/6/25.
//

#import "ZXLRouter.h"
#import "NSString+Route.h"

@interface ZXLRouter()
@property(nonatomic,strong)NSMutableDictionary *routeClassDict;
@property(nonatomic,strong)NSMapTable *routeBlockMap;
@property(nonatomic,strong)NSMapTable *completeBlockMap;
@end

@implementation ZXLRouter

+(instancetype)manager{
    static dispatch_once_t pred = 0;
    __strong static ZXLRouter * router = nil;
    dispatch_once(&pred, ^{
        router = [[ZXLRouter alloc] init];
    });
    return router;
}

-(NSMutableDictionary *)routeClassDict{
    if (!_routeClassDict) {
        _routeClassDict = [[NSMutableDictionary alloc] init];
    }
    return _routeClassDict;
}

-(NSMapTable *)routeBlockMap{
    if (!_routeBlockMap) {
        _routeBlockMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
    }
    return _routeBlockMap;
}

-(NSMapTable *)completeBlockMap{
    if (!_completeBlockMap) {
        _completeBlockMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
    }
    return _completeBlockMap;
}

-(void)registerTo:(NSString *)routePattern handler:(ZXLRouterBlock)handlerBlock{
    NSAssert(routePattern, @"routePattern 不能为空");
    NSAssert(handlerBlock, @"handlerBlock 不能为空");
    if (routePattern && handlerBlock) {
        NSAssert(![self.routeBlockMap objectForKey:routePattern], @"routePattern 已经存在");
        [self.routeBlockMap setObject:handlerBlock forKey:routePattern];
    }
}

-(void)registerTo:(NSString *)routePattern classStr:(NSString *)vcClassStr{
    NSAssert(vcClassStr, @"vcClassStr 不能为空");
    if (vcClassStr == nil || vcClassStr.length <= 0) return;
    
    [self registerTo:routePattern class:NSClassFromString(vcClassStr)];
}

-(void)registerTo:(NSString *)routePattern class:(Class)vcClass{
    NSAssert(routePattern, @"routePattern 不能为空");
    NSAssert(vcClass, @"vcClass 不能为空");
    if (routePattern && vcClass) {
        NSAssert(![self.routeClassDict objectForKey:routePattern], @"routePattern 已经存在");
        [self.routeClassDict setObject:vcClass forKey:routePattern];
    }
}

-(void)call:(NSString *)routePattern{
    NSAssert(routePattern, @"routePattern 不能为空");
    NSString *route = [NSString routeInRoutePattern:routePattern];
    id object = [self.routeBlockMap objectForKey:route];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (object) {
            ((ZXLRouterBlock)object)(nil,[NSString paramsInRoutePattern:routePattern]);
        }
    });
    NSAssert(object, @"routePattern 未注册");
}

-(void)call:(NSString *)routePattern complete:(ZXLRouterCompleteBlock)completeBlock{
    NSAssert(routePattern, @"routePattern 不能为空");
    NSString *route = [NSString routeInRoutePattern:routePattern];
    id object = [self.routeBlockMap objectForKey:route];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (object) {
            ((ZXLRouterBlock)object)(completeBlock,[NSString paramsInRoutePattern:routePattern]);
        }
    });
    NSAssert(object, @"routePattern 未注册");
}


-(UIViewController *)push:(NSString *)routePattern{
    NSAssert(routePattern, @"routePattern 不能为空");
    NSString *route = [NSString routeInRoutePattern:routePattern];
    id object = [self.routeClassDict objectForKey:route];
    if (object) {
        UIViewController *pVC;
        if ([object conformsToProtocol:@protocol(ZXLRouterInitVcProtocol)]) {
            pVC = [[(Class)object alloc] initWithParams:[NSString paramsInRoutePattern:routePattern]];
        }else{
            pVC = [[(Class)object alloc] init];
        }
        [ZXLRouter pushViewController:pVC animated:YES];
        return pVC;
    }
    NSAssert(object, @"routePattern 未注册");
    return nil;
}

-(UIViewController *)present:(NSString *)routePattern{
    NSAssert(routePattern, @"routePattern 不能为空");
    NSString *route = [NSString routeInRoutePattern:routePattern];
    id object = [self.routeClassDict objectForKey:route];
    if (object) {
        UIViewController *pVC;
        if ([object conformsToProtocol:@protocol(ZXLRouterInitVcProtocol)]) {
            pVC = [[(Class)object alloc] initWithParams:[NSString paramsInRoutePattern:routePattern]];
        }else{
            pVC = [[(Class)object alloc] init];
        }
        [ZXLRouter presentViewController:pVC animated:YES completion:nil];
        return pVC;
    }
    NSAssert(object, @"routePattern 未注册");
    return nil;
}

-(UIViewController *)presentNav:(NSString *)routePattern{
    NSAssert(routePattern, @"routePattern 不能为空");
    NSString *route = [NSString routeInRoutePattern:routePattern];
    id object = [self.routeClassDict objectForKey:route];
    if (object) {
        UIViewController *pVC;
        if ([object conformsToProtocol:@protocol(ZXLRouterInitVcProtocol)]) {
            pVC = [[(Class)object alloc] initWithParams:[NSString paramsInRoutePattern:routePattern]];
        }else{
            pVC = [[(Class)object alloc] init];
        }
        UINavigationController *pNav = [[UINavigationController alloc] initWithRootViewController:pVC];
        [ZXLRouter presentViewController:pNav animated:YES completion:nil];
        return pVC;
    }
    NSAssert(object, @"routePattern 未注册");
    return nil;
}


-(void)transactionCode:(NSInteger)tCode parameter:(id)parameter delegate:(id)delegate{
    SEL selAchievedTransaction = NSSelectorFromString(@"achievedTransaction:parameter:delegate:");
    if ([self respondsToSelector:selAchievedTransaction]) {
        [self achievedTransaction:@(tCode).stringValue parameter:parameter delegate:delegate];
    }
}

-(BOOL)transactionURL:(NSString *)tURL{
    SEL selAchievedTransaction = NSSelectorFromString(@"achievedTransactionURL:");
    if ([self respondsToSelector:selAchievedTransaction]) {
        return [self achievedTransactionURL:tURL];
    }
    return NO;
}

+ (UINavigationController *)getTopUINavigationController:(UINavigationController *)navigationController{
    UINavigationController * pNav = navigationController;
    if ([navigationController.presentedViewController isKindOfClass:[UINavigationController class]]){
        if (((UINavigationController *)navigationController.presentedViewController).topViewController){
            pNav = (UINavigationController *)navigationController.presentedViewController;
            pNav  = [ZXLRouter getTopUINavigationController:pNav];
        }
    }
    else{
        pNav = navigationController;
    }
    return pNav;
}

+ (UIViewController *)getTopUIViewController{
    UIViewController *pVC = nil;
    UINavigationController *pNav = [ZXLRouter getTopUINavigationController:[ZXLRouter manager].navigationVC];
    if (pNav){
        if (pNav.presentedViewController){
            pVC = pNav.presentedViewController;
        }else{
            pVC = pNav.topViewController;
        }
    }
    else{
        pVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    }
    return pVC;
}

+(void)pushViewController:(UIViewController *)pVC animated:(BOOL)animated{
    //等支持多个聊天后再开启
    UINavigationController * pNav = [ZXLRouter getTopUINavigationController:[ZXLRouter manager].navigationVC];
    if (pNav){
        //聊天界面重复判断--不允许有2个聊天界面
        if ([pVC isMemberOfClass:NSClassFromString(@"ZXLPrivateMessageVC")]) {
            NSMutableArray * array = [NSMutableArray arrayWithArray:pNav.viewControllers];
            [array enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isMemberOfClass:NSClassFromString(@"ZXLPrivateMessageVC")]) {
                    [array removeObject:obj];
                }
            }];
            
            [array addObject:pVC];
            [pNav setViewControllers:array animated:YES];
            
        }else if ([pVC isMemberOfClass:NSClassFromString(@"ZXLMessageViewController")]){
            NSMutableArray * array = [NSMutableArray arrayWithArray:pNav.viewControllers];
            [array enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isMemberOfClass:NSClassFromString(@"ZXLMessageViewController")]) {
                    [array removeObject:obj];
                }
            }];
            [array addObject:pVC];
            [pNav setViewControllers:array animated:YES];
        }
        else{
            [pNav pushViewController:pVC animated:animated];
        }
    }
}

+(void)popViewController:(BOOL)animated{
    UINavigationController * pNav = [ZXLRouter getTopUINavigationController:[ZXLRouter manager].navigationVC];
    if (pNav){
        [pNav popViewControllerAnimated:animated];
    }
}

+(void)popToViewController:(Class)vcClass animated:(BOOL)animated{
    UINavigationController * pNav = [ZXLRouter getTopUINavigationController:[ZXLRouter manager].navigationVC];
    if (pNav){
        [pNav.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:vcClass]) {
                [pNav popToViewController:obj animated:animated];
                *stop = YES;
            }
        }];
    }
}

+(void)popToViewFrontController:(Class)vcClass animated:(BOOL)animated{
    UINavigationController * pNav = [ZXLRouter getTopUINavigationController:[ZXLRouter manager].navigationVC];
    if (pNav){
        [pNav.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:vcClass] && idx - 1 < [pNav.viewControllers count]) {
                [pNav popToViewController:[pNav.viewControllers objectAtIndex:idx - 1] animated:animated];
                *stop = YES;
            }
        }];
    }
}

+(void)popViewControllerOnlyMainVC:(BOOL)animated{
    UINavigationController * pNav = [ZXLRouter getTopUINavigationController:[ZXLRouter manager].navigationVC];
    if (pNav != [ZXLRouter manager].navigationVC){
        [pNav popToRootViewControllerAnimated: NO];
        [pNav.topViewController dismissViewControllerAnimated:NO completion:nil];
        if (pNav.presentingViewController  != [ZXLRouter manager].navigationVC){
            [ZXLRouter popViewControllerOnlyMainVC:animated];
        }
        pNav = nil;
    }
    else{
        [pNav popToRootViewControllerAnimated:animated];
    }
}

+(void)presentViewController:(UIViewController *)pVC animated:(BOOL)animated completion:(void (^)(void))completion{
    UINavigationController * pNav = [ZXLRouter getTopUINavigationController:[ZXLRouter manager].navigationVC];
    if (pNav){
        [pNav presentViewController:pVC animated:animated completion:completion];
    }
}

+(void)transactionCode:(NSInteger)tCode parameter:(id)parameter{
    [ZXLRouter transactionCode:tCode parameter:parameter delegate:nil];
}

+(void)transactionCode:(NSInteger)tCode parameter:(id)parameter delegate:(id)delegate{
    [[ZXLRouter manager] transactionCode:tCode parameter:parameter delegate:delegate];
}

+(BOOL)transactionURL:(NSString *)tURL{
   return [[ZXLRouter manager] transactionURL:tURL];
}

@end
