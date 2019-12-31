//
//  CKAudioPlayer.m
//  Drivingvoices
//
//  Created by ChenShuKun on 2019/8/2.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import "CKAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@implementation CKAudioPlayer {
    AVAudioSession* _audioSession;
}

-(instancetype)init{
    
    if (self = [super init]) {
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        _audioSession = [AVAudioSession sharedInstance];
        [_audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        [_audioSession setActive:YES error:nil];
    }
    return self;
}

static AVAudioPlayer* staticAudioPlayer;

+ (instancetype)sharedInstance{
    static CKAudioPlayer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)playWithAudioName:(NSString *)name {
    
    NSURL* url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"mp3"]];
    
    if(!staticAudioPlayer){
        staticAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [staticAudioPlayer prepareToPlay];
    }
    if ([staticAudioPlayer isPlaying]) {
        [self stopPlay];
    }
    [staticAudioPlayer play];
}

- (BOOL)isPlaying {
    return [staticAudioPlayer isPlaying];
}
-(void)stopPlay {
    staticAudioPlayer.currentTime = 0;
    [staticAudioPlayer stop];
}

@end
