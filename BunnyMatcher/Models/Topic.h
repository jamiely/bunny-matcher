//
//  Topic.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Topic : NSObject
- (NSArray*) items;
@property (nonatomic, strong) NSString* name;
@end
