//
//  TitleViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/23/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "TitleViewController.h"
#import <MessageUI/MessageUI.h>
#import "BMColor.h"

@interface TitleViewController()
@property (nonatomic, strong) NSArray *contents;

@end

@implementation TitleViewController

#pragma mark - UIViewController functions

- (void) viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *sections = [@[@"Play", @"Scores", @"How to Play"] mutableCopy];
    
    if([MFMailComposeViewController canSendMail]) {
        [sections addObject: @"Contact"];
    }
    
    self.contents = sections;
    self.view.backgroundColor = [BMColor grassColor];
    self.tableView.backgroundView = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    [self.heroView showStandingAnimation];
    [self.enemyView showStandingAnimation];
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self startAnimation];
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.heroView.layer removeAllAnimations];
    [self.enemyView.layer removeAllAnimations];
    [self.view.layer removeAllAnimations];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark - Animation functions

- (void) showRunAnimation {
    [self.heroView showRunAnimation];
    [self.enemyView showRunAnimation];
}

- (void) faceLeft {
    [self.heroView faceLeft];
    [self.enemyView faceLeft];
}

- (void) faceRight {
    [self.heroView faceRight];
    [self.enemyView faceRight];
}

- (void) characterYAdjustment: (CGFloat) yAdjust {
    CGRect heroFrame = self.heroView.frame;
    CGRect enemyFrame = self.enemyView.frame;
    
    heroFrame.origin.y = yAdjust;
    enemyFrame.origin.y = yAdjust + arc4random_uniform(100) - 100;
    
    self.heroView.frame = heroFrame;
    self.enemyView.frame = enemyFrame;
}

- (void) runLeft: (NSTimeInterval) duration {
    [self faceLeft];
    [UIView animateWithDuration:duration animations:^{
        // animate off to the right
        CGRect heroFrame = self.heroView.frame;
        heroFrame.origin.x = heroFrame.size.width - 2500;
        
        CGRect enemyFrame = self.enemyView.frame;
        enemyFrame.origin.x = enemyFrame.size.width - 2000;
        
        self.heroView.frame = heroFrame;
        self.enemyView.frame = enemyFrame;
    } completion:^(BOOL finished) {
        if(finished){
            [self characterYAdjustment: arc4random_uniform( self.view.frame.size.height )];
            [self runRight];
        }
    }];
}

- (void) runRight {
    [self faceRight];
    [UIView animateWithDuration:7.0 animations:^{
        // run right
        CGRect heroFrame = self.heroView.frame;
        heroFrame.origin.x = heroFrame.size.width + 2500;
        
        CGRect enemyFrame = self.enemyView.frame;
        enemyFrame.origin.x = enemyFrame.size.width + 2000 + arc4random_uniform(500);
        
        self.heroView.frame = heroFrame;
        self.enemyView.frame = enemyFrame;
    } completion:^(BOOL finished) {
        if(finished) {
            [self runLeft: 10.0];
        }
    }];
}

- (void) startAnimation {
    [self showRunAnimation];
    [self runLeft: 2.0];
}

#pragma mark - UITableViewDataSource functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    return self.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [aTableView dequeueReusableCellWithIdentifier: @"StandardCell"];
    cell.textLabel.text = [self.contents objectAtIndex: indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate functions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            [self performSegueWithIdentifier: @"PlaySegue" sender: self];
            break;
        }
            
        case 1: {
            [self scoresSegue];
            break;
        }
            
        case 2: {
            [self performSegueWithIdentifier: @"InstructionsSegue" sender: self];
            break;
        }
            
        case 3: {
            [self contact];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Contact functions

- (void) contact {
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    [controller setToRecipients: @[@"bunnymatcher@angelforge.org"]];
    [controller setSubject: @"[BunnyMatcher] Bug/Feature Request"];
    NSError *error;
    NSString *filename = [[NSBundle mainBundle] pathForResource: @"contact" ofType:@"txt"];
    NSString *bodyContent = [NSString stringWithContentsOfFile: filename encoding:NSUTF8StringEncoding error: &error];
    [controller setMessageBody: bodyContent isHTML: NO];
    controller.mailComposeDelegate = self;
    [self presentViewController: controller animated: YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Segue functions

- (void) scoresSegue {
    [self performSegueWithIdentifier: @"ScoresSegue" sender: self];
}

- (IBAction)showHighScores:(UIStoryboardSegue*)segue {
    [self dismissViewControllerAnimated:YES completion:^{
        [self scoresSegue];
    }];
}

- (IBAction)showTitleScreen:(UIStoryboardSegue*)segue {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showBoard:(UIStoryboardSegue*)segue{
    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier: @"PlaySegue" sender: self];
    }];
}

@end
