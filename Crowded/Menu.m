//
//  Menu.m
//  Crowded
//
//  Created by Alex Yeh on 6/14/14.
//  Copyright (c) 2014 Alex Yeh. All rights reserved.
//

#import "Menu.h"
#import "MyScene.h"
#import "Help.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@implementation Menu

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        NSString *nextSceneButton;
        nextSceneButton = @"Start";
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"GAMECUBENDualSet"];
        SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"GAMECUBENDualSet"];
        SKLabelNode *help = [SKLabelNode labelNodeWithFontNamed:@"GAMECUBENDualSet"];
        SKLabelNode *credit = [SKLabelNode labelNodeWithFontNamed:@"GAMECUBENDualSet"];
        
        myLabel.text = nextSceneButton;
        myLabel.fontSize = 18;
        myLabel.fontColor = [SKColor blackColor];
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 20);
        myLabel.name = @"scene button";
        
        title.text = @"CROWDED";
        title.fontSize = 30;
        title.fontColor = [SKColor blackColor];
        title.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 20);
        
        help.text = @"Help";
        help.fontSize = 18;
        help.fontColor = [SKColor blackColor];
        help.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 60);
        help.name = @"help button";
        
        credit.text = @"Created By: Alex Yeh";
        credit.fontSize = 10;
        credit.fontColor = [SKColor blackColor];
        credit.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 150);

        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"CrowdedSong" ofType:@"m4a"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        player.numberOfLoops = -1;
        
        [player play];
        
        [self addChild: title];
        [self addChild: myLabel];
        [self addChild: help];
        [self addChild: credit];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString: @"scene button"]) {
        
        SKTransition *reveal = [SKTransition fadeWithDuration:2];
        
        MyScene *scene = [MyScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
    }
    
    if ([node.name isEqualToString: @"help button"]) {
        SKTransition *reveal = [SKTransition fadeWithDuration:2];
        
        Help *scene = [Help sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
    }
}


@end
