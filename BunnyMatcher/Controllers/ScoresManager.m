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
- (BOOL) addRecord: (ScoreRecord*) record {
    NSMutableArray *records = [self.cachedRecords mutableCopy];
    [records addObject: record];
    self.cachedRecords = [records copy];
    return YES;
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
    return [toCache copy];
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
    for(NSInteger i=1; i<SCORE_MANAGER_LIMIT; i++) {
        ScoreRecord *record = [[ScoreRecord alloc] init];
        record.scorer = @"Jamie";
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
