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
    assert(NO);
}

- (void)faceLeft {
    self.imageView.transform = CGAffineTransformMake(-1, 0, 0, 1, 0, 0);
}

- (void)faceRight {
    self.imageView.transform = CGAffineTransformIdentity;
}

- (void)showStandingAnimation {
    [self.imageView stopAnimating];
    [self setupImageViewForStanding];
    [self.imageView startAnimating];
}

- (void)showRunAnimation {
    [self.imageView stopAnimating];
    [self setupImageViewForRunning];
    [self.imageView startAnimating];
}

- (void) setupImageViewForStanding {
    if(!self.standingImages) {
        self.standingImages = [self imagesInRange: NSMakeRange(0, 1)];
    }
    [self setupImages: self.standingImages withDuration: 2.0f];
}

- (void) setupImageViewForRunning {
    if(!self.runImages) {
        self.runImages = [self imagesInRange: NSMakeRange(3,6)];
    }
    [self setupImages: self.runImages withDuration: 0.2];
}

- (void) setupImages: (NSArray*) images withDuration: (CGFloat) duration {
    self.imageView.animationImages = images;
    self.imageView.animationDuration = duration;
}

- (NSArray*) imagesInRange: (NSRange) range {
    return [self.spriteSheetImage spritesWithSpriteSheetImage:self.spriteSheetImage
                                                      inRange: range
                                                   spriteSize: self.spriteSize];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect imageViewFrame = CGRectMake(0, 0, 0, 0);
    imageViewFrame.size = self.frame.size;
    self.imageView.frame = imageViewFrame;
}

- (void) initialize {
    self.spriteSheetImage = [UIImage imageNamed: [self spriteImageName]];
    
    self.spriteSize = CGSizeMake(56.f, 80.f);
    
    CGRect imageViewFrame = CGRectMake(0, 0, 100, 100);
    self.imageView = [[UIImageView alloc] initWithFrame: imageViewFrame];
    self.imageView.animationRepeatCount = 0; // infinite
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [self showStandingAnimation];
    
    [self addSubview: self.imageView];
    [self bringSubviewToFront: self.imageView];
    
    self.backgroundColor = [UIColor clearColor];
    [self hideLabels];
}

- (void) hideLabels {
    for(UIView *view in self.subviews) {
        if([view isKindOfClass: [UILabel class]]) {
            view.hidden = YES;
        }
    }
}
@end
