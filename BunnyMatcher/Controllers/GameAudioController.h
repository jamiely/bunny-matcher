//
//  GameAudioController.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/21/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "AudioController.h"

@interface GameAudioController : AudioController
- (void) pickup;
- (void) badPickup;
- (void) roundComplete;
- (void) gameOver;
+ (GameAudioController*) sharedInstance;
@end
