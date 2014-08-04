//
//  MyScene.h
//  Crowded
//

//  Copyright (c) 2014 Alex Yeh. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene <SKPhysicsContactDelegate> {
    SKSpriteNode * player;
    NSMutableArray *enemyArray;
    CGFloat enemyHeight;
    CGFloat enemyWidth;
    int score;
    SKLabelNode* scoreLabel;
    BOOL isAlive;
}
@property (nonatomic, retain) SKSpriteNode * player;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic, weak) SKNode *draggedNode;
@end
