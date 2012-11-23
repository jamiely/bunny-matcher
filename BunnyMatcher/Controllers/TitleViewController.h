//
//  TitleViewController.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/23/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

@interface TitleViewController : UIViewController <UITableViewDataSource,
    UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
