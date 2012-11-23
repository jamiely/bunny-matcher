//
//  BoardSpot.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/23/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "TopicItem.h"

@interface BoardSpot : NSObject

- (id) initWithItem: (TopicItem*) aItem;
- (void) consume;
- (NSString*) name;

@property (nonatomic, assign) BOOL consumed;
@property (nonatomic, strong) TopicItem *item;

+ (BoardSpot*) spotWithItem: (TopicItem*) item;

@end
