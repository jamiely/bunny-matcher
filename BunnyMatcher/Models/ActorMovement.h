//
//  ActorMovement.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/30/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

@protocol ActorMovementDelegate;

@interface ActorMovement : NSObject
- (CGRect) intermediateActorFrameGivenCurrentFrame: (CGRect*) currentFrame
                                     andFinalFrame: (CGRect*) finalFrame;
- (CGRect) newActorLocationFromFrame: (CGRect) source
                             toFrame: (CGRect) rect;
- (void) moveView: (UIView*) aView
          toFrame: (CGRect) intermediateHeroFrame
        thenFrame: (CGRect) finalHeroFrame
       completion: (void (^)(BOOL))completion;

- (void) moveView: (UIView*) aView
      toIndexPath: (NSIndexPath*) indexPath
       completion: (void(^)(BOOL finished))completion;

@property (nonatomic, strong) id<ActorMovementDelegate> delegate;

@end

@protocol ActorMovementDelegate <NSObject>
- (CGRect) view: (UIView*) aView locationFromIndexPath: (NSIndexPath*) indexPath;
@end