//
//  TopicItem.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

@interface TopicItem : NSObject
- (id) initWithName: (NSString*) aName;
@property (nonatomic, copy) NSString *name;
+ (id) itemWithName: (NSString*) aName;
+ (NSArray*) itemsWithNames: (NSArray*) aNames;
@end
