//
//  Game.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/11/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Round.h"

@interface Game : NSObject
- (id) initWithLibrary:(Library*) library andItemCount: (NSUInteger) itemCount;
- (Round*) nextRound;
@property (nonatomic, strong) Round* currentRound;
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, assign) NSUInteger itemCount;
@property (nonatomic, readonly) NSArray *rounds;
@end
