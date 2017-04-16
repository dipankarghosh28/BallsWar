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

-(IBAction)sound {
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"Buzz"
                                                              ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    audioPlayer.numberOfLoops = -1;
    [audioPlayer play];
    
}

-(IBAction)about {
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"Buzz"
                                                              ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    audioPlayer.numberOfLoops = -1;
    [audioPlayer play];
    
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
    NSLog(@"%@",NSStringFromCGPoint(tempPos));
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
            
            view.center = CGPointMake(view.center.x + posistion.x, view.center.y + posistion.y);    //movement of the enemyball
            
            if (view.center.x > self.view.frame.size.width || view.center.x <0) {  //when it hits the boundary condtion. Enemyball will move negaitve value.
                
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
                    
                    if (CGRectIntersectsRect(anotherView.frame, view.frame)) { //checking the collision between enemyballs && condition to make sure they are not the same view
                        /********************Check how they intersect here**************************/
                        
                        //deflection of anotherView
                        CGPoint anotherViewPosition = [speedArray[indexAnotherView] CGPointValue];
                        CGPoint tempAnotherViewSpeed = CGPointMake(-anotherViewPosition.x, -anotherViewPosition.y);
                        [speedArray replaceObjectAtIndex:indexAnotherView withObject:[NSValue valueWithCGPoint:tempAnotherViewSpeed]];
                        
                        //deflecton of view
                        CGPoint posistion = [speedArray[index] CGPointValue];                 //something wrong with this index
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
    
    //check collision for all the enemy balls
    for (UIView *viewInSub in subview) {
        
        if ([viewInSub isKindOfClass:[UIImageView class]] && (viewInSub != self.player)) {
            
            if (CGRectIntersectsRect(self.player.frame, viewInSub.frame)) {                  //Perform these once player intersects with any enemy
                
                [randomMain invalidate];
                [startButton setHidden:NO];
                [highScoreLabel setHidden:NO];
                [highScore setHidden:NO];
                [self.motionManager stopAccelerometerUpdates];
                [addMoreBall invalidate];
                [self removeSubView];
                
                //Display ScoreNumber first
                [highScoreLabel setText:[NSString stringWithFormat:@"Score"]];
                [highScore setText:[NSString stringWithFormat:@"%d",scoreNumber]];
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Lost" message:@"You are hit. Try Again!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                [alert show];
                
                
            }
        }
    }
}


//This isn't working.
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        NSLog(@"This is performed");
        [highScoreLabel setText:[NSString stringWithFormat:@"High Score"]];
        
        //display the highscore values
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
        if ([view isKindOfClass:[UIImageView class]]) { //remove enemy and player balls. Once start button is pressed, player ball will be added in.
            [view removeFromSuperview];
        }
    }
}

///////////////////////

@end
