//
//  CSServiceUtils.m
//  UtilTestDemo
//
//  Created by yangweichao on 2022/2/17.
//

#import "CSServiceUtils.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation CSServiceUtils
{
    SystemSoundID sound;
}


- (void)startAlertVibrateAndSound{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Alert" ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &sound);

    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, vibrationCompleteCallback, NULL);
    AudioServicesAddSystemSoundCompletion(sound, NULL, NULL, soundCompleteCallback, NULL);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//开始震动
    AudioServicesPlaySystemSound(sound);//开始播放铃声
}

- (void)stopAlertVibrateAndSound {
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    AudioServicesRemoveSystemSoundCompletion(sound);
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesDisposeSystemSoundID(sound);
}


void vibrationCompleteCallback(SystemSoundID sound,void * clientData) {
    // 持续振动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

void soundCompleteCallback(SystemSoundID sound,void * clientData) {
    // 持续响铃
    AudioServicesPlaySystemSound(sound);
}

@end
