//
//  HeroViewController.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/8/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hero.h"
#import "HeroView.h"

@interface HeroViewController : UIViewController
- (id) initWithModel: (Hero*) hero;

- (void) startMovement;
- (void) stopMovement;
- (BOOL) isMoving;
- (BOOL) hasCollided;

- (void) collide;
- (void) reboundFromPoint: (CGPoint) point;
- (void) resetCollision;

// A convenience method to return the frame corresponding to the presentation CALayer frame
- (CGRect) presentationFrame;
- (BOOL) collidesWithRect: (CGRect) rect;

- (void) resetLives;

@property (nonatomic, assign) NSUInteger heroLives;

@end
