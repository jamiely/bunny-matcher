//
//  BoardViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "BoardViewController.h"
#import "StandardCollectionCell.h"
#import "ActorMovement.h"
#import "HeroViewController.h"

const NSUInteger BOARD_ITEM_COUNT = 28;

NSString *BOARDVIEWCONTROLLER_SCORE_FORMAT = @"%06d";
NSString *BOARDVIEWCONTROLLER_NEGATIVE_SCORE_FORMAT = @"(%06d)";

@interface BoardViewController ()
@property (nonatomic, strong) HeroViewController *heroController;
@property (nonatomic, strong) EnemyViewController *enemyController;
@property (nonatomic, strong) ActorMovement *actorMovement;
@property (nonatomic, strong) NSTimer *gameLoopTimer;
@end

@implementation BoardViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (void) initialize {
    self.actorMovement = [[ActorMovement alloc] init];
    self.actorMovement.delegate = self;
    
    // later, we'll pass a round pre-built to this controller
    if(!self.round) {
        self.round = [Round roundWithLibrary:[Library sharedInstance]
                            andMainTopicName:LIBRARY_TOPIC_STATES];
        [self.round startRoundWithItemCount: BOARD_ITEM_COUNT];
    }
    
    self.heroController =
        [[HeroViewController alloc] initWithModel: [[Hero alloc] init]];
    self.enemyController = [[EnemyViewController alloc] init];
    self.enemyController.delegate = self;
    self.enemyController.actorMovement = self.actorMovement;
}

#pragma mark - View Controller Delegate Functions

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.heroController.view = self.heroView;
    self.enemyController.view = self.enemyView;
    
    [self updateDisplays];
}

- (void)viewDidAppear:(BOOL)animated {
    [self startGameLoop];
    [self.enemyController beginEnemyMovement];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.enemyController.mayMove = NO;
    [self stopGameLoop];
}

- (NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.round.topicItemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)aCollectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"StandardCell";
    StandardCollectionCell *cell =
        [aCollectionView dequeueReusableCellWithReuseIdentifier:cellId
                                                   forIndexPath:indexPath];
    cell.textLabel.text = [self.round nameAtIndex: indexPath.row];
    return cell;
}

- (void)  collectionView:(UICollectionView *)aCollectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self moveHeroToIndexPath: indexPath completion: nil];
}

#pragma mark - EnemyViewControllerDelegate functions

- (NSIndexPath*) nextIndexPathDestination {
    return [self randomIndexPath];
}

#pragma mark - Movement functions

- (CGRect) view: (UIView*) aView locationFromIndexPath: (NSIndexPath*) indexPath {
    // get the new hero location
    UICollectionViewCell *cell = [self collectionView: self.collectionView
                               cellForItemAtIndexPath: indexPath];
    CGRect cellFrame = [self.view convertRect: cell.frame
                                     fromView: self.collectionView];
    
    return [self.actorMovement newActorLocationFromFrame:aView.frame
                                                 toFrame:cellFrame];
}

// Called when the hero has finished moving to the item corresponding to the
// indexPath.
- (void) view: (UIView*) aView movedToIndexPath: (NSIndexPath*) indexPath {
    if(aView != self.heroView) return;
    
    NSUInteger index = indexPath.row;
    
    if([self.round spotIsConsumedAtIndex: index]) {
        return;
    }
    
    if([self.round tryToConsumeSpotAtIndex: index]) {
        if([self.round roundOver]) {
            [self roundCompleteSegue];
        }
    }
    
    [self updateScoreDisplay];
    [self.collectionView reloadItemsAtIndexPaths: @[indexPath]];
}

- (void) moveHeroToIndexPath: (NSIndexPath*) indexPath
                  completion: (void(^)(BOOL finished))completion {
    [self.heroController resetCollision];
    
    if(self.heroController.isMoving) return;
    
    // start the animation
    [self.heroController startMovement];
    __weak BoardViewController *weakSelf = self;
    [self.actorMovement moveView: self.heroView
                     toIndexPath: indexPath
                      completion:^(BOOL finished) {
                          [weakSelf.heroController stopMovement];
                          if(! finished) return;
                        
                          [weakSelf view: weakSelf.heroView movedToIndexPath: indexPath];
                      }];
}

#pragma mark - Game Loop Functions

- (void) startGameLoop {
    [self stopGameLoop];
    
    self.gameLoopTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                          target:self
                                                        selector:@selector(gameLoop)
                                                        userInfo:nil
                                                         repeats:YES];
}

- (void) gameLoop {
    [self resolveCollisions];
}

- (void) stopGameLoop {
    if(! self.gameLoopTimer) return;
    
    [self.gameLoopTimer invalidate];
    self.gameLoopTimer = nil;
}

#pragma mark - Collision monitoring

- (void) resolveCollisions {
    if(self.heroController.hasCollided) return;

    if([self.heroController collidesWithRect:
        self.enemyController.presentationFrame]) {
        [self handleCollision];
    }
}

- (void) handleCollision {
    [self.enemyController collide];
    [self collideHero];
}

- (void) collideHero {
    [self.heroController collide];
    [self updateHeroDisplay];
    
    if([self isGameOver]) {
        [self gameOverSegue];
    }
}

#pragma mark - UI Updates

- (void) updateDisplays {
    [self updateTopicDisplay];
    [self updateHeroDisplay];
    [self updateScoreDisplay];
}

- (void) updateTopicDisplay {
    self.topicLabel.text = [[self topic].name capitalizedString];
}

- (void) updateHeroDisplay {
    self.livesView.lives = self.heroController.heroLives;
}

- (void) updateScoreDisplay {
    NSString *format;
    NSInteger score;
    UIColor *color;
    
    if(self.round.score >= 0) {
        format = BOARDVIEWCONTROLLER_SCORE_FORMAT;
        score = self.round.score;
        color = [UIColor blackColor];
    }
    else {
        format = BOARDVIEWCONTROLLER_NEGATIVE_SCORE_FORMAT;
        score = - self.round.score;
        color = [UIColor redColor];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat: format, score];
    self.scoreLabel.textColor = color;
}

#pragma mark - Model helpers

- (BOOL) isGameOver {
    return self.heroController.heroLives == 0;
}

- (Topic*) topic {
    return self.round.mainTopic;
}


- (NSIndexPath*) randomIndexPath {
    NSInteger itemCount = [self collectionView: self.collectionView numberOfItemsInSection:0];
    NSInteger index = arc4random_uniform(itemCount);
    return [NSIndexPath indexPathForItem: index inSection: 0];
}

#pragma mark - Segue functions

- (void) roundCompleteSegue {
    static NSString *segueId = @"RoundCompleteSegue";
    [self performSegueWithIdentifier:segueId sender:self];
}

- (void) gameOverSegue {
    static NSString *segueId = @"GameOverSegue";
    [self performSegueWithIdentifier:segueId sender: self];
}

- (IBAction) playAgain: (UIStoryboardSegue*) segue {
    void ((^completion)()) = ^{
        [self.navigationController popViewControllerAnimated: NO];
    };
    [self dismissViewControllerAnimated:YES completion:completion];
}

- (IBAction) nextRound: (UIStoryboardSegue*) segue {
    [self dismissViewControllerAnimated:YES completion:^{
        self.round = self.round.nextRound;
        [self.round startRoundWithItemCount: BOARD_ITEM_COUNT];
        
        [self.heroController resetLives];
        [self updateDisplays];
        [self.collectionView reloadData];
    }];
}

@end
