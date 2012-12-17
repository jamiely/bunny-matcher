//
//  EnemyViewController.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/8/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "ActorMovement.h"
#import "EnemyView.h"

@protocol EnemyViewControllerDelegate <NSObject>
- (NSIndexPath*) nextIndexPathDestination;
@end

@interface EnemyViewController : UIViewController

- (void) beginEnemyMovement;
- (void) collide;

- (CGRect) presentationFrame;
- (CGPoint) presentationOrigin;

@property (nonatomic, strong) id<EnemyViewControllerDelegate> delegate;
@property (nonatomic, strong) ActorMovement *actorMovement;
@property (nonatomic, assign) BOOL mayMove;

@end
