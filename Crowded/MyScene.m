//
//  MyScene.m
//  Crowded
//
//  Created by Alex Yeh on 6/9/14.
//  Copyright (c) 2014 Alex Yeh. All rights reserved.
//

#import "MyScene.h"
#import "Enemy.h"
#import "CrowdedData.h"
#import "GameOver.h"
#import <QuartzCore/QuartzCore.h>

static const uint32_t playerCategory  =  0x1 << 0;
static const uint32_t enemyCategory =  0x1 << 1;

@implementation MyScene
@synthesize player;
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
//        NSArray *fontFamilies = [UIFont familyNames];
//        for (int i = 0; i < [fontFamilies count]; i++)
//        {
//            NSString *fontFamily = [fontFamilies objectAtIndex:i];
//            NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
//            NSLog (@"%@: %@", fontFamily, fontNames);
//        }
        
        /* Setup your scene here */
        enemyArray = [[NSMutableArray alloc]init];
        score = 0;
        //UIFont *customFont = [UIFont fontWithName: @"Basicav.2012"  size: 16];
        scoreLabel = [SKLabelNode labelNodeWithFontNamed: @"GAMECUBENDualSet"];
        scoreLabel.fontColor = [UIColor blackColor];
        scoreLabel.fontSize = 16.0f;
        scoreLabel.text =  @"Score: 000";
        scoreLabel.position = CGPointMake(self.frame.size.width-60, self.frame.size.height/2-150);
        [self addChild: scoreLabel];
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
        player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
        player.xScale = 0.55;
        player.yScale = 0.55;
        player.position = CGPointMake(player.size.width, self.frame.size.height/2);
        SKAction *rotate = [SKAction repeatActionForever:[SKAction rotateByAngle:20 duration:100]];
        [player runAction:rotate];
        [self addChild: player];
        [player setName:@"player"];
        NSLog(@"%@", [player name]);
        
        player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.size.width/2];
        player.physicsBody.dynamic = YES;
        player.physicsBody.categoryBitMask = playerCategory;
        player.physicsBody.contactTestBitMask = enemyCategory;
        player.physicsBody.collisionBitMask = 0;
        player.physicsBody.usesPreciseCollisionDetection = YES;
        isAlive = TRUE;
        
    }
    return self;
}

- (void)addMonster {
    
    // Create sprite
    Enemy * monster;
    NSNumber *rand = [NSNumber numberWithInt:arc4random() % 4];
    NSString *spriteString =  @"enemy0";
    //spriteString = [spriteString stringByAppendingString:[rand stringValue]];
    monster = [Enemy spriteNodeWithImageNamed:spriteString];
    [enemyArray addObject: monster];
    monster.xScale = 0.40;
    monster.yScale = 0.40;
    enemyHeight = monster.size.height;
    enemyWidth = monster.size.width;
    monster.isGrowing = FALSE;
    monster.isMoving = TRUE;
    
    monster.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: monster.size.width/2]; // 1
    monster.physicsBody.dynamic = YES; // 2
    monster.physicsBody.categoryBitMask = enemyCategory; // 3
    monster.physicsBody.contactTestBitMask = playerCategory; // 4
    monster.physicsBody.collisionBitMask = 0; // 5
    
    int minY = self.frame.size.height;
    int maxY = self.frame.size.height + 150;
    int rangeY = maxY - minY;
    int offScreenY = (arc4random() % rangeY) + minY;
    
    int minX = -100;
    int maxX = self.frame.size.width + 100;
    int rangeX = maxX - minX;
    int offScreenX = (arc4random() % rangeX) + minX;

    monster.position = CGPointMake(offScreenX, offScreenY);
    [self addChild:monster];
    
    minY = 60;
    maxY = self.frame.size.height - 60;
    rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    NSLog(@"%i", actualY);
    
    minX = monster.size.width*0.4/2;
    maxX = self.frame.size.width - monster.size.width*0.4/2;
    rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    NSLog(@"%i",actualX);

    SKAction *actionMove = [SKAction moveTo:CGPointMake(actualX, actualY) duration: 0.4];
    SKAction *rotate = [SKAction repeatActionForever:[SKAction rotateByAngle:10 duration:100]];
    [monster runAction: rotate];
    [monster runAction: actionMove completion: ^{
        monster.isMoving = FALSE;
    }];
    
}

- (void)player:(SKSpriteNode *)player didCollideWithEnemy:(SKSpriteNode *)enemy {
    Enemy *monster = (Enemy *)enemy;
    if(!monster.isMoving){
        SKEmitterNode *emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MyParticle" ofType:@"sks"]];
        emitter.position = player.position;
        [self addChild: emitter];
        isAlive = FALSE;
        NSLog(@"Hit");
        CrowdedData *crowdedData = [CrowdedData sharedManager];
        crowdedData.score = score;
        [player removeFromParent];
        
        SKTransition *reveal = [SKTransition fadeWithDuration:2];
        GameOver *scene = [GameOver sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
        [reveal setPausesOutgoingScene:NO];
        [reveal setPausesIncomingScene:NO];
        
    }
    
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // 2
    if ((firstBody.categoryBitMask & playerCategory) != 0 &&
        (secondBody.categoryBitMask & enemyCategory) != 0)
    {
        [self player:(SKSpriteNode *) firstBody.node didCollideWithEnemy:(SKSpriteNode *) secondBody.node];
    }
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        [self addMonster];
        score++;
        NSNumber *scoreNum = [NSNumber numberWithInt: score];
        NSString *string = [NSString stringWithFormat: @"Score: %i", score];
        NSString *num = [NSString stringWithString:[scoreNum stringValue]];
        //string = [string stringByAppendingPathComponent:num];
        scoreLabel.text = string;
    }
}

- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    if(isAlive){
        CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
        self.lastUpdateTimeInterval = currentTime;
        if (timeSinceLast > 1) { // more than a second since last update
            timeSinceLast = 1.0 / 60.0;
            self.lastUpdateTimeInterval = currentTime;
        }
    
        [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
        for (Enemy *enemy in enemyArray) {
            CGFloat distance = SDistanceBetweenPoints(player.position, enemy.position);
            if (distance < 120) {
                [self enemyMovement:enemy];
                if(!enemy.isGrowing){
                    [enemy removeActionForKey: @"shrink"];
                    SKAction *grow = [SKAction scaleBy:2.8 duration: 10];
                    enemy.isGrowing = TRUE;
                    [enemy runAction: grow withKey:@"grow"];
                    NSLog(@"%@", enemy);
                }
            } else {
                if(enemy.isGrowing){
                    [enemy removeActionForKey: @"grow"];
                    SKAction *shrink = [SKAction resizeToWidth:enemyWidth height:enemyHeight duration: 15];
                    [enemy runAction:shrink withKey:@"shrink"];
                    enemy.isGrowing = FALSE;
                }
            }
        }
    }
    
}

CGFloat SDistanceBetweenPoints(CGPoint first, CGPoint second) {
    return hypotf(second.x - first.x, second.y - first.y);
}

static inline CGPoint rwAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint rwSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint rwMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}

static inline float rwLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

// Makes a vector have a length of 1
static inline CGPoint rwNormalize(CGPoint a) {
    float length = rwLength(a);
    return CGPointMake(a.x / length, a.y / length);
}

-(void)enemyMovement:(Enemy*) enemy{
    CGPoint location = rwSub(enemy.position, player.position);
    location = rwNormalize(location);
    location = rwMult(location, -1.0);
    enemy.position = rwAdd(enemy.position, location);
    //[enemy runAction: grow];
}

-(void)touchesBegan:(NSSet*) touches withEvent:(UIEvent*) event {
    NSArray *nodes = [self nodesAtPoint:[[touches anyObject] locationInNode: self]];
    for (SKNode *node in nodes) {
        if([node.name isEqualToString:@"player"])
            self.draggedNode = [self nodeAtPoint:[[touches anyObject] locationInNode:self]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint positionInScene = [touch locationInNode:self];
	CGPoint previousPosition = [touch previousLocationInNode:self];
    
	CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
    
	[self panForTranslation:translation];
}

- (void)panForTranslation:(CGPoint)translation {
    CGPoint position = [_draggedNode position];
    if([[_draggedNode name] isEqualToString: @"player"]) {
        [_draggedNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
    }
}

-(void)touchesEnded:(NSSet*) touches withEvent:(UIEvent*) event {
    self.draggedNode = nil;
}



@end
