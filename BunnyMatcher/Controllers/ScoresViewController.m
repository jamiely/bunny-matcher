//
//  ScoresViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/15/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "ScoresViewController.h"
#import "ScoresManager.h"

@interface ScoresViewController ()
@end

@implementation ScoresViewController
#pragma mark - UITableViewDatasource functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self manager] count];
}
- (UITableViewCell*) tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"StandardCell";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier: cellId];
    ScoreRecord *record = [[[self manager] records] objectAtIndex: indexPath.row];
    cell.textLabel.text = record.scorer;
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%06d", record.score];
    return cell;
}
#pragma mark - Helpers
- (ScoresManager*) manager {
    return [ScoresManager sharedInstance];
}
@end
