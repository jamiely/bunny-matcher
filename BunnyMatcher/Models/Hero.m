//
//  Hero.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/8/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "Hero.h"

const NSUInteger HERO_LIVES_DEFAULT = 3;

@interface Hero()
@property (nonatomic, assign) BOOL hasCollided;
@end

@implementation Hero

- (id) init {
    self = [super init];
    if(self) {
        self.hasCollided = NO;
        self.isMoving = NO;
        self.lives = HERO_LIVES_DEFAULT;
        self.state = HeroStateNormal;
    }
    return self;
}

- (void) collide {
    self.hasCollided = YES;
    self.state = HeroStateStunned;
}

- (void) recover {
    self.state = HeroStateNormal;
}

- (void) resetCollide {
    self.hasCollided = NO;
}

@end
