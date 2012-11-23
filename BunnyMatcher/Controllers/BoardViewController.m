//
//  BoardViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "BoardViewController.h"
#import "StandardCollectionCell.h"

@interface BoardViewController () {
    BOOL heroIsMoving;
}
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
    heroIsMoving = NO;
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UICollectionViewCell *cell = [self collectionView: aCollectionView
                               cellForItemAtIndexPath: indexPath];
    // calculate the cell center
    CGPoint destination = cell.frame.origin;
    destination.x += cell.frame.size.width / 2.f;
    destination.y += cell.frame.size.height / 2.f;
    
    [self moveHeroTo: [self.view convertPoint: destination
                                     fromView: aCollectionView]];
}

#pragma mark - Hero functions

- (void) moveHeroTo: (CGPoint) location {
    if(heroIsMoving) return;
    
    CGRect newHeroLocation = self.heroView.frame;
    location.x -= newHeroLocation.size.width / 2.f;
    location.y -= newHeroLocation.size.height / 2.f;
    newHeroLocation.origin = location;
    
    // start the animation
    heroIsMoving = YES;
    __block UIView *hero = self.heroView;
    [UIView animateWithDuration:1.f animations:^{
        hero.frame = newHeroLocation;
    } completion:^(BOOL finished) {
        heroIsMoving = NO;
        self.round.score += 100;
        [self loadScore];
    }];
}

#pragma mark - Model helpers

- (Topic*) topic {
    return self.round.mainTopic;
}

- (void) loadScore {
    self.scoreLabel.text = [NSString stringWithFormat: @"%06u", self.round.score];
}

@end
