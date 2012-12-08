//
//  Hero.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/8/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hero : NSObject

@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) BOOL hasCollided;
@property (nonatomic, assign) NSUInteger lives;

@end
