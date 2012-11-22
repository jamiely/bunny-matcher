//
//  Scrambler.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "Scrambler.h"
#import "TopicCollection.h"

const NSUInteger SCRAMBLER_PREFERRED_NUM_MAIN_TOPIC_ITEMS = 7;

@implementation Scrambler

@synthesize preferredNumberOfMainTopicItems;
@synthesize preferredTopics;
@synthesize library;

- (id) init {
    self = [super init];
    if(self) {
        self.preferredTopics = [NSMutableSet set];
        self.preferredNumberOfMainTopicItems = SCRAMBLER_PREFERRED_NUM_MAIN_TOPIC_ITEMS;
    }
    return self;
}

- (id) initWithMainTopic: (Topic*) aMainTopic andLibrary: (Library*) aLibrary {
    self = [self init];
    if(self) {
        self.mainTopic = aMainTopic;
        self.library = aLibrary;
    }
    return self;
}

// these topics will be used before other topics
- (void) addPreferredTopic: (Topic*) aTopic {
    [self.preferredTopics addObject: aTopic];
}

- (NSArray*) allPreferredTopics {
    return [self.preferredTopics allObjects];
}

// returns a list of topic items
- (NSArray*) drawWithCount: (NSUInteger) itemCount {
    NSMutableArray *drawnItems = [NSMutableArray arrayWithCapacity: itemCount];
    [drawnItems addObjectsFromArray: [self atMost: self.preferredNumberOfMainTopicItems
                                  itemsFromTopics: @[self.mainTopic]]];
    
    if(drawnItems.count >= itemCount) return drawnItems;
    
    NSUInteger remainder = itemCount - drawnItems.count;
    [drawnItems addObjectsFromArray: [self atMost: remainder
                                  itemsFromTopics: [self allPreferredTopics]]];
    
    if(drawnItems.count >= itemCount) return drawnItems;
    
    // we separate this step from the previous so that we can save the time it
    // takes to create the array of "other" topics.
    remainder = itemCount - drawnItems.count;
    [drawnItems addObjectsFromArray: [self atMost: remainder
                                  itemsFromTopics: [self otherLibraryTopics]]];
    
    return drawnItems;
}

- (NSArray*) otherLibraryTopics {
    NSMutableArray *topics = [library.topics mutableCopy];
    [topics removeObject: self.mainTopic];
    [topics removeObjectsInArray: [self allPreferredTopics]];
    return topics;
}

- (NSArray*) atMost: (NSUInteger) count itemsFromTopics: (NSArray*) topics {
    TopicCollection *collection = [[TopicCollection alloc] initWithTopics: topics];
    NSArray *items = [collection scrambledItems];
    NSUInteger limit = MIN(count, items.count);
    NSRange range;
    range.location = 0;
    range.length = limit;
    return [items subarrayWithRange: range];
}

@end
