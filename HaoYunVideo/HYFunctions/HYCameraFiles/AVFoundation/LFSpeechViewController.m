//
//  LFSpeechViewController.m
//  HaoYunVideo
//
//  Created by fanhaoyun on 2020/6/17.
//  Copyright © 2020 范浩云. All rights reserved.
//

#import "LFSpeechViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LFSpeechViewController ()

//执行具体的“文本到语音”回话。对于一个或多个AVSpeechUtterance实例，
//该对象起到队列的作用，提供了接口供控制和见识正在进行的语音播放。
@property (nonatomic,strong) AVSpeechSynthesizer *synthesizer;

@property (nonatomic,strong) NSArray *voicesArray;

@property (nonatomic,strong) NSArray *speechStringsArray;

@end

@implementation LFSpeechViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer  * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}


-(void)tapGesture:(UITapGestureRecognizer *)tap
{
    _synthesizer = [[AVSpeechSynthesizer alloc] init];
    _voicesArray = @[[AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"],[AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"],];
    _speechStringsArray = [self buildSpeechStrings];
    NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
}


- (void)beginConversation {
    for (int i = 0; i < self.speechStringsArray.count; i++) {
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:self.speechStringsArray[i]];
        utterance.voice = self.voicesArray[i%2];//语音
        utterance.rate = 0.4f;
        //播放语音内容的速率，默认值AVSpeechUtteranceDefaultSpeechRate=0.5。
        //这个值介于AVSpeechUtteranceMinimumSpeechRate和AVSpeechUtteranceMaximumSpeechRate之间(目前是0.0-1.0)
        //这两个值是常量，在以后iOS版本中可能会发生变化，可以按照最小值和最大值的范围百分比进行计算。
        NSLog(@"min:%f-max:%f-default:%f",AVSpeechUtteranceMinimumSpeechRate,AVSpeechUtteranceMaximumSpeechRate,AVSpeechUtteranceDefaultSpeechRate);
        utterance.pitchMultiplier = 0.8f; //在播放特定语句是改变声音的音调，允许值介于0.5-2.0之间。
        utterance.postUtteranceDelay = 0.1f; //语音合成器在播放下一语句之前有段时间的暂停。
        [self.synthesizer speakUtterance:utterance];
    }
}

- (NSArray *)buildSpeechStrings {
    return  @[@"Hello,How are you ?",
              @"I'm fine ,Thank you. And you ?",
              @"I'm fine too.",
              @"人之初，性本善。性相近，习相远。苟不教，性乃迁。教之道，贵以专。昔孟母，择邻处。子不学，断机杼。窦燕山，有义方。教五子，名俱扬。养不教，父之过。教不严，师之惰。子不学，非所宜。幼不学，老何为。玉不琢，不成器。人不学，不知义。为人子，方少时。亲师友，习礼仪。香九龄，能温席。孝于亲，所当执。融四岁，能让梨。弟于长，宜先知。",
             ];
}

@end
