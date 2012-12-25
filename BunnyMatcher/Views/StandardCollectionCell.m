//
//  StandardCollectionCell.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "StandardCollectionCell.h"

@implementation StandardCollectionCell

@synthesize gameSelectionStyle;

- (id)init {
    self = [super init];
    if(self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if(self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if(self) {
        [self initialize];
    }
    return self;
}

- (void) initialize {
    self.gameSelectionStyle = GameActiveSelectionStyle;
    
    [self updateBackgroundView];
}

- (void) updateBackgroundView {
    switch (self.gameSelectionStyle) {
        case GameActiveSelectionStyle:
            self.selectedBackgroundView = nil;
            break;
        case GameOverSelectionStyle:
            self.selectedBackgroundView = [[UIView alloc] initWithFrame: self.frame];
            self.selectedBackgroundView.backgroundColor = [UIColor greenColor];
            break;
    }
}

- (void)setGameSelectionStyle:(GameCellSelectionStyle)aGameSelectionStyle {
    if(self.gameSelectionStyle != aGameSelectionStyle) {
        gameSelectionStyle = aGameSelectionStyle;
        [self updateBackgroundView];
    }
}

@end
