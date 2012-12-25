//
//  HeroView.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "HeroView.h"
#import "UIImage+Sprite.h"

@implementation HeroView
- (void)initialize {
    [super initialize];
    
    self.spriteSize = CGSizeMake(110, 80);
    self.runImages = [self imagesInRange: NSMakeRange(1, 2)];
    self.standingImages = nil;
    [self showStandingAnimation];
}
- (NSString*) spriteImageName {
    return @"bunny_sprites.png";
}
@end
