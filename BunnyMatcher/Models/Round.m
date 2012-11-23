//
//  Round.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "Round.h"
#import "Scrambler.h"

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

@end
