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
- (id) initWithModel: (Hero*) hero andView: (HeroView*) view;

- (void) startMovement;
- (void) stopMovement;
- (BOOL) isMoving;
- (BOOL) hasCollided;

- (void) collide;
- (void) resetCollision;

@property (nonatomic, assign) NSUInteger heroLives;

@end
