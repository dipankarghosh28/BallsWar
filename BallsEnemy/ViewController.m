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

-(IBAction)start {
    
    [startButton setHidden:YES];
    [highScore setHidden:YES];
    [highScoreLabel setHidden:YES];
    
    scoreNumber = 0;
    
    randomMain = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
    addMoreBall = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(addMoreBall) userInfo:nil repeats:YES];
    
    
    //Add player ball
    self.player = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 40, 40)];
    UIImage *playerImage = [UIImage imageNamed:@"playerball"];
    self.player.image = playerImage;
    [self.view addSubview:self.player];
    [self.view bringSubviewToFront:self.player];
    
    speedArray = [[NSMutableArray alloc]init];
}

-(void)addMoreBall {
    
    EnemyBall *addmoreClass = [[EnemyBall alloc]init];
    [self.view addSubview: addmoreClass.addEnemyBallFromClass];
    CGPoint tempPos =  addmoreClass.enemyBallSpeed;
    [speedArray addObject:[NSValue valueWithCGPoint:tempPos]];
    NSLog(@"%@",NSStringFromCGPoint(tempPos));
    
    scoreNumber++;
    
}
@end
