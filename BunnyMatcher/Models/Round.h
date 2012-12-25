//
//  Round.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "Topic.h"
#import "Library.h"
#import "BoardSpot.h"

typedef enum {
    CorrectTerm,
    IncorrectTerm,
    Captured
} ScoreEvent;

const extern NSTimeInterval ROUND_DEFAULT_TIME;

@interface Round : NSObject

- (void) startRoundWithItemCount: (NSUInteger) itemCount;
- (NSUInteger) topicItemCount;
- (NSArray*) topicItems;
- (TopicItem*) topicItemAtIndex: (NSUInteger) index;

- (BoardSpot*) spotAtIndex: (NSUInteger) index;

- (NSString*) nameAtIndex: (NSUInteger) index;

- (BOOL) spotIsConsumedAtIndex: (NSUInteger) index;
- (BOOL) tryToConsumeSpotAtIndex: (NSUInteger) index;

- (BOOL) roundOver;

- (NSInteger) scoreEvent: (ScoreEvent) event;
- (BOOL) isMainTopicItemAtIndex: (NSUInteger) index;

// Creates a new round based on the current round, passing along library information
// and selecting the next topic. The score is also passed to the next round.
- (Round*) nextRound;
- (NSInteger) scoreTimeFactor;
- (NSInteger) totalScore;
    
@property (nonatomic, assign) NSTimeInterval timeRemaining;
@property (nonatomic, strong) Topic *mainTopic;
@property (nonatomic, strong) Library *library;
@property (nonatomic, readonly) NSArray *spots;
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSUInteger mainTopicItemsRemaining;
@property (nonatomic, readonly) NSUInteger mainTopicItemCount;

+ (id) roundWithLibrary: (Library*) library andMainTopicName: (NSString*) topicName;

@end
