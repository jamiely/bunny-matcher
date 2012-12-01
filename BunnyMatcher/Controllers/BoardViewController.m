//
//  BoardViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "BoardViewController.h"
#import "StandardCollectionCell.h"
#import "EnemyViewController.h"

NSString *BOARDVIEWCONTROLLER_SCORE_FORMAT = @"%06d";
NSString *BOARDVIEWCONTROLLER_NEGATIVE_SCORE_FORMAT = @"(%06d)";

@interface BoardViewController () {
}
@property (nonatomic, assign) BOOL heroIsMoving;
@property (nonatomic, assign) BOOL enemyMayMove;
@property (nonatomic, strong) EnemyViewController *enemyController;
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
    
    // setup enemy
    self.enemyController = [[EnemyViewController alloc] init];
    self.enemyController.view = self.enemyView;
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
    [self moveHeroToIndexPath: indexPath];
}

#pragma mark - Enemy functions

- (void) beginEnemyMovement {
    self.enemyMayMove = true;
    [self moveEnemyRecursivelyWithIntervalInSeconds: 5.0];
}

- (void) moveEnemyRecursivelyWithIntervalInSeconds: (CGFloat) intervalInSeconds {
    if(!self.enemyMayMove) return;
    
    [self moveEnemyAfterDelayInSeconds: intervalInSeconds completion:^{
        [self moveEnemyRecursivelyWithIntervalInSeconds: intervalInSeconds];
    }];
}

- (void) moveEnemyAfterDelayInSeconds: (CGFloat) delayInSeconds
                           completion: (void (^)()) completion {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.enemyController moveWithinFrame: self.view.frame];
        if(completion) {
            completion();
        }
    });
}

#pragma mark - Hero functions

- (CGRect) newHeroLocationFromCell: (UICollectionViewCell*) cell {
    // calculate the cell center
    CGPoint destination = cell.frame.origin;
    destination.x += cell.frame.size.width / 2.f;
    destination.y += cell.frame.size.height / 2.f;
    destination = [self.view convertPoint: destination
                                 fromView: self.collectionView];
    
    CGRect newHeroLocation = self.heroView.frame;
    destination.x -= newHeroLocation.size.width / 2.f;
    destination.y -= newHeroLocation.size.height / 2.f;
    newHeroLocation.origin = destination;
    
    return newHeroLocation;
}

- (CGRect) newHeroLocationFromIndexPath: (NSIndexPath*) indexPath {
    // get the new hero location
    UICollectionViewCell *cell = [self collectionView: self.collectionView
                               cellForItemAtIndexPath: indexPath];
    return [self newHeroLocationFromCell: cell];
}

- (CGRect) intermediateHeroFrameGivenCurrentFrame: (CGRect*) currentFrame
                                    andFinalFrame: (CGRect*) finalFrame {
    
    CGRect intermediateHeroFrame = *finalFrame;
    
    CGPoint finalOrigin = (*finalFrame).origin;
    CGPoint currentOrigin = (*currentFrame).origin;
    
    CGFloat dx = ABS(finalOrigin.x - currentOrigin.x);
    CGFloat dy = ABS(finalOrigin.y - currentOrigin.y);
    
    CGPoint intermediateOrigin = intermediateHeroFrame.origin;
    
    if(dx > dy) {
        // then we want to move in the y direction first
        intermediateOrigin.x = currentOrigin.x;
    }
    else {
        intermediateOrigin.y = currentOrigin.y;
    }
    
    intermediateHeroFrame.origin = intermediateOrigin;
    
    return intermediateHeroFrame;
}

- (void) moveHeroToIndexPath: (NSIndexPath*) indexPath {
    if(self.heroIsMoving) return;
    
    CGRect currentHeroFrame = self.heroView.frame;
    CGRect finalHeroFrame = [self newHeroLocationFromIndexPath: indexPath];
    CGRect intermediateHeroFrame =
        [self intermediateHeroFrameGivenCurrentFrame: &currentHeroFrame
                                       andFinalFrame: &finalHeroFrame];
    
    // start the animation
    self.heroIsMoving = YES;
    __weak BoardViewController *weakSelf = self;
    [self changeHeroFrameTo: intermediateHeroFrame
               andThenFrame: finalHeroFrame
                 completion:^(BOOL finished) {
                     weakSelf.heroIsMoving = NO;
                     [weakSelf movedToIndexPath: indexPath];
                 }];
}

- (void) changeHeroFrameTo: (CGRect) intermediateHeroFrame
              andThenFrame: (CGRect) finalHeroFrame
                completion: (void (^)(BOOL))completion  {


    __weak BoardViewController *weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        // We want to move in two parts. First, move in the y direction,
        // straight down.
        weakSelf.heroView.frame = intermediateHeroFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.heroView.frame = finalHeroFrame;
        } completion: completion];
    }];
}

// Called when the hero has finished moving to the item corresponding to the
// indexPath.
- (void) movedToIndexPath: (NSIndexPath*) indexPath {
    NSUInteger index = indexPath.row;
    
    if([self.round spotIsConsumedAtIndex: index]) {
        return;
    }
    
    NSInteger scoreDelta = 0;
    if([self.round mayConsumeSpotAtIndex: index]) {
        [self.round consumeSpotAtIndex: index];
        scoreDelta = ROUND_SCORE_POINT;
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
