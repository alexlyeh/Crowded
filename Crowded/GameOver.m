//
//  GameOver.m
//  Crowded
//
//  Created by Alex Yeh on 6/15/14.
//  Copyright (c) 2014 Alex Yeh. All rights reserved.
//

#import "GameOver.h"
#import "MyScene.h"
#import "Menu.h"
#import "CrowdedData.h"

@implementation GameOver

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        CrowdedData *crowdedData = [CrowdedData sharedManager];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *highScore = [defaults objectForKey: @"high score"];
        
        if(highScore == nil){
            highScore = [NSNumber numberWithInt: crowdedData.score];
        }
        
        if([highScore intValue] < crowdedData.score){
            highScore = [NSNumber numberWithInt: crowdedData.score];
        }
        
        [defaults setValue: highScore forKey: @"high score"];
        
        SKLabelNode *game = [SKLabelNode labelNodeWithFontNamed:@"GAMECUBENDualSet"];
        SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"GAMECUBENDualSet"];
        SKLabelNode *menu = [SKLabelNode labelNodeWithFontNamed:@"GAMECUBENDualSet"];
        SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"GAMECUBENDualSet"];
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"GAMECUBENDualSet"];
        
        game.text = @"Restart";
        game.fontSize = 18;
        game.fontColor = [SKColor blackColor];
        game.position = CGPointMake(CGRectGetMidX(self.frame) - 50, CGRectGetMidY(self.frame) - 100);
        game.name = @"game button";
        
        title.text = @"GAME OVER";
        title.fontSize = 25;
        title.fontColor = [SKColor blackColor];
        title.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 100);
        
        menu.text = @"Menu";
        menu.fontSize = 18;
        menu.fontColor = [SKColor blackColor];
        menu.position = CGPointMake(CGRectGetMidX(self.frame) + 60, CGRectGetMidY(self.frame) - 100);
        menu.name = @"menu button";
        
        highScoreLabel.text = [NSString stringWithFormat: @"High Score: %i", [highScore intValue]];
        highScoreLabel.fontSize = 18;
        highScoreLabel.fontColor = [SKColor blackColor];
        highScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 20);
        
        scoreLabel.text = [NSString stringWithFormat: @"Score: %i", crowdedData.score];
        scoreLabel.fontSize = 18;
        scoreLabel.fontColor = [SKColor blackColor];
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 20);
        scoreLabel.name = @"game button";
        
        
        [self addChild: title];
        [self addChild: menu];
        [self addChild: game];
        [self addChild: scoreLabel];
        [self addChild: highScoreLabel];

        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString: @"game button"]) {
        
        SKTransition *reveal = [SKTransition fadeWithDuration:2];
        
        MyScene *scene = [MyScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
    }
    
    if ([node.name isEqualToString: @"menu button"]) {
        SKTransition *reveal = [SKTransition fadeWithDuration:2];
        
        Menu *scene = [Menu sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
    }
}


@end
