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
-(void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL hasHighScore = [self hasHighScore];
    NSString *buttonTitle = hasHighScore ? @"Enter name" : @"Play again";
    [self.nextButton setTitle: buttonTitle forState: UIControlStateNormal];
    
    self.titleScreenButton.hidden = hasHighScore;
}
- (BOOL) hasHighScore {
    return [[ScoresManager sharedInstance] isHighScore: self.scoreRecord];
}
- (IBAction)nextButtonClick:(id)sender {
    NSString *segueId = [self hasHighScore] ?
        @"ScorerEntrySegue" : @"PlayAgainSegue";
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
