//
//  TopicItem.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "TopicItem.h"

@implementation TopicItem
@synthesize name;
- (id) initWithName: (NSString*) aName {
    self = [self init];
    if(self) {
        self.name = aName;
    }
    return self;
}
+ (id) itemWithName: (NSString*) aName {
    return [[TopicItem alloc] initWithName: aName];
}
+ (NSArray*) itemsWithNames: (NSArray*) aNames {
    NSMutableArray *items = [NSMutableArray arrayWithCapacity: aNames.count];
    
    for (NSString* name in aNames) {
        [items addObject: [TopicItem itemWithName: name]];
    }
    
    return items;
}
@end
