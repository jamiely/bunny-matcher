//
//  ActorMovement.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/30/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "ActorMovement.h"

@implementation ActorMovement

const CGFloat ACTOR_DEFAULT_SPEED = 500.0;

- (id) init {
    self = [super init];
    if(self) {
        self.speed = ACTOR_DEFAULT_SPEED;
    }
    return self;
}

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

- (CGRect) intermediateActorFrameGivenCurrentFrame: (CGRect*) currentFrame
                                     andFinalFrame: (CGRect*) finalFrame {
    
    CGRect intermediateHeroFrame = *finalFrame;
    
    CGPoint finalOrigin = (*finalFrame).origin;
    CGPoint currentOrigin = (*currentFrame).origin;
    
    CGFloat dx = ABS(finalOrigin.x - currentOrigin.x);
    CGFloat dy = ABS(finalOrigin.y - currentOrigin.y);
    
    CGPoint intermediateOrigin = intermediateHeroFrame.origin;
    
    if(dx > dy) {
        // then we want to move in the y direction first
        intermediateOrigin.x = currentOrigin.x;
    }
    else {
        intermediateOrigin.y = currentOrigin.y;
    }
    
    intermediateHeroFrame.origin = intermediateOrigin;
    
    return intermediateHeroFrame;
}

- (void)        moveView: (UIView*) aView
                 toFrame: (CGRect) intermediateHeroFrame
               thenFrame: (CGRect) finalHeroFrame
withNextDestinationBlock: (void(^)(CGPoint nextDestination))nextDestinationBlock
              completion: (void (^)(BOOL))completion  {
    
    NSTimeInterval dur1 = [self durationForAnimationFrom: aView.frame.origin
                                                      to: intermediateHeroFrame.origin];
    NSTimeInterval dur2 = [self durationForAnimationFrom: intermediateHeroFrame.origin
                                                      to: finalHeroFrame.origin];
    [UIView animateWithDuration:dur1 animations:^{
        // We want to move in two parts. First, move in the y direction,
        // straight down.
        if(nextDestinationBlock) {
            nextDestinationBlock(intermediateHeroFrame.origin);
        }
        aView.frame = intermediateHeroFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:dur2 animations:^{
            if(nextDestinationBlock) {
                nextDestinationBlock(finalHeroFrame.origin);
            }
            aView.frame = finalHeroFrame;
        } completion: completion];
    }];
}
- (void) moveView: (UIView*) aView
      toIndexPath: (NSIndexPath*) indexPath
       completion: (void(^)(BOOL finished))completion {
    
    [self       moveView: aView
             toIndexPath: indexPath
withNextDestinationBlock: nil
              completion: completion];
}

- (void)        moveView: (UIView*) aView
             toIndexPath: (NSIndexPath*) indexPath
withNextDestinationBlock: (void(^)(CGPoint nextDestination))nextDestinationBlock
              completion: (void(^)(BOOL finished))completion {
    
    CGRect currentFrame = aView.frame;
    CGRect finalFrame = [self.delegate view: aView locationFromIndexPath: indexPath];
    CGRect intermediateFrame =
        [self intermediateActorFrameGivenCurrentFrame: &currentFrame
                                        andFinalFrame: &finalFrame];
    
    [self       moveView: aView
                 toFrame: intermediateFrame
               thenFrame: finalFrame
withNextDestinationBlock: nextDestinationBlock
              completion: completion];
    
    NSLog(@"Moving view: %@ from: %@ to: %@",
          aView,
          NSStringFromCGRect(currentFrame),
          NSStringFromCGRect(finalFrame));
}

- (NSTimeInterval) durationForAnimationFrom: (CGPoint) a to: (CGPoint) b {
    CGFloat dy = a.y - b.y, dx = a.x - b.x;
    dy = ABS(dy);
    dx = ABS(dx);
    CGFloat blockDistance = dy + dx;
    return blockDistance / self.speed;
}

@end
