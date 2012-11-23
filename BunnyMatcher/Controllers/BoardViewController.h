//
//  BoardViewController.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Round.h"
#import "HeroView.h"

@interface BoardViewController : UIViewController<UICollectionViewDataSource,
    UICollectionViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) Round *round;
@property (weak, nonatomic) IBOutlet HeroView *heroView;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end
