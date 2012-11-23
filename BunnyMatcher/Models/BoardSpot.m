//
//  BoardSpot.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/23/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "BoardSpot.h"

@implementation BoardSpot

- (id) init {
    self = [super init];
    if(self) {
        self.consumed = NO;
    }
    return self;
}

- (id) initWithItem: (TopicItem*) aItem {
    self = [self init];
    if(self) {
        self.item = aItem;
    }
    return self;
}

- (void) consume {
    self.consumed = YES;
}

- (NSString*) name {
    return self.consumed ? @"" : self.item.name;
}

+ (BoardSpot*) spotWithItem: (TopicItem*) item {
    return [[BoardSpot alloc] initWithItem: item];
}

@end
