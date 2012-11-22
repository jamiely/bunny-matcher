//
//  ScramblerTests.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "ScramblerTests.h"
#import "Scrambler.h"

@interface ScramblerTests() {
    Scrambler *scrambler;
    Topic *mainTopic;
    Library *library;
    Topic *fruit;
    Topic *animals;
    Topic *appliances;
}

@end

@implementation ScramblerTests
- (void) setUp {
    [super setUp];

    // create topics
    fruit = [Topic topicWithName: @"fruit"
                    andItemNames: @[@"pear", @"tomato"]];
    
    animals = [Topic topicWithName: @"animals"
                      andItemNames: @[@"elephant", @"lion"]];
    
    appliances = [Topic topicWithName: @"appliances"
                         andItemNames: @[@"blender", @"toaster"]];
    
    // setup the library
    library = [[Library alloc] init];
    library.topics = @[fruit, animals, appliances];
    
    // set the main topic
    mainTopic = fruit;
    
    scrambler = [[Scrambler alloc] initWithMainTopic: mainTopic andLibrary: library];
}

- (void) testProperties {
    STAssertTrue(scrambler.preferredNumberOfMainTopicItems > 0, @"main items greater than 0");
    STAssertEquals(scrambler.mainTopic, mainTopic, @"Main topic matches");
    STAssertEquals(scrambler.library, library, @"Library matches");
}

- (void) testDrawMain {
    NSArray *items = [scrambler drawWithCount: 1];
    NSString *firstName = [[items objectAtIndex: 0] name];
    STAssertTrue([firstName isEqualToString: @"pear"] ||
                 [firstName isEqualToString: @"tomato"],
                 @"main topic is drawn first");
}

- (void) testDrawPreferred {
    scrambler.mainTopic = appliances;
    [scrambler addPreferredTopic: animals];
    NSArray *items = [scrambler drawWithCount: 3];
    NSMutableArray *names = [NSMutableArray array];
    for (TopicItem *item in items) {
        [names addObject: item.name];
    }
    
    STAssertTrue([names containsObject: @"blender"], @"Contains blender");
    STAssertTrue([names containsObject: @"toaster"], @"Contains toaster");
    STAssertTrue([names containsObject: @"elephant"] ||
                 [names containsObject: @"lion"], @"Contains object");
    STAssertFalse([names containsObject: @"pear"], @"Does not contain pear");
    STAssertFalse([names containsObject: @"tomato"], @"Does not contain tomato");
}

@end
