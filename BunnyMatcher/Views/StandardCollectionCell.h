//
//  StandardCollectionCell.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GameActiveSelectionStyle = 0,
    GameOverSelectionStyle
} GameCellSelectionStyle;

@interface StandardCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic, assign) GameCellSelectionStyle gameSelectionStyle;

@end
