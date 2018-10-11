//
//  ZXLAVAudioPlayer.m
//  ZXZ
//
//  Created by xyt on 16/12/16.
//  Copyright © 2016年 ZXL. All rights reserved.
//

#import "ZXLAVAudioPlayer.h"

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NSString+ZXLExtension.h"

NSString *const kLCCKAudioDataKey;

@interface ZXLAVAudioPlayer () <AVAudioPlayerDelegate>{
    
    AVAudioPlayer *_audioPlayer;
    
}

/**
 *  语音缓存路径,以URLString的MD5编码为key保存
 */
@property (nonatomic, copy, readonly) NSString *cachePath;
@property (nonatomic, strong) NSOperationQueue *audioDataOperationQueue;
@property (nonatomic, assign) BOOL isPlaying;
@end

@implementation ZXLAVAudioPlayer
@synthesize cachePath = _cachePath;

+ (void)initialize {
    //配置播放器配置
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error: nil];

}

+ (instancetype)sharePlayer{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        //添加应用进入后台通知
        UIApplication *app = [UIApplication sharedApplication];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
        
        self.isPlaying = NO;
    }
    return self;
}

/**
 *  lazy load audioDataOperationQueue
 *
 *  @return NSOperationQueue
 */
- (NSOperationQueue *)audioDataOperationQueue {
    if (_audioDataOperationQueue == nil) {
        NSOperationQueue *audioDataOperationQueue  = [[NSOperationQueue alloc] init];
        audioDataOperationQueue.name = @"com.ZXL.AVAudipPlayer.loadAudioDataQueue";
        _audioDataOperationQueue = audioDataOperationQueue;
    }
    return _audioDataOperationQueue;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIApplicationWillResignActiveNotification];
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    
}

#pragma mark - Public Methods

- (void)playAudioWithURLString:(NSString *)URLString identifier:(NSString *)identifier {
    
    //读取偏好设置,配置播放器配置
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isAudioPlayerSwitchOn"]) {
        //听筒播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    }else{
        //扬声器播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    
    if (!URLString) {
        return;
    }
    
    //如果来自同一个URLString并且index相同,则直接取消
    if ([self.URLString isEqualToString:URLString] && self.identifier == identifier) {
        [self stopAudioPlayer];
        return;
    }
    
    //TODO 从URL中读取音频data
    self.URLString = URLString;
    self.identifier = identifier;
    
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSData *audioData = [self audioDataFromURLString:URLString identifier:identifier];
        if (!audioData) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playAudioWithData:audioData];
        });
    }];

    [blockOperation setName:[[NSString stringWithFormat:@"%@_%@",self.URLString, self.identifier] decodeStringMD5]];
    
    [self.audioDataOperationQueue addOperation:blockOperation];
    
}

- (void)cleanAudioCache {
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:self.cachePath];
    for (NSString *file in files) {
        [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
    }
    
}

-(void)pausePlayer
{
    if (_audioPlayer &&  _audioPlayer.playing) {
        [_audioPlayer pause];
    }
}

-(BOOL)pausePlayerStart
{
    if (_audioPlayer &&  !_audioPlayer.playing) {
        [_audioPlayer play];
        return YES;
    }
    
    return NO;
}

- (void)stopPlayer {
    if (_audioPlayer) {
        _audioPlayer.playing ? [_audioPlayer stop] : nil;
        _audioPlayer.delegate = nil;
        _audioPlayer = nil;
        
        self.isPlaying = NO;
    }
}

- (void)stopAudioPlayer {
    if (_audioPlayer) {
        _audioPlayer.playing ? [_audioPlayer stop] : nil;
        _audioPlayer.delegate = nil;
        _audioPlayer = nil;
        
        self.isPlaying = NO;
    }
    
    // 结束回调
    if ([self.delegate respondsToSelector:@selector(didAudioPlayerStopPlay)]) {
        [self.delegate didAudioPlayerStopPlay];
    }
}


#pragma mark - Private Methods

- (NSData *)audioDataFromURLString:(NSString *)URLString identifier:(NSString *)identifier {
    NSData *audioData;
    
    //1.检查URLString是本地文件还是网络文件
    if ([URLString hasPrefix:@"http"] || [URLString hasPrefix:@"https"]) {
        //2.来自网络,先检查本地缓存,缓存key是URLString的MD5编码
        NSString *audioCacheKey = [URLString decodeStringMD5];
        
        //3.本地缓存存在->直接读取本地缓存   不存在->从网络获取数据,并且缓存
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self.cachePath stringByAppendingPathComponent:audioCacheKey]]) {
            audioData = [NSData dataWithContentsOfFile:[self.cachePath stringByAppendingPathComponent:audioCacheKey]];
        } else {
            audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]];
            [audioData writeToFile:[self.cachePath stringByAppendingPathComponent:audioCacheKey] atomically:YES];
        }
    } else {
        audioData = [NSData dataWithContentsOfFile:URLString];
    }
    
    //4.判断audioData是否读取成功,成功则添加对应的audioDataKey
    if (audioData) {
        objc_setAssociatedObject(audioData, &kLCCKAudioDataKey, [[NSString stringWithFormat:@"%@_%@",URLString,identifier] decodeStringMD5], OBJC_ASSOCIATION_COPY);
    }
    
    return audioData;
}

- (void)playAudioWithData:(NSData *)audioData {
    
    self.isPlaying = YES;
    NSString *audioURLMD5String = objc_getAssociatedObject(audioData, &kLCCKAudioDataKey);
    
    if (![[[NSString stringWithFormat:@"%@_%@",self.URLString,self.identifier] decodeStringMD5] isEqualToString:audioURLMD5String]) {
        return;
    }
    
    NSError *audioPlayerError;
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&audioPlayerError];
    if (!_audioPlayer || !audioData) {
        return;
    }
    
    _audioPlayer.volume = 1.0f;
    _audioPlayer.delegate = self;
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
}

- (void)cancelOperation {
    for (NSOperation *operation in self.audioDataOperationQueue.operations) {
        if ([operation.name isEqualToString:[[NSString stringWithFormat:@"%@_%@",self.URLString, self.identifier] decodeStringMD5]]) {
            [operation cancel];
            break;
        }
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    //    //删除近距离事件监听
    //    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    //延迟一秒将audioPlayer 释放
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .2f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self stopAudioPlayer];
    });
    
}

#pragma mark - NSNotificationCenter Methods

- (void)applicationWillResignActive:(UIApplication *)application {
    [self cancelOperation];
}

- (void)proximityStateChanged:(NSNotification *)notification {
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗，以达到省电的目的。
    if ([[UIDevice currentDevice] proximityState] == YES) {

        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
 
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

#pragma mark - Getters

- (NSString *)cachePath {
    if (!_cachePath) {
        _cachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"com.ZXL.chat.audioCache"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_cachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return _cachePath;
}

#pragma mark - Setters

- (void)setURLString:(NSString *)URLString {
    if (_URLString) {
        if (self.isPlaying) {
            //说明当前有正在播放, 或者正在加载的视频,取消 operation(如果没有在执行任务),停止播放
            [self cancelOperation];
            [self stopAudioPlayer];
        }

    }
    _URLString = [URLString copy];
}
@end
