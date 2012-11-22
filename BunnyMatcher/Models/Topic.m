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

- (NSArray*) items {
    return _items;
}

@end
