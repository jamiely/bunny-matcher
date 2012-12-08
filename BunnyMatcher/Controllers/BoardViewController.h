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
#import "LivesView.h"

@interface BoardViewController : UIViewController<UICollectionViewDataSource,
    UICollectionViewDelegate, UIGestureRecognizerDelegate>

- (IBAction) playAgain: (UIStoryboardSegue*) segue;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) Round *round;
@property (weak, nonatomic) IBOutlet HeroView *heroView;
@property (weak, nonatomic) IBOutlet UIView *enemyView;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet LivesView *livesView;
@end
