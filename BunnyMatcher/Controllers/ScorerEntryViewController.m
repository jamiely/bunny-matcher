//
//  ScorerEntryViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/15/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "ScorerEntryViewController.h"
#import "ScoresManager.h"

@interface ScorerEntryViewController ()

@end

@implementation ScorerEntryViewController

- (void)viewDidAppear:(BOOL)animated {
    [self.scorerField becomeFirstResponder];
    self.scoreLabel.text = [NSString stringWithFormat: @"%06d",
                            self.scoreRecord.score];
}

- (IBAction)onDone:(id)sender {
    self.scoreRecord.scorer = self.scorerField.text;
    if(!self.scoreRecord.scorer) {
        self.scoreRecord.scorer = @"Jane Q";
    }
    ScoresManager *manager = [ScoresManager sharedInstance];
    [manager addRecord: self.scoreRecord];
    [manager saveToDefaults: [NSUserDefaults standardUserDefaults]];
}
@end
