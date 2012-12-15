//
//  ScorerEntryViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/15/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "ScorerEntryViewController.h"

@interface ScorerEntryViewController ()

@end

@implementation ScorerEntryViewController

- (void)viewDidAppear:(BOOL)animated {
    [self.scorerField becomeFirstResponder];
    self.scoreLabel.text = [NSString stringWithFormat: @"%06d",
                            self.scoreRecord.score];
}

@end
