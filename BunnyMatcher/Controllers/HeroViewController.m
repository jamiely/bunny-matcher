//
//  HeroViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/8/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "HeroViewController.h"

@interface HeroViewController()
@property (nonatomic, strong) Hero* hero;
@end

@implementation HeroViewController

@synthesize view;

- (id) initWithModel: (Hero*) hero {
    self = [self init];
    if(self) {
        self.hero = hero;
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

- (void) collide {
    self.hasCollided = YES;
    self.heroLives --;
    [self stopMovement];
}

- (void) resetCollision {
    self.hasCollided = NO;
}

@end
