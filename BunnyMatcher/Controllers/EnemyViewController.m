//
//  EnemyViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/8/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "EnemyViewController.h"

@implementation EnemyViewController

- (id) init {
    self = [super init];
    if(self) {
        self.mayMove = YES;
    }
    return self;
}

- (void) beginEnemyMovement {
    self.mayMove = YES;
    [self moveEnemyRecursivelyWithIntervalInSeconds: 5.0];
}

// arguably, this should be done as part of the game loop
- (void) moveEnemyRecursivelyWithIntervalInSeconds: (CGFloat) intervalInSeconds {
    if(!self.mayMove) return;
    
    [self moveEnemyAfterDelayInSeconds: intervalInSeconds completion:^(BOOL finish){
        [self moveEnemyRecursivelyWithIntervalInSeconds: intervalInSeconds];
    }];
}

- (void) moveEnemyAfterDelayInSeconds: (CGFloat) delayInSeconds
                           completion: (void (^)(BOOL finish)) completion {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.actorMovement moveView: self.view
                         toIndexPath: [self.delegate nextIndexPathDestination]
                          completion: completion];
    });
}

- (void) collide {
    self.view.frame = [[self.view.layer presentationLayer] frame];
    [self.view.layer removeAllAnimations];
}

- (CGRect) presentationFrame {
    return [[self.view.layer presentationLayer] frame];
}

- (CGPoint)presentationOrigin {
    return [self presentationFrame].origin;
}

@end
