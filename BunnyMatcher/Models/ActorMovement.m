//
//  ActorMovement.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/30/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "ActorMovement.h"

@implementation ActorMovement

- (CGRect) newActorLocationFromFrame: (CGRect) source
                             toFrame: (CGRect) rect {
    // calculate the cell center
    CGPoint destination = rect.origin;
    destination.x += rect.size.width / 2.f;
    destination.y += rect.size.height / 2.f;
    
    CGRect newHeroLocation = source;
    destination.x -= newHeroLocation.size.width / 2.f;
    destination.y -= newHeroLocation.size.height / 2.f;
    newHeroLocation.origin = destination;
    
    return newHeroLocation;
}

@end
