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

@interface Round() {
    NSArray *_topicItems;
    NSArray *_spots;
}

@end

@implementation Round
@synthesize mainTopic;
@synthesize library;
@synthesize score;

- (id) init {
    self = [super init];
    if(self) {
        _topicItems = @[];
        _spots = @[];
        self.score = 0;
    }
    return self;
}

- (void) startRoundWithItemCount: (NSUInteger) itemCount {
    Scrambler *scrambler = [[Scrambler alloc] initWithMainTopic: self.mainTopic
                                                     andLibrary: self.library];
    _topicItems = [scrambler drawWithCount: itemCount];
    
    NSMutableArray *spots = [NSMutableArray arrayWithCapacity: _topicItems.count];
    for(TopicItem* topicItem in _topicItems) {
        [spots addObject: [BoardSpot spotWithItem: topicItem]];
    }
    _spots = [spots copy];
}

- (NSUInteger) topicItemCount {
    return _topicItems.count;
}
- (NSArray*) topicItems {
    return _topicItems;
}

- (TopicItem*) topicItemAtIndex: (NSUInteger) index {
    return [_topicItems objectAtIndex: index];
}

- (NSArray*) spots {
    return _spots;
}
- (BoardSpot*) spotAtIndex: (NSUInteger) index {
    return [_spots objectAtIndex: index];
}

- (NSString*) nameAtIndex: (NSUInteger) index {
    return [[self spotAtIndex: index] name];
}

- (void) consumeSpotAtIndex: (NSUInteger) index {
    BoardSpot *spot = [self spotAtIndex: index];
    if(spot && !spot.consumed) {
        spot.consumed = YES;
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
@end
