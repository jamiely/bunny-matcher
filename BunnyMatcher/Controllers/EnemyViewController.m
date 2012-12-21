//
//  EnemyViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/8/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "EnemyViewController.h"

@interface EnemyViewController()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation EnemyViewController

- (void) beginEnemyMovement {
    [self endEnemyMovement];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(moveEnemyWithoutDelay) userInfo:nil repeats:YES];
}

- (void) endEnemyMovement {
    if(! self.timer) return;
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void) moveEnemyWithoutDelay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.actorMovement moveView: self.view
                         toIndexPath: [self.delegate nextIndexPathDestination]
                          completion: nil];
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
