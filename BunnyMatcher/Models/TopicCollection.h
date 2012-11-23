//
//  TopicCollection.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

@interface TopicCollection : NSObject
- (id) initWithTopics: (NSArray*) topics;

- (NSArray*) items;
// A randomized collection of TopicItem objects
- (NSArray*) scrambledItems;

@property (nonatomic, strong) NSArray *topics;

@end
