//
//  CharacterView.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/1/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharacterView : UIView
- (void) initialize;
- (void) showRunAnimation;
- (void) showStandingAnimation;
- (NSArray*) imagesInRange: (NSRange) range;
- (void)faceLeft;
- (void)faceRight;
@property (nonatomic, assign) CGSize spriteSize;
@property (nonatomic, strong) NSArray *runImages;
@property (nonatomic, strong) NSArray *standingImages;
@end
