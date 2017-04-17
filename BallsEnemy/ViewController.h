//
//  ViewController.h
//  BallsEnemy
//
//  Created by Abhishek Gupta on 4/11/17.
//  Copyright © 2017 Abhishek Gupta. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>



@interface ViewController : UIViewController {
    
    IBOutlet UIButton *startButton;
     IBOutlet UIButton *soundButton;
     IBOutlet UIButton *aboutButton;
     IBOutlet UIButton *testButton;
    IBOutlet UITextField *txtf;
    NSTimer *randomMain;
    NSTimer *addMoreBall;
    IBOutlet UILabel *highScoreLabel;
    IBOutlet UILabel *highScore;
    NSInteger highScoreNumber;
    int scoreNumber;
    long highestScoreNumber;
}

-(IBAction)start;

-(IBAction)sound;
-(IBAction)about;
-(IBAction)test;

@end

