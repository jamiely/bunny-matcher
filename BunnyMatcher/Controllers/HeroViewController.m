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

- (void) collide {
    if(self.hero.state == HeroStateStunned) return;
    
    [self.hero collide];
    self.view.alpha = 0.5;
    self.heroLives --;
    [self stopMovement];
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:1.0 animations:^{
            self.view.alpha = 1;
        } completion:^(BOOL finished) {
            [self.hero recover];
        }];
    });
}

- (void) resetCollision {
    [self.hero resetCollide];
}

- (CGRect) presentationFrame {
    return [[self.view.layer presentationLayer] frame];
}

- (BOOL) collidesWithRect: (CGRect) rect {
    return CGRectIntersectsRect(self.presentationFrame, rect);
}

- (void) resetLives {
    self.heroLives = HERO_LIVES_DEFAULT;
}
@end
