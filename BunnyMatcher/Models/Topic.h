//
//  Topic.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "TopicItem.h"

@interface Topic : NSObject
- (id) initWithName: (NSString*) aName andItems: (NSArray*) aItems;
- (NSArray*) items;
- (BOOL) hasItem: (TopicItem*) item;
+ (id) topicWithName: (NSString*) aName andItems: (NSArray*) aItems;
+ (id) topicWithName: (NSString*) aName andItemNames: (NSArray*) aNames;
@property (nonatomic, strong) NSString* name;
@end
