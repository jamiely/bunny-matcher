//
//  Score.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/15/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreRecord : NSObject
- (NSDictionary*) dictionary;
+ (ScoreRecord*) recordFromDictionary:(NSDictionary*)dict;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSString* scorer;
@end
