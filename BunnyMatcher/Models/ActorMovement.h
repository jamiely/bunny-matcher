//
//  ActorMovement.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/30/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

@interface ActorMovement : NSObject
- (CGRect) intermediateActorFrameGivenCurrentFrame: (CGRect*) currentFrame
                                     andFinalFrame: (CGRect*) finalFrame;
- (CGRect) newActorLocationFromFrame: (CGRect) source
                             toFrame: (CGRect) rect;
@end
