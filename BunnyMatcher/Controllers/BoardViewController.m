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
#import "Game.h"
#import "GameAudioController.h"
#import "GameOverViewController.h"
#import "RoundCompleteViewController.h"
#import "BMColor.h"

const NSUInteger BOARD_ITEM_COUNT = 30;

NSString *BOARDVIEWCONTROLLER_SCORE_FORMAT = @"%06d";
NSString *BOARDVIEWCONTROLLER_NEGATIVE_SCORE_FORMAT = @"(%06d)";

@interface BoardViewController ()
@property (nonatomic, strong) HeroViewController *heroController;
@property (nonatomic, strong) EnemyViewController *enemyController;
@property (nonatomic, strong) ActorMovement *actorMovement;
@property (nonatomic, strong) NSTimer *gameLoopTimer;
@property (nonatomic, strong) Game *game;
@property (nonatomic, strong) NSDate *lastLoopTime;
@property (nonatomic, readonly) GameAudioController *audio;
@property (nonatomic, assign) BOOL highlightItems;

@property (nonatomic, assign) CGSize cellSizeIPadPortrait;
@property (nonatomic, assign) CGSize cellSizeIPadLandscape;
@property (nonatomic, assign) CGSize cellSizeIPhonePortrait;
@property (nonatomic, assign) CGSize cellSizeIPhoneLandscape;
@property (nonatomic, assign) CGSize cellSizeIPhone5Portrait;
@property (nonatomic, assign) CGSize cellSizeIPhone5Landscape;
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

- (void) initCellSizes {
    self.cellSizeIPadPortrait = CGSizeMake(245, 80);
    self.cellSizeIPadLandscape = CGSizeMake(190, 100);
    
    self.cellSizeIPhonePortrait = CGSizeMake(100, 32);
    self.cellSizeIPhoneLandscape = CGSizeMake(86, 35);
    
    self.cellSizeIPhone5Portrait = CGSizeMake(100, 40);
    self.cellSizeIPhone5Landscape = CGSizeMake(86, 45);
}

- (void) initialize {
    [self initCellSizes];
    
    self.actorMovement = [[ActorMovement alloc] init];
    self.actorMovement.delegate = self;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.actorMovement.speed = 250;
    }
    
    // load the library
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"topics"
                                                         ofType:@"txt"];
    Library *lib = [Library sharedInstance];
    [lib loadFromFile: filepath];
    self.game = [[Game alloc] initWithLibrary:lib andItemCount:BOARD_ITEM_COUNT];
    
    self.heroController =
        [[HeroViewController alloc] initWithModel: [[Hero alloc] init]];
    self.heroController.actorMovement = self.actorMovement;
    
    self.enemyController = [[EnemyViewController alloc] init];
    self.enemyController.delegate = self;
    self.enemyController.actorMovement = self.actorMovement;
    
    self.highlightItems = NO;
}
#pragma mark - View Controller Delegate Functions

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.heroController.view = self.heroView;
    self.enemyController.view = self.enemyView;
    self.collectionView.backgroundColor = [BMColor grassColor];
    
    [self updateDisplays];
}

- (void)viewWillAppear:(BOOL)animated {
    self.highlightItems = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    [self startGameLoop];
    [self.enemyController beginEnemyMovement];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.enemyController endEnemyMovement];
    [self stopGameLoop];
    
    [super viewDidDisappear: animated];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.collectionView reloadData];
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
    
    NSUInteger index = indexPath.row;
    cell.textLabel.text = [self.round nameAtIndex: index];
    cell.gameSelectionStyle = self.highlightItems ? GameOverSelectionStyle : GameActiveSelectionStyle;
    [cell setSelected: self.highlightItems && [self.round isMainTopicItemAtIndex: index]];
    return cell;
}

- (void)  collectionView:(UICollectionView *)aCollectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self moveHeroToIndexPath: indexPath completion: nil];
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ?
            self.cellSizeIPadPortrait : self.cellSizeIPadLandscape;
    }
    else if([UIScreen mainScreen].bounds.size.height - 568 < DBL_EPSILON) {
        return UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ?
            self.cellSizeIPhone5Portrait : self.cellSizeIPhone5Landscape;
    }
    
    return UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ?
        self.cellSizeIPhonePortrait : self.cellSizeIPhoneLandscape;
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
    
    if ([self.round spotIsConsumedAtIndex: index]) {
        // do nothing
    }
    else if([self.round tryToConsumeSpotAtIndex: index]) {
        [self.audio pickup];
        if([self.round roundOver]) {
            [self roundCompleteSegue];
        }
    }
    else {
        [self.audio badPickup];
    }
    
    [self updateScoreDisplay];
    [self.collectionView reloadItemsAtIndexPaths: @[indexPath]];
}

- (void) moveHeroToIndexPath: (NSIndexPath*) indexPath
                  completion: (void(^)(BOOL finished))completion {
    [self.heroController resetCollision];
    
    if(self.heroController.isMoving) return;
    
    // start the animation
    [self.heroController moveToIndexPath: indexPath
                              completion:^(NSIndexPath * indexPath) {
          [self view: self.heroView movedToIndexPath: indexPath];
    }];
}

#pragma mark - Game Loop Functions

- (void) startGameLoop {
    [self stopGameLoop];

    self.lastLoopTime = [NSDate date];
    self.gameLoopTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                          target:self
                                                        selector:@selector(gameLoop)
                                                        userInfo:nil
                                                         repeats:YES];

}

- (void) gameLoop {
    [self resolveCollisions];
    [self updateTime];
}

- (void) updateTime {
    // Update time
    NSTimeInterval timeDelta = [self.lastLoopTime timeIntervalSinceNow];
    self.lastLoopTime = [NSDate date];
    self.game.currentRound.timeRemaining += timeDelta;
    
    if(self.game.currentRound.timeRemaining >= 0) {
        self.timeLabel.text = [NSString stringWithFormat: @"%02d",
                               (NSInteger)self.game.currentRound.timeRemaining];
    }
    else {
        [self gameOverSegue];
    }
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
    [self.heroController reboundFromPoint:
     [self.enemyController presentationOrigin]];
    
    int64_t delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.heroController resetCollision];
    });
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
    NSString *topicDisplayString = [[self topic].name capitalizedString];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.topicLabel.text = topicDisplayString;
    }
    self.title = topicDisplayString;
}

- (void) updateHeroDisplay {
    self.livesView.lives = self.heroController.heroLives;
}

- (void) updateScoreDisplay {
    NSString *format;
    NSInteger score;
    UIColor *color;
    
    if(self.game.score >= 0) {
        format = BOARDVIEWCONTROLLER_SCORE_FORMAT;
        score = self.game.score;
        color = [BMColor positiveScoreColor];
    }
    else {
        format = BOARDVIEWCONTROLLER_NEGATIVE_SCORE_FORMAT;
        score = - self.game.score;
        color = [BMColor negativeScoreColor];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat: format, score];
    self.scoreLabel.textColor = color;
}

#pragma mark - Model helpers

- (Round*) round {
    return self.game.currentRound;
}

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
    [self stopGameLoop];
    [self.audio roundComplete];
    
    static NSString *segueId = @"RoundCompleteSegue";
    [self performSegueWithIdentifier:segueId sender:self];
}

- (void) gameOverSegue {
    [self stopGameLoop];
    [self.audio gameOver];
    
    self.highlightItems = YES;
    [self.collectionView reloadData];
    
    static NSString *segueId = @"GameOverSegue";
    int64_t delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self performSegueWithIdentifier:segueId sender: self];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString: @"GameOverSegue"]) {
        [segue.destinationViewController setScoreRecord: self.game.scoreRecord];
    }
    if([segue.destinationViewController respondsToSelector: @selector(setRound:)]) {
        [segue.destinationViewController setRound: [self round]];
    }
}

- (IBAction) nextRound: (UIStoryboardSegue*) segue {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.game nextRound];
        [self updateDisplays];
        [self.collectionView reloadData];
        
        [self startGameLoop];
    }];
}

- (IBAction)onQuit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Sound effects

- (GameAudioController*) audio {
    return [GameAudioController sharedInstance];
}

@end
