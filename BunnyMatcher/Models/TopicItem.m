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
@end
