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

- (void) moveView: (UIView*) aView
          toFrame: (CGRect) intermediateHeroFrame
        thenFrame: (CGRect) finalHeroFrame
       completion: (void (^)(BOOL))completion  {
    
    [UIView animateWithDuration:0.5 animations:^{
        // We want to move in two parts. First, move in the y direction,
        // straight down.
        aView.frame = intermediateHeroFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            aView.frame = finalHeroFrame;
        } completion: completion];
    }];
}

- (void) moveView: (UIView*) aView
      toIndexPath: (NSIndexPath*) indexPath
       completion: (void(^)(BOOL finished))completion {
    
    CGRect currentFrame = aView.frame;
    CGRect finalFrame = [self.delegate view: aView locationFromIndexPath: indexPath];
    CGRect intermediateFrame =
        [self intermediateActorFrameGivenCurrentFrame: &currentFrame
                                        andFinalFrame: &finalFrame];
    
    [self moveView: aView
           toFrame: intermediateFrame
         thenFrame: finalFrame
        completion: completion];
    
    NSLog(@"Moving view: %@ from: %@ to: %@",
          aView,
          NSStringFromCGRect(currentFrame),
          NSStringFromCGRect(finalFrame));
}

@end
