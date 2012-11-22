//
//  TopicCollection.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "TopicCollection.h"
#import "Topic.h"
#import "NSMutableArray+Shuffling.h"

@implementation TopicCollection

@synthesize topics;

- (id) initWithTopics: (NSArray*) aTopics {
    self = [self init];
    if(self) {
        self.topics = aTopics;
    }
    return self;
}
- (NSArray*) items {
    NSMutableArray *items = [NSMutableArray array];
    
    for (Topic *topic in self.topics) {
        [items addObjectsFromArray: topic.items];
    }
    
    return items;
}
- (NSArray*) scrambledItems {
    NSMutableArray *itemsToScramble = [[self items] mutableCopy];
    [itemsToScramble shuffle];
    return itemsToScramble;
}
@end
