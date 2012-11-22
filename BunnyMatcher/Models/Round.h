//
//  Round.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topic.h"
#import "Library.h"

@interface Round : NSObject

- (void) startRoundWithItemCount: (NSUInteger) itemCount;
- (NSUInteger) topicItemCount;
- (NSArray*) topicItems;
- (TopicItem*) topicItemAtIndex: (NSUInteger) index;

@property (nonatomic, strong) Topic *mainTopic;
@property (nonatomic, strong) Library *library;

@end
