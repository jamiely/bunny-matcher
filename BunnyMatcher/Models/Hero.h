//
//  Hero.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/8/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <Foundation/Foundation.h>

const extern NSUInteger HERO_LIVES_DEFAULT;

typedef enum {
    HeroStateNormal,
    HeroStateStunned
} HeroState;

@interface Hero : NSObject

- (void) collide;
- (void) recover;
- (void) resetCollide;

@property (nonatomic, assign) HeroState state;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, readonly) BOOL hasCollided;
@property (nonatomic, assign) NSUInteger lives;

@end
