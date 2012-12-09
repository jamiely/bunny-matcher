//
//  Round.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "Round.h"
#import "Scrambler.h"

const NSInteger ROUND_SCORE_POINT = 100;
const NSInteger ROUND_SCORE_PENALTY = -50;
const NSInteger ROUND_SCORE_CAPTURED = -100;

@interface Round()
@property (nonatomic, strong) NSArray *topicItems;
@property (nonatomic, strong) NSArray *spots;
@property (nonatomic, assign) NSUInteger mainTopicItemsRemaining;
@property (nonatomic, assign) NSUInteger mainTopicItemCount;
@property (nonatomic, assign) NSInteger score;
@end

@implementation Round

- (id) init {
    self = [super init];
    if(self) {
        self.topicItems = @[];
        self.spots = @[];
        self.score = 0;
        self.mainTopicItemsRemaining = 0;
        self.mainTopicItemCount = 0;
    }
    return self;
}

- (void) startRoundWithItemCount: (NSUInteger) itemCount {
    Scrambler *scrambler = [[Scrambler alloc] initWithMainTopic: self.mainTopic
                                                     andLibrary: self.library];
    self.topicItems = [scrambler drawScrambledWithCount: itemCount];
    
    NSMutableArray *spots = [NSMutableArray arrayWithCapacity: self.topicItems.count];
    for(TopicItem* topicItem in self.topicItems) {
        [spots addObject: [BoardSpot spotWithItem: topicItem]];
    }
    self.spots = [spots copy];
    
    self.mainTopicItemCount = scrambler.drawnNumberOfMainTopicItems;
    self.mainTopicItemsRemaining = self.mainTopicItemCount;
}

- (NSUInteger) topicItemCount {
    return self.topicItems.count;
}

- (TopicItem*) topicItemAtIndex: (NSUInteger) index {
    return [self.topicItems objectAtIndex: index];
}

- (BoardSpot*) spotAtIndex: (NSUInteger) index {
    return [self.spots objectAtIndex: index];
}

- (NSString*) nameAtIndex: (NSUInteger) index {
    return [[self spotAtIndex: index] name];
}

- (void) consumeSpotAtIndex: (NSUInteger) index {
    BoardSpot *spot = [self spotAtIndex: index];
    if(spot && !spot.consumed) {
        spot.consumed = YES;
        self.mainTopicItemsRemaining --;
        NSLog(@"Main topic items remaining: %d", self.mainTopicItemsRemaining);
    }
}
- (BOOL) spotIsConsumedAtIndex: (NSUInteger) index {
    return [self spotAtIndex: index].consumed;
}
- (BOOL) mayConsumeSpotAtIndex: (NSUInteger) index {
    BoardSpot *spot = [self spotAtIndex: index];
    if(spot.consumed) {
        return NO;
    }
    
    return [self.mainTopic hasItem: spot.item];
}

- (BOOL) tryToConsumeSpotAtIndex: (NSUInteger) index {
    if([self mayConsumeSpotAtIndex: index]) {
        [self consumeSpotAtIndex: index];
        [self scoreEvent: CorrectTerm];
        return YES;
    }
    else {
        [self scoreEvent: IncorrectTerm];
        return NO;
    }

}

- (BOOL) roundOver {
    return self.mainTopicItemsRemaining == 0;
}

- (NSInteger) scoreEvent: (ScoreEvent) event {
    NSInteger scoreDelta = 0;
    switch(event) {
        case CorrectTerm: {
            scoreDelta = ROUND_SCORE_POINT;
            break;
        }
        case IncorrectTerm: {
            scoreDelta = ROUND_SCORE_PENALTY;
            break;
        }
        case Captured: {
            scoreDelta = ROUND_SCORE_CAPTURED;
            break;
        }
    }
    self.score += scoreDelta;
    return self.score;
}

- (Topic*) nextTopic {
    return [self.library topicAfter: self.mainTopic];
}

- (Round*) nextRound {
    Round *next = [[Round alloc] init];
    next.library = self.library;
    next.mainTopic = [self nextTopic];
    next.score = self.score;
    return next;
}

+ (id) roundWithLibrary: (Library*) library andMainTopicName: (NSString*) topicName {
    Round *round = [[Round alloc] init];
    round.library = library;
    round.mainTopic = [library topicWithName: topicName];
    return round;
}
@end
