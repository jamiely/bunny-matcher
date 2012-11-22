//
//  BunnyMatcherTests.m
//  BunnyMatcherTests
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "BunnyMatcherTests.h"
#import "Topic.h"
#import "TopicCollection.h"
#import "Library.h"

@implementation BunnyMatcherTests

- (void) testTopicItem {
    TopicItem *item1 = [[TopicItem alloc] initWithName: @"name 1"];
    STAssertEquals(item1.name, @"name 1", @"Topic item has name");
    
    TopicItem *item2 = [TopicItem itemWithName: @"name 2"];
    STAssertEquals(item2.name, @"name 2", @"Topic item has name");
}

- (void) testTopic {
    Topic *topic1 = [[Topic alloc] init];
    topic1.name = @"topic 1";
    STAssertEquals(topic1.name, @"topic 1", @"Topic matches");
    
    TopicItem *item1 = [TopicItem itemWithName: @"item 1"];
    Topic *topic2 = [[Topic alloc] initWithName: @"topic 2" andItems: @[item1]];
    STAssertEquals(topic2.name, @"topic 2", @"Topic names match");
    STAssertEquals([topic2.items objectAtIndex: 0], item1, @"TopicItem matches");
}

- (void) testTopicCollection {
    NSArray *items1 = @[
        [TopicItem itemWithName: @"apple"],
        [TopicItem itemWithName: @"pear"]
        ];
    Topic *topic1 = [[Topic alloc] initWithName: @"topic 1" andItems: items1];
    
    NSArray *items2 = @[
        [TopicItem itemWithName: @"blue"],
        [TopicItem itemWithName: @"red"]
    ];
    Topic *topic2 = [[Topic alloc] initWithName: @"topic 2" andItems: items2];
    
    NSArray *topics = @[topic1, topic2];
    
    TopicCollection *collection = [[TopicCollection alloc] initWithTopics: topics];
    NSArray *items = [collection items];
    
    STAssertEquals([items objectAtIndex: 0], [items1 objectAtIndex: 0],
                   @"First items match");
    NSUInteger count = items.count;
    STAssertEquals([items objectAtIndex: count-1],
                   [items2 objectAtIndex: items2.count-1], @"Last items match");
    
    NSArray *scramble = [collection scrambledItems];
    STAssertTrue([scramble objectAtIndex: 0] != [items objectAtIndex: 0],
                  @"Items do not match");
}

- (void) testLibrary {
    Library *library = [[Library alloc] init];
    [library loadDefaultTopics];
    
    STAssertNotNil([library topicWithName: LIBRARY_TOPIC_FRUITS], @"Has fruit topic");
    STAssertNil([library topicWithName: @"nil"], @"Nil topic doesn't exist");
    
    STAssertTrue([[library topicNames] containsObject: LIBRARY_TOPIC_STATES],
                 @"Library has topic states");
}

@end
