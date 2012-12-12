
//
//  BoardViewController.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeroView.h"
#import "LivesView.h"
#import "ActorMovement.h"
#import "EnemyViewController.h"

@interface BoardViewController : UIViewController<UICollectionViewDataSource,
    UICollectionViewDelegate, UIGestureRecognizerDelegate, ActorMovementDelegate,
    EnemyViewControllerDelegate>

- (IBAction) playAgain: (UIStoryboardSegue*) segue;
- (IBAction) nextRound: (UIStoryboardSegue*) segue;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet HeroView *heroView;
@property (weak, nonatomic) IBOutlet EnemyView *enemyView;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet LivesView *livesView;
@end
