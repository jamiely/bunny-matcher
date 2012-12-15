//
//  ScoresManager.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/15/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "ScoreRecord.h"

const extern NSUInteger SCORE_MANAGER_LIMIT;

@interface ScoresManager : NSObject
// Returns true if the record was added
- (BOOL) addRecord: (ScoreRecord*) record;
- (NSArray*) records;
- (NSUInteger) count;
- (BOOL) isHighScore: (ScoreRecord*) record;
+ (ScoresManager*) sharedInstance;
@end
