//
//  Score.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/15/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "ScoreRecord.h"

@implementation ScoreRecord
- (NSDictionary*) dictionary {
    return @{@"scorer" : self.scorer, @"score": @(self.score)};
}
+ (ScoreRecord*) recordFromDictionary:(NSDictionary*)dict{
    ScoreRecord *record = [[ScoreRecord alloc] init];
    NSNumber *scoreNumber = [dict objectForKey: @"score"];
    if(scoreNumber) {
        record.score = scoreNumber.integerValue;
    }
    record.scorer = [dict objectForKey: @"scorer"];
    return record;
}
@end
