//
//  AudiController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/13/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "AudioController.h"
#import <CoreFoundation/CoreFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioSession.h>

@interface AudioController()
@property (nonatomic, strong) NSMutableDictionary* soundIds;
@end

@implementation AudioController
- (id) init {
    self = [super init];
    if(self){
        self.soundIds = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void) playWav: (NSString*) file {
    static NSString *ext = @"wav";
    [self playResource: file withExtension: ext];
}

- (void) playResource: (NSString*) file withExtension: (NSString*) ext {
    NSURL *url = [[NSBundle mainBundle] URLForResource:file withExtension:ext];
    [self playURL: url];
}

// http://stackoverflow.com/questions/9791491/best-way-to-play-simple-sound-effect-in-ios
- (void) playURL: (NSURL*) url {
    SystemSoundID audioEffect = [self soundIdForURL: url];
    NSLog(@"Playing audio effect: %ld", audioEffect);
    AudioServicesPlaySystemSound(audioEffect);

    dispatch_async(dispatch_get_main_queue(), ^{
    });
}

- (void)dealloc {
    for(NSString *relUrl in self.soundIds) {
        // call the following function when the sound is no longer used
        // (must be done AFTER the sound is done playing)
        SystemSoundID audioEffect = [[self.soundIds objectForKey: relUrl] integerValue];
        AudioServicesDisposeSystemSoundID(audioEffect);
    }
}

- (SystemSoundID) soundIdForURL: (NSURL*) url {
    NSNumber *effectNumber = [self.soundIds objectForKey: url.absoluteString];
    SystemSoundID audioEffect = 0;
    
    if(effectNumber) {
        audioEffect = [effectNumber unsignedIntegerValue];
    }
    else {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) url, &audioEffect);
        AudioServicesPropertyID flag = 0; // always play
        AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(SystemSoundID), &audioEffect, sizeof(AudioServicesPropertyID), &flag);
        [self.soundIds setObject: @(audioEffect) forKey: url.absoluteString];
    }
    
    return audioEffect;
}

+ (AudioController*) sharedInstance {
    static AudioController* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AudioController alloc] init];
    });
    return instance;
}
@end
