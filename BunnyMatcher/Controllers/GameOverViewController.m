//
//  GameOverViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/15/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "GameOverViewController.h"
#import "ScoresManager.h"

@implementation GameOverViewController
- (void)viewDidAppear:(BOOL)animated {
    self.nextButton.titleLabel.text = [self hasHighScore] ?
        @"Enter name" : @"Play again";
}
- (BOOL) hasHighScore {
    return YES;
    return [[ScoresManager sharedInstance] isHighScore: self.scoreRecord];
}
- (IBAction)nextButtonClick:(id)sender {
    NSString *segueId = [self hasHighScore] ? @"ScorerEntrySegue" : @"PlayAgainSegue";
    [self performSegueWithIdentifier: segueId sender: self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *controller = segue.destinationViewController;
    if([controller respondsToSelector: @selector(setScoreRecord:)]) {
        [controller performSelector:@selector(setScoreRecord:)
                         withObject:self.scoreRecord];
    }
}
@end
