//
//  EnemyViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/30/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "EnemyViewController.h"

@interface EnemyViewController ()

@end

@implementation EnemyViewController

- (void) moveWithinFrame: (CGRect) boundingBox {
    
    CGRect destinationFrame = self.view.frame;
    destinationFrame.origin.x = arc4random_uniform(boundingBox.size.width);
    destinationFrame.origin.y = arc4random_uniform(boundingBox.size.height);
    
    __weak EnemyViewController *weakSelf = self;
    [UIView animateWithDuration:2.f animations:^{
        weakSelf.view.frame = destinationFrame;
    } completion:^(BOOL finished) {
        // none for now
        NSLog(@"Moved enemy to %@", NSStringFromCGRect(destinationFrame));
    }];
}

@end
