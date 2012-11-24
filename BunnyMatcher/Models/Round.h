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

@interface Round : NSObject

- (void) startRoundWithItemCount: (NSUInteger) itemCount;
- (NSUInteger) topicItemCount;
- (NSArray*) topicItems;
- (TopicItem*) topicItemAtIndex: (NSUInteger) index;

- (NSArray*) spots;
- (BoardSpot*) spotAtIndex: (NSUInteger) index;

- (NSString*) nameAtIndex: (NSUInteger) index;

- (void) consumeSpotAtIndex: (NSUInteger) index;
- (BOOL) spotIsConsumedAtIndex: (NSUInteger) index;
- (BOOL) mayConsumeSpotAtIndex: (NSUInteger) index;

@property (nonatomic, strong) Topic *mainTopic;
@property (nonatomic, strong) Library *library;
@property (nonatomic, assign) NSUInteger *score;

@end
