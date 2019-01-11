//
//  ZXLLog.h
//  Pods
//
//

#ifndef ZXLExtensionLog_h
#define ZXLExtensionLog_h

#define DEBUG_FLAG NO

//#ifdef DEBUG
//#define DEBUG_FLAG YES
//#else
//#define DEBUG_FLAG NO
//#endif

#ifdef DEBUG
#define ZXLLog(fmt,...) NSLog((@"\n\n[codeLine]%d\n" "[functionName]%s\n" "[Log]" fmt"\n"),__LINE__,__FUNCTION__,##__VA_ARGS__);
#define ZXLLogError(arg,...) \
{\
if([arg isKindOfClass:[NSException class]] || [arg isKindOfClass:[NSError class]]){\
NSLog(@"\n\n[codeLine]%d\n" "[functionName]%s\n" "[Log]%@\n", __LINE__, __FUNCTION__, arg);\
}else{\
NSLog((@"\n\n[codeLine]%d\n" "[functionName]%s\n" "[Log]" #arg"\n"), __LINE__, __FUNCTION__, ##__VA_ARGS__); }\
}
#else
#define ZXLLog(fmt,...);
#define ZXLLogError(arg,...) \
{\
if([arg isKindOfClass:[NSException class]] || [arg isKindOfClass:[NSError class]]){\
NSLog(@"\n\n[codeLine]%d\n" "[functionName]%s\n" "[Log]%@\n", __LINE__, __FUNCTION__, arg);\
}else{\
NSLog((@"\n\n[codeLine]%d\n" "[functionName]%s\n" "[Log]" #arg"\n"), __LINE__, __FUNCTION__, ##__VA_ARGS__); }\
}
#endif


#endif /* ZXLExtensionLog_h */
