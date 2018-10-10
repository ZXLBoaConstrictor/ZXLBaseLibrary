//
//  ZXLRouter.h
//  FBSnapshotTestCase
//
//  Created by 张小龙 on 2018/6/25.
//

#import <Foundation/Foundation.h>

@protocol ZXLRouterInitVcProtocol <NSObject>
- (instancetype)initWithParams:(NSDictionary *)params;
@end

@protocol ZXLRouterProtocol <NSObject>
-(void)achievedTransaction:(NSString *)tCode parameter:(id)parameter delegate:(id)delegate;
-(BOOL)achievedTransactionURL:(NSString *)tURL;
@end

typedef void (^ZXLRouterCompleteBlock)(id complete);
typedef id (^ZXLRouterBlock)(ZXLRouterCompleteBlock completeBlock,NSDictionary* parameter);

@interface ZXLRouter : NSObject <ZXLRouterProtocol>
@property (nonatomic,strong)UINavigationController *navigationVC;
+(instancetype)manager;

/**
 事务路由注册

 @param routePattern 路由链接
 @param handlerBlock 事务实现block
 */
-(void)registerTo:(NSString *)routePattern handler:(ZXLRouterBlock)handlerBlock;

/**
 事务VC路由注册

 @param routePattern 路由链接
 @param vcClassStr 事务VC字符串
 */
-(void)registerTo:(NSString *)routePattern classStr:(NSString *)vcClassStr;

/**
  事务VC路由注册

 @param routePattern  路由链接
 @param vcClass 事务VC
 */
-(void)registerTo:(NSString *)routePattern class:(Class)vcClass;


/**
 路由调用（不需要返回值调用方式）

 @param routePattern 路由链接
 */
-(void)call:(NSString *)routePattern;

/**
  路由调用

 @param routePattern 路由链接
 @param completeBlock 返回block
 */
-(void)call:(NSString *)routePattern complete:(ZXLRouterCompleteBlock)completeBlock;

/**
 事务VC路由 push

 @param routePattern 路由链接
 @return 事务VC
 */
-(UIViewController *)push:(NSString *)routePattern;

/**
 事务VC路由 present

 @param routePattern 路由链接
 @return 事务VC
 */
-(UIViewController *)present:(NSString *)routePattern;

/**
 事务VC路由 present UINavigationController(注:事务VC包裹一层UINavigationController)

 @param routePattern 路由链接
 @return 事务VC
 */
-(UIViewController *)presentNav:(NSString *)routePattern;


/**
 获取当前界面的主控制器
 
 @param navigationController super 控制器
 @return 当前界面的主控制器
 */
+(UINavigationController *)getTopUINavigationController:(UINavigationController *)navigationController;

/**
 获取当前控制器的最上层VC
 
 @return VC
 */
+(UIViewController *)getTopUIViewController;

/**
 最上层主控制器push VC
 
 @param pVC 要打开的UIViewController
 @param animated 动画设置
 */
+(void)pushViewController:(UIViewController *)pVC animated:(BOOL)animated;

/**
 最上层主控制器pop VC
 
 @param animated 动画设置
 */
+(void)popViewController:(BOOL)animated;
//关闭到之前的某个界面(不包含当前界面)
+(void)popToViewController:(Class)vcClass animated:(BOOL)animated;
//关闭到之前的某个界面(包含当前界面)
+(void)popToViewFrontController:(Class)vcClass animated:(BOOL)animated;
//关闭到首页的VC
+(void)popViewControllerOnlyMainVC:(BOOL)animated;
//Present 界面
+(void)presentViewController:(UIViewController *)pVC animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 所有事务路由处理接口

 @param tCode 事务号
 @param parameter 参数
 */
+(void)transactionCode:(NSInteger)tCode parameter:(id)parameter;

/**
 所有事务路由处理接口（带代理）
 
 @param tCode 事务号
 @param parameter 参数
 @param delegate 代理
 */
+(void)transactionCode:(NSInteger)tCode parameter:(id)parameter delegate:(id)delegate;

/**
 所有事务路由处理接口(URL路径解析式)

 @param tURL 事务路径
 */
+(BOOL)transactionURL:(NSString *)tURL;
@end
