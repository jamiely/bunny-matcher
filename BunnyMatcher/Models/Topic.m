//
//  Topic.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "Topic.h"

@interface Topic() {
    NSArray *_items;
}

@end

@implementation Topic

@synthesize name;

- (id) init {
    self = [super init];
    if(self) {
        _items = [NSArray array];
    }
    return self;
}

- (id) initWithName: (NSString*) aName andItems: (NSArray*) aItems {
    self = [self init];
    if(self) {
        self.name = aName;
        _items = aItems;
    }
    return self;
}

- (NSArray*) items {
    return _items;
}

+ (id) topicWithName: (NSString*) aName andItems: (NSArray*) aItems {
    return [[Topic alloc] initWithName: aName andItems: aItems];
}

+ (id) topicWithName: (NSString*) aName andItemNames: (NSArray*) aNames {
    return [Topic topicWithName: aName
                       andItems: [TopicItem itemsWithNames: aNames]];
}

@end
