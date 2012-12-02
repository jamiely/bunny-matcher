//
//  Scrambler.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "Topic.h"
#import "Library.h"

extern const NSUInteger SCRAMBLER_PREFERRED_NUM_MAIN_TOPIC_ITEMS;

@interface Scrambler : NSObject

- (id) initWithMainTopic: (Topic*) aMainTopic andLibrary: (Library*) aLibrary;

// these topics will be used before other topics
- (void) addPreferredTopic: (Topic*) aTopic;

// returns a list of topic items
- (NSArray*) drawWithCount: (NSUInteger) itemCount;
- (NSArray*) drawScrambledWithCount: (NSUInteger) itemCount;

- (NSArray*) allPreferredTopics;

@property (nonatomic, assign) NSUInteger preferredNumberOfMainTopicItems;
@property (nonatomic, strong) Topic *mainTopic;
@property (nonatomic, strong) Library *library;
@property (nonatomic, strong) NSMutableSet *preferredTopics;
@property (nonatomic, assign) NSUInteger drawnNumberOfMainTopicItems;

@end
