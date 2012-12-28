//
//  EnemyView.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/23/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "EnemyView.h"

@implementation EnemyView
- (void)initialize {
    [super initialize];
    
    self.spriteSize = CGSizeMake(140, 79);
    self.runImages = [self imagesInRange: NSMakeRange(1, 2)];
    self.standingImages = nil;
    [self showStandingAnimation];
}
- (NSString*) spriteImageName {
    return @"fox_sprites.png";
}
@end
