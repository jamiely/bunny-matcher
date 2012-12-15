//
//  ScoresViewController.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/15/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoresViewController : UIViewController <UITableViewDataSource,
    UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
