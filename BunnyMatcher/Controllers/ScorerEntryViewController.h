//
//  ScorerEntryViewController.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/15/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "ScoreRecord.h"

@interface ScorerEntryViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *scorerField;
@property (nonatomic, strong) ScoreRecord *scoreRecord;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
- (IBAction)onDone:(id)sender;
@end
