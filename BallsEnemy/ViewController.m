//
//  ViewController.m
//  BallsEnemy
//
//  Created by Abhishek Gupta on 4/11/17.
//  Copyright © 2017 Abhishek Gupta. All rights reserved.
//

#import "ViewController.h"
#import "EnemyBall.h"

@interface ViewController ()

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (atomic, strong) UIImageView *player;

@end

NSMutableArray *speedArray;

@implementation ViewController

#define MovingObjectRadius 22

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    highScoreNumber = [[NSUserDefaults standardUserDefaults]integerForKey:@"highScoreSaved"];
    
}
@end
