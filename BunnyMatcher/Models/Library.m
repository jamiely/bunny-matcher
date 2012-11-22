//
//  Library.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "Library.h"

@implementation Library

@synthesize topics;

+ (Library*) sharedInstance {
    static Library *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Library alloc] init];
    });
    return instance;
}

@end
