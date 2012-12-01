//
//  ActorMovement.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/30/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

@interface ActorMovement : NSObject
- (CGRect) newActorLocationFromFrame: (CGRect) source
                             toFrame: (CGRect) rect;
@end
