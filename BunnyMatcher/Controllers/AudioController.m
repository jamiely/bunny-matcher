//
//  AudiController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/13/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "AudioController.h"
#import <CoreFoundation/CoreFoundation.h>

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

// http://stackoverflow.com/questions/9791491/best-way-to-play-simple-sound-effect-in-ios
- (void) playURL: (NSURL*) url {
    SystemSoundID audioEffect = [self soundIdForURL: url];
    AudioServicesPlaySystemSound(audioEffect);
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
