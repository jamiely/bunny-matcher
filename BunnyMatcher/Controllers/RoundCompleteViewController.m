//
//  RoundCompleteViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/21/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "RoundCompleteViewController.h"

@implementation RoundCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.round) return;
    
    self.earnedScoreLabel.text = [NSString stringWithFormat: @"%d", self.round.score];
    self.timeFactorLabel.text = [NSString stringWithFormat: @"%d", self.round.scoreTimeFactor];
    self.totalScoreLabel.text = [NSString stringWithFormat: @"%d", self.round.totalScore];
}

@end
