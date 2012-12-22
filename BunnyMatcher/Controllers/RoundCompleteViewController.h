//
//  RoundCompleteViewController.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/21/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "Round.h"

@interface RoundCompleteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *earnedScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeFactorLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;
@property (nonatomic, strong) Round* round;

@end
