//
//  ViewController.m
//  BallsEnemy
//
//  Created by Abhishek Gupta on 4/11/17.
//  Copyright © 2017 Abhishek Gupta. All rights reserved.
//

#import "ViewController.h"
#import "EnemyBall.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (atomic, strong) UIImageView *player;

@end

NSMutableArray *speedArray;
AVAudioPlayer *audioPlayer;
@implementation ViewController

#define MovingObjectRadius 22


- (void)viewDidLoad {
    [super viewDidLoad];
     [txtf setHidden:YES];
       highScoreNumber = [[NSUserDefaults standardUserDefaults]integerForKey:@"highScoreSaved"];
    
}

-(IBAction)start {
    
    [startButton setHidden:YES];
    [highScore setHidden:YES];
    [highScoreLabel setHidden:YES];
     [txtf setHidden:NO];
    [soundButton setHidden:YES];
    [aboutButton setHidden:YES];
    [testButton setHidden:YES];
    [textField setHidden:YES];
    
    [highScore setHidden:YES];
    [highScoreLabel setHidden:YES];
    
    scoreNumber = 0;
    
    randomMain = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
    addMoreBall = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(addMoreBall) userInfo:nil repeats:YES];
    
    [self startAcceleratorForPlayer];
    self.player = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 40, 40)];
    UIImage *playerImage = [UIImage imageNamed:@"playerball"];
    self.player.image = playerImage;
    [self.view addSubview:self.player];
    [self.view bringSubviewToFront:self.player];
    
    speedArray = [[NSMutableArray alloc]init];
}

-(IBAction)sound {
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"music"
                                                              ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    audioPlayer.numberOfLoops = -1;
    [audioPlayer play];
    
}

UITextField *textField;
-(IBAction)about {
    
    [txtf setHidden:NO];
//    textField = [[UITextField  alloc] initWithFrame:
//                              CGRectMake(20, 50, 280, 30)];
//    
//    textField.borderStyle = UITextBorderStyleRoundedRect;
//    textField.contentVerticalAlignment =
//    UIControlContentVerticalAlignmentCenter;
//    [textField setFont:[UIFont boldSystemFontOfSize:12]];
//    
//    textField.placeholder = @"Save players ball from enemy ball";
//    
//    
//    textField.leftViewMode = UITextFieldViewModeAlways;
//    
//    [self.view addSubview:textField];
//    
//    // sets the delegate to the current class
//    textField.delegate = self;
}
-(IBAction)test {
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"Buzz"
                                                              ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    audioPlayer.numberOfLoops = -1;
    [audioPlayer play];
    
}

-(void)addMoreBall {
    
    EnemyBall *addmoreClass = [[EnemyBall alloc]init];
    [self.view addSubview: addmoreClass.addEnemyBallFromClass];
    CGPoint tempPos =  addmoreClass.enemyBallSpeed;
    [speedArray addObject:[NSValue valueWithCGPoint:tempPos]];
 //   NSLog(@"%@",NSStringFromCGPoint(tempPos));
    scoreNumber++;
    
}

-(void)onTimer {
    
    [self checkCollision];
    
    NSArray *subviews = [self.view subviews];
    
    NSUInteger index = 0;
    for (NSUInteger count=0; count <subviews.count; count++) {
        
        UIView *view = subviews[count];
        
        if ([view isKindOfClass: [UIImageView class]] && (view != self.player)) {
            
            CGPoint posistion = [speedArray[index] CGPointValue];
            
            view.center = CGPointMake(view.center.x + posistion.x, view.center.y + posistion.y);
            if (view.center.x > self.view.frame.size.width || view.center.x <0) {
                CGPoint tempSpeed = CGPointMake(-posistion.x, posistion.y);
                [speedArray replaceObjectAtIndex:index withObject:[NSValue valueWithCGPoint:tempSpeed]];
            }
            
            if (view.center.y > self.view.frame.size.height || view.center.y < 0) {
                
                CGPoint tempSpeed = CGPointMake(posistion.x, -posistion.y);
                [speedArray replaceObjectAtIndex:index withObject:[NSValue valueWithCGPoint:tempSpeed]];
            }
            
            NSUInteger indexAnotherView = 0;
            for (NSUInteger num = 0; num<subviews.count; num++) {
                
                UIView *anotherView = subviews[num];
                
                if ([anotherView isKindOfClass:[UIImageView class]] && (anotherView != self.player) && (anotherView != view)) {
                    
                    if (CGRectIntersectsRect(anotherView.frame, view.frame)) {
                        CGPoint anotherViewPosition = [speedArray[indexAnotherView] CGPointValue];
                        CGPoint tempAnotherViewSpeed = CGPointMake(-anotherViewPosition.x, -anotherViewPosition.y);
                        [speedArray replaceObjectAtIndex:indexAnotherView withObject:[NSValue valueWithCGPoint:tempAnotherViewSpeed]];
                        
                    CGPoint posistion = [speedArray[index] CGPointValue];
                    CGPoint tempViewSpeed = CGPointMake(-posistion.x, -posistion.y);
                        [speedArray replaceObjectAtIndex:index withObject:[NSValue valueWithCGPoint:tempViewSpeed]];
                    }
                    indexAnotherView++;
                }
            }
            
            index++;
        }
    }
}

-(void)checkCollision {
    
    NSArray *subview = [self.view subviews];
    
       for (UIView *viewInSub in subview) {
        
        if ([viewInSub isKindOfClass:[UIImageView class]] && (viewInSub != self.player)) {
            
            if (CGRectIntersectsRect(self.player.frame, viewInSub.frame)) {
                [randomMain invalidate];
                [startButton setHidden:NO];
                [aboutButton setHidden:NO];
                [soundButton setHidden:NO];
                [highScoreLabel setHidden:NO];
                [highScore setHidden:NO];
                [self.motionManager stopAccelerometerUpdates];
                [addMoreBall invalidate];
                [self removeSubView];
                
                               [highScoreLabel setText:[NSString stringWithFormat:@"Score"]];
                [highScore setText:[NSString stringWithFormat:@"%d",scoreNumber]];
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Lost" message:@"You are hit. Try Again!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                [alert show];
                
                
            }
        }
    }
}

//start the acceleration
-(void)startAcceleratorForPlayer {
    
    //declare start of motion sensor
    self.motionManager = [[CMMotionManager alloc]init];
    
    self.motionManager.accelerometerUpdateInterval = 0.01;
    
    if ([self.motionManager isAccelerometerAvailable]) {
        
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [self.motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData * accelerometerData, NSError * _Nullable error) {
            
            NSLog(@"X = %0.4f, Y = %.04f, Z = %0.4f",
                  accelerometerData.acceleration.x,
                  accelerometerData.acceleration.y,
                  accelerometerData.acceleration.z);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //acceleration for player
                float valueX = accelerometerData.acceleration.x * 30.0;
                float valueY = accelerometerData.acceleration.y * 30.0;
                
                //create new integers
                int intPlayerNewPosX = (int)(self.player.center.x + valueX);
                int intPlayerNewPosY = (int)(self.player.center.y - valueY);
                
                //position validation
                if (intPlayerNewPosX > (self.view.frame.size.width - MovingObjectRadius)) {
                    intPlayerNewPosX = (self.view.frame.size.width - MovingObjectRadius);
                }
                
                if (intPlayerNewPosX < (0 + MovingObjectRadius)) {
                    intPlayerNewPosX = (0 + MovingObjectRadius);
                }
                
                if (intPlayerNewPosY > (self.view.frame.size.height - MovingObjectRadius)) {
                    intPlayerNewPosY = (self.view.frame.size.height - MovingObjectRadius);
                }
                
                if (intPlayerNewPosY < (0 + MovingObjectRadius)) {
                    intPlayerNewPosY = (0+ MovingObjectRadius);
                }
                
                //Make new point
                CGPoint playerNewPoint = CGPointMake(intPlayerNewPosX, intPlayerNewPosY);
                self.player.center = playerNewPoint;
                
            });
        }];
    } else{
        NSLog(@"Not Active.");
    }
}


//This isn't working.
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
   //     NSLog(@"This is performed");
        [highScoreLabel setText:[NSString stringWithFormat:@"High Score"]];
       
        if (scoreNumber > highScoreNumber) {
            [[NSUserDefaults standardUserDefaults]setInteger:scoreNumber forKey:@"highScoreSaved"];
        }
        
        highestScoreNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScoreSaved"];
        [highScore setText: [NSString stringWithFormat:@"%li",(long)highestScoreNumber]];
    }
    
}


-(void)removeSubView {
    NSArray *subViews = [self.view subviews];
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *myTouch = [[event allTouches]anyObject];
    self.player.center = [myTouch locationInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
