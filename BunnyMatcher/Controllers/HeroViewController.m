//
//  HeroViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/8/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "HeroViewController.h"

@interface HeroViewController ()

@end

@implementation HeroViewController

- (id) initWithModel: (Hero*) hero {
    self = [self init];
    if(self) {
        self.hero = hero;
    }
    return self;
}

- (id) initWithModel: (Hero*) hero andView: (HeroView*) view {
    self = [self initWithModel: hero];
    if(self) {
        self.view = view;
    }
    return self;
}

- (void) setHeroLives:(NSUInteger) heroLives {
    self.hero.lives = heroLives;
}

- (NSUInteger) heroLives {
    return self.hero.lives;
}

- (void) startMovement {
    self.hero.isMoving = YES;
}

- (void) stopMovement {
    self.hero.isMoving = NO;
    self.view.frame = [[self.view.layer presentationLayer] frame];
    [self.view.layer removeAllAnimations];
}

- (BOOL) isMoving {
    return self.hero.isMoving;
}

- (BOOL) hasCollided {
    return self.hero.hasCollided;
}

- (void) setHasCollided:(BOOL)hasCollided {
    self.hero.hasCollided = hasCollided;
}

@end
