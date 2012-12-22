//
//  GameAudioController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/21/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "GameAudioController.h"

@implementation GameAudioController
+ (GameAudioController*) sharedInstance {
    static GameAudioController* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GameAudioController alloc] init];
    });
    return instance;
}
- (void) pickup {
    [self playWav: @"Pickup_Coin5"];
}

- (void) badPickup {
    [self playWav: @"Blip_Select3"];
}

- (void) roundComplete {
    [self playWav: @"Powerup9"];
}

- (void) gameOver {
    [self playWav: @"gameover1"];
}

@end
