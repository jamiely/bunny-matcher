//
//  TitleViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/23/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "TitleViewController.h"

@interface TitleViewController()
@property (nonatomic, strong) NSArray *contents;

@end

@implementation TitleViewController

#pragma mark - UIViewController functions

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.contents = @[@"Play", @"Scores", @"Contact"];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
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
            NSLog(@"Contact email");
            break;
        }
            
        default:
            break;
    }
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
    [self dismissViewControllerAnimated:YES completion:^{
        // ?
    }];
}

- (IBAction)showBoard:(UIStoryboardSegue*)segue{
    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier: @"PlaySegue" sender: self];
    }];
}

@end
