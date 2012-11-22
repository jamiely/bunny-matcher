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
}

@end

@implementation Round
@synthesize mainTopic;
@synthesize library;

- (id) init {
    self = [super init];
    if(self) {
        _topicItems = @[];
    }
    return self;
}

- (void) startRoundWithItemCount: (NSUInteger) itemCount {
    Scrambler *scrambler = [[Scrambler alloc] initWithMainTopic: self.mainTopic
                                                     andLibrary: self.library];
    _topicItems = [scrambler drawWithCount: itemCount];
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

@end
