//
//  Library.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topic.h"

@interface Library : NSObject

@property (nonatomic, strong) NSArray* topics;

+ (Library*) sharedInstance;

@end
