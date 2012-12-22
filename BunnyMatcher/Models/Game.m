//
//  Game.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/11/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "Game.h"

@interface Game()
@property (nonatomic, strong) NSArray *rounds;
@property (nonatomic, assign) NSInteger scoreForPreviousRounds;
@end

@implementation Game
- (id) init {
    self = [super init];
    if(self) {
        self.scoreForPreviousRounds = 0;
        self.rounds = @[];
        self.itemCount = 0;
    }
    return self;
}

- (id) initWithLibrary:(Library*) library andItemCount: (NSUInteger) itemCount {
    self = [self init];
    if(self) {
        NSString *topicName = [library randomTopic].name;
        
        self.currentRound = [Round roundWithLibrary:library andMainTopicName:topicName];
        self.itemCount = itemCount;
        
        [self addRoundThenStart: self.currentRound];
    }
    return self;
}
- (void) addRoundThenStart: (Round*) round {
    [round startRoundWithItemCount: self.itemCount];
    
    [self addRound: round];
}
- (Round*) nextRound {
    // save score first
    self.scoreForPreviousRounds += self.currentRound.totalScore;
    
    self.currentRound = [self.currentRound nextRound];
    
    [self addRoundThenStart: self.currentRound];
    
    return self.currentRound;
}
- (NSInteger) score {
    return self.currentRound.score + self.scoreForPreviousRounds;
}
- (void) addRound: (Round*) round {
    id newRounds = [self.rounds mutableCopy];
    [newRounds addObject: round];
    self.rounds = [newRounds copy];
}
- (ScoreRecord*) scoreRecord {
    ScoreRecord *record = [[ScoreRecord alloc] init];
    record.score = self.score;
    return record;
}
@end
