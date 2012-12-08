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

NSString *BOARDVIEWCONTROLLER_SCORE_FORMAT = @"%06d";
NSString *BOARDVIEWCONTROLLER_NEGATIVE_SCORE_FORMAT = @"(%06d)";

@interface BoardViewController () {
}
@property (nonatomic, assign) BOOL heroIsMoving;
@property (nonatomic, assign) BOOL enemyMayMove;
@property (nonatomic, strong) ActorMovement *actorMovement;
@property (nonatomic, strong) NSTimer *gameLoopTimer;
@property (nonatomic, assign) BOOL heroHasCollided;
@property (nonatomic, assign) NSUInteger heroLives;
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
    self.heroIsMoving = NO;
    self.heroHasCollided = NO;
    self.heroLives = 3;
    self.actorMovement = [[ActorMovement alloc] init];
    
    // later, we'll pass a round pre-built to this controller
    if(!self.round) {
        self.round = [[Round alloc] init];
        self.round.library = [Library sharedInstance];
        self.round.mainTopic = [self.round.library topicWithName: LIBRARY_TOPIC_STATES];
        
        [self.round startRoundWithItemCount: 28];
    }
}

#pragma mark - View Controller Delegate Functions

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.topicLabel.text = [[self topic].name capitalizedString];
    [self loadScore];
    self.livesView.lives = self.heroLives;
}

- (void)viewDidAppear:(BOOL)animated {
    [self startGameLoop];
    [self beginEnemyMovement];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.enemyMayMove = NO;
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
    NSLog(@"count: %d", self.round.topicItemCount);
    return self.round.topicItemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)aCollectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StandardCollectionCell *cell =
        [aCollectionView dequeueReusableCellWithReuseIdentifier:@"StandardCell"
                                                   forIndexPath:indexPath];
    cell.textLabel.text = [self.round nameAtIndex: indexPath.row];
    return cell;
}

- (void)  collectionView:(UICollectionView *)aCollectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self moveHeroToIndexPath: indexPath completion: nil];
}

#pragma mark - Enemy functions

- (void) beginEnemyMovement {
    self.enemyMayMove = true;
    [self moveEnemyRecursivelyWithIntervalInSeconds: 5.0];
}

- (void) moveEnemyRecursivelyWithIntervalInSeconds: (CGFloat) intervalInSeconds {
    if(!self.enemyMayMove) return;
    
    [self moveEnemyAfterDelayInSeconds: intervalInSeconds completion:^(BOOL finish){
        [self moveEnemyRecursivelyWithIntervalInSeconds: intervalInSeconds];
    }];
}

- (void) moveEnemyAfterDelayInSeconds: (CGFloat) delayInSeconds
                           completion: (void (^)(BOOL finish)) completion {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self moveView: self.enemyView
           toIndexPath: [self randomIndexPath]
            completion: completion];
    });
}

- (NSIndexPath*) randomIndexPath {
    NSInteger itemCount = [self collectionView: self.collectionView numberOfItemsInSection:0];
    NSInteger index = arc4random_uniform(itemCount);
    return [NSIndexPath indexPathForItem: index inSection: 0];
}

#pragma mark - Hero functions

- (CGRect) view: (UIView*) aView locationFromIndexPath: (NSIndexPath*) indexPath {
    // get the new hero location
    UICollectionViewCell *cell = [self collectionView: self.collectionView
                               cellForItemAtIndexPath: indexPath];
    CGRect cellFrame = [self.view convertRect: cell.frame
                                     fromView: self.collectionView];
    
    return [self.actorMovement newActorLocationFromFrame:aView.frame
                                                 toFrame:cellFrame];
}

- (void) startHeroMovement {
    self.heroIsMoving = YES;
}

- (void) stopHeroMovement {
    self.heroIsMoving = NO;
    self.heroView.frame = [[self.heroView.layer presentationLayer] frame];
    [self.heroView.layer removeAllAnimations];
}

- (void) moveHeroToIndexPath: (NSIndexPath*) indexPath
                  completion: (void(^)(BOOL finished))completion {
    [self resetCollision];
    
    if(self.heroIsMoving) return;
    // start the animation
    [self startHeroMovement];
    __weak BoardViewController *weakSelf = self;
    [self moveView: self.heroView
       toIndexPath: indexPath
        completion:^(BOOL finished) {
            [weakSelf stopHeroMovement];
            if(! finished) return;
            
            [weakSelf view: weakSelf.heroView movedToIndexPath: indexPath];
        }];
}
- (void) moveView: (UIView*) aView
      toIndexPath: (NSIndexPath*) indexPath
       completion: (void(^)(BOOL finished))completion {
    
    CGRect currentHeroFrame = aView.frame;
    CGRect finalHeroFrame = [self view: aView locationFromIndexPath: indexPath];
    CGRect intermediateHeroFrame =
        [self.actorMovement intermediateActorFrameGivenCurrentFrame: &currentHeroFrame
                                                      andFinalFrame: &finalHeroFrame];
    
    [self moveView: aView
           toFrame: intermediateHeroFrame
         thenFrame: finalHeroFrame
        completion: completion];
}

- (void) moveView: (UIView*) aView
          toFrame: (CGRect) intermediateHeroFrame
        thenFrame: (CGRect) finalHeroFrame
       completion: (void (^)(BOOL))completion  {

    [UIView animateWithDuration:0.5 animations:^{
        // We want to move in two parts. First, move in the y direction,
        // straight down.
        aView.frame = intermediateHeroFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            aView.frame = finalHeroFrame;
        } completion: completion];
    }];
}

// Called when the hero has finished moving to the item corresponding to the
// indexPath.
- (void) view: (UIView*) aView movedToIndexPath: (NSIndexPath*) indexPath {
    if(aView != self.heroView) return;
    
    NSUInteger index = indexPath.row;
    
    if([self.round spotIsConsumedAtIndex: index]) {
        return;
    }
    
    NSInteger scoreDelta = 0;
    if([self.round mayConsumeSpotAtIndex: index]) {
        [self.round consumeSpotAtIndex: index];
        scoreDelta = ROUND_SCORE_POINT;
        if([self.round roundOver]) {
            [self performSegueWithIdentifier:@"RoundCompleteSegue" sender:self];
        }
    }
    else {
        scoreDelta = ROUND_SCORE_PENALTY;
    }
    
    self.round.score += scoreDelta;
    [self loadScore];
    [self.collectionView reloadItemsAtIndexPaths: @[indexPath]];
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
    if(self.heroHasCollided) return;
    
    // get the current animating position 
    CGRect heroRect = [[self.heroView.layer presentationLayer] frame];
    CGRect enemyRect = [[self.enemyView.layer presentationLayer] frame];

    if(CGRectIntersectsRect(heroRect, enemyRect)) {
        [self handleCollision];
    }
}

- (void) handleCollision {
    self.enemyView.frame = [[self.enemyView.layer presentationLayer] frame];
    [self.enemyView.layer removeAllAnimations];
    [self collideHero];
}

- (void) collideHero {
    self.heroHasCollided = YES;
    self.heroLives --;
    self.livesView.lives = self.heroLives;
    if(self.heroLives <= 0) {
        [self performSegueWithIdentifier:@"GameOverSegue" sender: self];
    }
    [self stopHeroMovement];
}

- (void) resetCollision {
    self.heroHasCollided = NO;
}

#pragma mark - Model helpers

- (Topic*) topic {
    return self.round.mainTopic;
}

- (void) loadScore {
    if(self.round.score >= 0) {
        self.scoreLabel.text = [NSString stringWithFormat: BOARDVIEWCONTROLLER_SCORE_FORMAT, self.round.score];
        
        self.scoreLabel.textColor = [UIColor blackColor];
    }
    else {
        self.scoreLabel.text = [NSString stringWithFormat: BOARDVIEWCONTROLLER_NEGATIVE_SCORE_FORMAT, -self.round.score];
        self.scoreLabel.textColor = [UIColor redColor];
    }
    
    
}

#pragma mark - Segue functions

- (IBAction) playAgain: (UIStoryboardSegue*) segue {
    void ((^completion)()) = ^{
        [self.navigationController popViewControllerAnimated: NO];
    };
    [self dismissViewControllerAnimated:YES completion:completion];
}

@end
