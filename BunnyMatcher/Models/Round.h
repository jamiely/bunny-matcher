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

@interface Round : NSObject

- (void) startRoundWithItemCount: (NSUInteger) itemCount;
- (NSUInteger) topicItemCount;
- (NSArray*) topicItems;
- (TopicItem*) topicItemAtIndex: (NSUInteger) index;

- (NSArray*) spots;
- (BoardSpot*) spotAtIndex: (NSUInteger) index;

- (NSString*) nameAtIndex: (NSUInteger) index;

- (BOOL) spotIsConsumedAtIndex: (NSUInteger) index;
- (BOOL) tryToConsumeSpotAtIndex: (NSUInteger) index;

- (BOOL) roundOver;

// score functions

- (NSInteger) scoreEvent: (ScoreEvent) event;

@property (nonatomic, strong) Topic *mainTopic;
@property (nonatomic, strong) Library *library;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, readonly) NSUInteger mainTopicItemsRemaining;
@property (nonatomic, readonly) NSUInteger mainTopicItemCount;

+ (id) roundWithLibrary: (Library*) library andMainTopicName: (NSString*) topicName;

@end
