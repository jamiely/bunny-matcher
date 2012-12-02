//
//  LivesView.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/1/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "LivesView.h"

#define LIVESVIEW_VALUE_TAG 1

@interface LivesView()
@property (nonatomic, readonly) UILabel* livesValueLabel;
@end

@implementation LivesView

@synthesize lives;
@synthesize livesValueLabel;

- (void)setLives:(NSUInteger)aLives {
    lives = aLives;
    self.livesValueLabel.text = [NSString stringWithFormat: @"%d", aLives];
    NSLog(@"Lives set to %d", self.lives);
}

#pragma mark - View Helpers

- (UILabel *)livesValueLabel {
    return (UILabel*)[self viewWithTag: LIVESVIEW_VALUE_TAG];
}

@end
