//
//  AVAudioPlayerVC.m
//  HaoYunVideo
//
//  Created by fanhaoyun on 2020/6/28.
//  Copyright © 2020 范浩云. All rights reserved.
//
//用于播放比较长的音频、说明、音乐
//它使用的是AVFoundation框架

//使用步骤
//
//（0）导入AVFoundation框架
//（1）资源文件路径 （为下一步初始化播放器做准备）
//（2）初始化播放器
//（3）设置播放器的各种属性（根据项目需求设置属性）
//（4）预播放
//（5）播放

//1）必须声明全局变量、属性的音乐播放对象 才可以播放
//  2）在退出播放页面的时候一定要把播放对象置空 同时把delegate置空

#import "AVAudioPlayerVC.h"
#import <AVFoundation/AVFoundation.h>


@interface AVAudioPlayerVC ()<AVAudioPlayerDelegate>


@property(nonatomic,strong)AVAudioPlayer * audioPlayer;

@end

@implementation AVAudioPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //声明一个error对象 如果有错误系统会赋值给error
    NSError *error;
    //2、初始化播放器 资源路径直接写在代码里了
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"笔墨稠.mp3" withExtension:nil] error:&error];
    
    
    _audioPlayer.delegate = self;
    //获得当前音乐的声道
    //       NSLog(@"%lu",(unsigned long)audioPlayer.numberOfChannels);
    
    //设置声道 -1.0左 0.0中间 1.0右面
    _audioPlayer.pan = -1.0;
    
    //设置音量 默认是1.0 值在0.0到1.0之间
    _audioPlayer.volume = 1.0;
    
    //获得速率 必须设置enableRate为YES
    _audioPlayer.enableRate = YES;
    //设置速率0.5是一半的速度 1.0普通 2.0 双倍速度
    _audioPlayer.rate =0.5;
    
    //获得峰值必须设置meteringEnabled为YES
    _audioPlayer.meteringEnabled = YES;
    //更新峰值
    [_audioPlayer updateMeters];
    //       获得当前峰值
    NSLog(@"当前峰值：%f",[_audioPlayer peakPowerForChannel:2]);
    //获得平均峰值
    NSLog(@"平均峰值：%f",[_audioPlayer averagePowerForChannel:2]);
    
    //设置播放次数  负数是无限循环 0是一次 1是两次······
    _audioPlayer.numberOfLoops = 1;
    
    //audioPlayer.currentTime可以获得音乐播放的当前时间
    // audioPlayer.duration可以获得音乐播放的总时间
    //如果有错误 打印错误
    if (error) {
        NSLog(@"%@",error);
    }
    //4、预播放
    [_audioPlayer prepareToPlay];
    //5、播放
    [_audioPlayer play];
}




 - (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
 NSLog(@"解码出现错误的时候调用");
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
NSLog(@"被打扰开始中断的时候调用比如突然来电话了");
}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
NSLog(@"中断结束的时候调用");
}





@end
