//
//  HeroViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/8/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "HeroViewController.h"
#import "AudioController.h"

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
    [[self heroView] showRunAnimation];
}

- (void) stopMovement {
    self.hero.isMoving = NO;
    self.view.frame = [[self.view.layer presentationLayer] frame];
    [self.view.layer removeAllAnimations];
    [[self heroView] showStandingAnimation];
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
    [self playSoundHit];
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

- (void) playSoundHit {
    [[AudioController sharedInstance] playWav: @"Hit_Hurt10"];
}


- (void) resetCollision {
    [self.hero resetCollide];
}

- (CGRect) presentationFrame {
    return [[self.view.layer presentationLayer] frame];
}

- (CGPoint) presentationOrigin {
    return [self presentationFrame].origin;
}

- (BOOL) collidesWithRect: (CGRect) rect {
    return CGRectIntersectsRect(self.presentationFrame, rect);
}

- (void) resetLives {
    self.heroLives = HERO_LIVES_DEFAULT;
}

- (void) reboundFromPoint: (CGPoint) point {
    CGPoint hero = [self presentationOrigin];
    CGPoint newPoint = CGPointMake(point.x - hero.x, point.y - hero.y);
    static CGFloat reboundFactor = -1.2;
    newPoint.x *= reboundFactor;
    newPoint.y *= reboundFactor;
    hero.x += newPoint.x;
    hero.y += newPoint.y;
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin = hero;
    self.view.frame = viewFrame;
}

- (HeroView*) heroView {
    return (HeroView*) self.view;
}

- (void) faceIndexPath: (NSIndexPath*) ip {
    if([self.actorMovement willMoveView: self.heroView
                        leftToIndexPath:ip]) {
        [[self heroView] faceLeft];
    }
    else {
        [[self heroView] faceRight];
    }
    
}

- (void) moveToIndexPath: (NSIndexPath*) indexPath
              completion: (void (^)(NSIndexPath*)) completion {
    [self startMovement];
    [self faceIndexPath: indexPath];
    
    [self.actorMovement moveView: self.heroView
                     toIndexPath: indexPath
                      completion:^(BOOL finished) {
                          [self stopMovement];
                          if(! finished) return;
                          
                          if(completion) {
                              completion(indexPath);
                          }
                      }];
}

@end
