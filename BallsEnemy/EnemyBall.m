//
//  EnemyBall.m
//  BallsEnemy
//
//  Created by Abhishek Gupta on 4/12/17.
//  Copyright © 2017 Abhishek Gupta. All rights reserved.
//

#import "EnemyBall.h"

@implementation EnemyBall

-(UIImageView *)addEnemyBallFromClass{
    
    UIViewController *myView = [[UIViewController alloc]init];
    int myViewHeight = myView.view.frame.size.height;
    int myViewWidth = myView.view.frame.size.width;
    
    int randomBool = rand()%2;
    
    if ((BOOL)randomBool) {
        UIImageView *enemyRedBall = [[UIImageView alloc]initWithFrame:CGRectMake(rand()%myViewWidth, 0, 44, 44)];
        UIImage *enemyImage = [UIImage imageNamed:@"enemyball"];
        enemyRedBall.image = enemyImage;
        return enemyRedBall;
    }else{
        UIImageView *enemyRedBall = [[UIImageView alloc]initWithFrame:CGRectMake(0, rand()%myViewHeight, 44, 44)];
        UIImage *enemyImage = [UIImage imageNamed:@"enemyball"];
        enemyRedBall.image = enemyImage;
        return enemyRedBall;
    }
}
-(CGPoint)enemyBallSpeed {
    
    long randomX = (random()%2+1) ;
    long randomY = (random()%4+1);
    CGPoint speed = CGPointMake(randomX , randomY);
    
    return speed;
}
@end
