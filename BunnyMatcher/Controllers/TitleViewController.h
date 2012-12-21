//
//  TitleViewController.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/23/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//
#import <MessageUI/MessageUI.h>

@interface TitleViewController : UIViewController <UITableViewDataSource,
    UITableViewDelegate, MFMailComposeViewControllerDelegate>
- (IBAction)showHighScores:(UIStoryboardSegue*)segue;
- (IBAction)showTitleScreen:(UIStoryboardSegue*)segue;
- (IBAction)showBoard:(UIStoryboardSegue*)segue;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
