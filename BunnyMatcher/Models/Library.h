//
//  Library.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//
#import "Topic.h"

extern NSString* LIBRARY_TOPIC_FRUITS;
extern NSString* LIBRARY_TOPIC_STATES;
extern NSString* LIBRARY_TOPIC_ANIMALS;
extern NSString* LIBRARY_TOPIC_DESSERTS;

@interface Library : NSObject

- (void) loadDefaultTopics;
- (Topic*) topicWithName: (NSString*) name;
- (NSArray*) topicNames;
// Returns the topic after the passed topic, with wraparound. Returns nil
// if the topic is not part of the library
- (Topic*) topicAfter: (Topic*) topic;

// Load a library file
- (void) loadFromFile: (NSString*) filepath;
- (Topic*) randomTopic;

@property (nonatomic, strong) NSArray* topics;

+ (Library*) sharedInstance;

@end
