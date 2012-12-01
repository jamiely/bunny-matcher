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
    
    self.topicLabel.text = [self topic].name;
    [self loadScore];
    self.roundCompleteView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self beginEnemyMovement];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.enemyMayMove = NO;
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

- (void) moveHeroToIndexPath: (NSIndexPath*) indexPath
                  completion: (void(^)(BOOL finished))completion {
    if(self.heroIsMoving) return;
    // start the animation
    self.heroIsMoving = YES;
    __weak BoardViewController *weakSelf = self;
    [self moveView: self.heroView
       toIndexPath: indexPath
        completion:^(BOOL finished) {
            weakSelf.heroIsMoving = NO;
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
            self.roundCompleteView.hidden = NO;
        }
    }
    else {
        scoreDelta = ROUND_SCORE_PENALTY;
    }
    
    self.round.score += scoreDelta;
    [self loadScore];
    [self.collectionView reloadItemsAtIndexPaths: @[indexPath]];
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

@end
