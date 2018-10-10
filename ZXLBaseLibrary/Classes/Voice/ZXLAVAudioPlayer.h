//
//  ZXLAVAudioPlayer.h
//  ZXZ
//
//  Created by xyt on 16/12/16.
//  Copyright © 2016年 ZXL. All rights reserved.
//
//  提供一个可以播放本地,网路MP3等格式的播放控制
//  网络音频统一缓存在documents/com.ZXL.chat.audioCache目录下
//  播放流程
//  传入URLString,index->检测是否有正在加载,正在播放的音频(停止加载,停止播放)->检查URLString是本地还是网络路径(网络路径下载到本地,并且缓存到本地目录下)->开始播放加载到的audioData->播放结束

#import <Foundation/Foundation.h>

@protocol ZXLAVAudioPlayerDelegate <NSObject>
- (void)didAudioPlayerStopPlay;
@end

@interface ZXLAVAudioPlayer : NSObject

@property (nonatomic, copy) NSString *URLString;

@property (weak, nonatomic) id<ZXLAVAudioPlayerDelegate> delegate;
/**
 *  identifier -> 主要作用是提供记录,用来控制对应的tableViewCell的状态
 */
@property (nonatomic, copy) NSString *identifier;

+ (instancetype)sharePlayer;

- (void)playAudioWithURLString:(NSString *)URLString identifier:(NSString *)identifier;

// 停止播放
- (void)stopPlayer;
- (void)stopAudioPlayer;

- (void)cleanAudioCache;

-(void)pausePlayer;
-(BOOL)pausePlayerStart;

@end
