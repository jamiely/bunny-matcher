//
//  ActorMovement.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/30/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

@protocol ActorMovementDelegate;

extern const CGFloat ACTOR_DEFAULT_SPEED;

@interface ActorMovement : NSObject
- (CGRect) intermediateActorFrameGivenCurrentFrame: (CGRect*) currentFrame
                                     andFinalFrame: (CGRect*) finalFrame;
- (CGRect) newActorLocationFromFrame: (CGRect) source
                             toFrame: (CGRect) rect;

- (void) moveView: (UIView*) aView
      toIndexPath: (NSIndexPath*) indexPath
       completion: (void(^)(BOOL finished))completion;

- (BOOL) willMoveView: (UIView*) aView leftToIndexPath: (NSIndexPath*) ip;
    
@property (nonatomic, strong) id<ActorMovementDelegate> delegate;
@property (nonatomic, assign) CGFloat speed;
@end

@protocol ActorMovementDelegate <NSObject>
- (CGRect) view: (UIView*) aView locationFromIndexPath: (NSIndexPath*) indexPath;
@end