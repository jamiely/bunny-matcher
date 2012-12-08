//
//  Hero.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/8/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "Hero.h"

@implementation Hero

- (id) init {
    self = [super init];
    if(self) {
        self.hasCollided = NO;
        self.isMoving = NO;
        self.lives = 3;
    }
    return self;
}

@end
