//
//  ScoresManager.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/15/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "ScoresManager.h"

const NSUInteger SCORE_MANAGER_LIMIT = 10;

@interface ScoresManager()
@property (nonatomic, strong) NSArray *cachedRecords;
@end

@implementation ScoresManager
- (BOOL) isHighScore: (ScoreRecord*) record {
    return self.cachedRecords.count < SCORE_MANAGER_LIMIT ||
        record.score > [self leastScore];
}
- (NSInteger) leastScore {
    NSUInteger count = self.cachedRecords.count;
    if(count == 0) return 0;
    
    ScoreRecord *record = [self.cachedRecords objectAtIndex: count - 1];
    return record.score;
}
- (BOOL) addRecord: (ScoreRecord*) record {
    // assume that the cached records are sorted

    if([self isHighScore: record]) {
        NSMutableArray *records = [self.cachedRecords mutableCopy];
        [records addObject: record];
        NSArray *sortedRecords = [[self class] sortScores: records];
        NSUInteger limit = MIN(SCORE_MANAGER_LIMIT, sortedRecords.count);
        self.cachedRecords =
            [sortedRecords subarrayWithRange: NSMakeRange(0, limit)];
        
        return YES;
    }
    
    return NO;
}
- (NSArray*) records {
    if(!self.cachedRecords) {
        self.cachedRecords =
            [self loadFromDefaults: [NSUserDefaults standardUserDefaults]];
    }

    return self.cachedRecords;
}
- (NSArray*) loadFromDefaults: (NSUserDefaults*) defaults {
    NSArray *highScores = [defaults arrayForKey: [self highScoreKey]];
    NSMutableArray *toCache = [NSMutableArray array];
    for(NSDictionary* scoreDict in highScores) {
        [toCache addObject: [ScoreRecord recordFromDictionary: scoreDict]];
    }

    return [[self class] sortScores: toCache];
}
+ (NSArray*) sortScores: (NSArray*) scores {
    return [scores sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if([obj1 score] == [obj2 score]) return NSOrderedSame;
        return [obj1 score] < [obj2 score] ?
        NSOrderedDescending : NSOrderedAscending;
    }];
}
- (NSString*) highScoreKey {
    static NSString* key = @"high scores";
    return key;
}
- (void) saveToDefaults: (NSUserDefaults*) defaults {
    NSArray *defaultsArray =
        [self defaultsArrayFromRecordsArray: self.cachedRecords];
    [defaults setObject:defaultsArray forKey:[self highScoreKey]];
}
- (NSArray*) defaultsArrayFromRecordsArray: (NSArray*) records {
    NSMutableArray *defaultsArray = [NSMutableArray array];
    for(ScoreRecord *record in records) {
        [defaultsArray addObject: record.dictionary];
    }
    return [defaultsArray copy];
}
- (NSUInteger) count {
    return [[self records] count];
}
- (void) loadPlaceholders {
    static NSArray *names = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        names = [@"James,Thomas,Susan,Kelly,Sharon" componentsSeparatedByString:@","];
    });
    for(NSInteger i=1; i<SCORE_MANAGER_LIMIT; i++) {
        ScoreRecord *record = [[ScoreRecord alloc] init];
        record.scorer = [names objectAtIndex: i % names.count];
        record.score = 500 * i;
        [self addRecord: record];
    }
}
+ (ScoresManager*) sharedInstance {
    static ScoresManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ScoresManager alloc] init];
        [instance loadFromDefaults: [NSUserDefaults standardUserDefaults]];
        if([instance count] == 0) {
            [instance loadPlaceholders];
        }
    });
    return instance;
}
@end
