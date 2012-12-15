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
@property (nonatomic, strong) NSMutableDictionary* players;
@end

@implementation AudioController
- (id) init {
    self = [super init];
    if(self){
        self.soundIds = [NSMutableDictionary dictionary];
        self.players = [NSMutableDictionary dictionary];
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback
                                               error: nil];
        UInt32 category = kAudioSessionCategory_PlayAndRecord;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                                sizeof(category), &category);
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
    //AudioServicesPlaySystemSound(audioEffect);
    AudioServicesPlayAlertSound(audioEffect);
    NSLog(@"Played sound: %ld", audioEffect);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, (unsigned long)NULL), ^{
        [[self playerForURL: url] play];
        NSLog(@"Playing url: %@", url);
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

- (AVAudioPlayer*) playerForURL: (NSURL*) url {
    AVAudioPlayer *player = [self.players objectForKey: url];
    if(! player) {
        NSError *error;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL: url
                                                        error: &error];
        if(error) {
            NSLog(@"Problem creating player. %@", error);
            player = nil;
        }
        else {
            player.numberOfLoops = -1;
            [self.players setObject: player forKey: url];
        }
    }
    return player;
}

- (SystemSoundID) soundIdForURL: (NSURL*) url {
    NSNumber *effectNumber = [self.soundIds objectForKey: url.relativeString];
    SystemSoundID audioEffect;
    
    if(effectNumber) {
        audioEffect = [effectNumber integerValue];
    }
    else {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) url, &audioEffect);
        [self.soundIds setObject: @(audioEffect) forKey: url.description];
    }
    
    return audioEffect;
}

+ (AudioController*) sharedInstance {
    return [[AudioController alloc] init];
}
@end
