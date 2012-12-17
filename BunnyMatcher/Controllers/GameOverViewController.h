//
//  GameOverViewController.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/15/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScoreRecord;

@interface GameOverViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *titleScreenButton;
@property (nonatomic, strong) ScoreRecord *scoreRecord;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextButtonClick:(id)sender;
@end
