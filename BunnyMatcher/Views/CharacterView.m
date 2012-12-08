//
//  CharacterView.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/1/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "CharacterView.h"
#import "UIImage+Sprite.h"

@interface CharacterView()
@property (nonatomic, strong) UIImage* spriteSheetImage;
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation CharacterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if(self) {
        [self initialize];
    }
    return self;
}

- (NSString*) spriteImageName {
    return @"";
}

- (void) initialize {
    self.spriteSheetImage = [UIImage imageNamed: [self spriteImageName]];
    
    CGSize spriteSize = CGSizeMake(56.f, 80.f);
    
    CGRect imageViewFrame = CGRectMake(0, 0, 0, 0);
    imageViewFrame.size = spriteSize;
    self.imageView = [[UIImageView alloc] initWithFrame: imageViewFrame];
    
    NSRange runRange;
    runRange.length = 6;
    runRange.location = 3;
    self.imageView.animationImages =
    [self.spriteSheetImage spritesWithSpriteSheetImage: self.spriteSheetImage
                                               inRange: runRange
                                            spriteSize: spriteSize];
    self.imageView.animationDuration = 0.7;
    self.imageView.animationRepeatCount = 0; // infinite
    
    [self addSubview: self.imageView];
    [self bringSubviewToFront: self.imageView];
    [self.imageView startAnimating];
}
@end
