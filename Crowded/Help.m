//
//  Help.m
//  Crowded
//
//  Created by Alex Yeh on 6/14/14.
//  Copyright (c) 2014 Alex Yeh. All rights reserved.
//

#import "Help.h"
#import "Menu.h"

@implementation Help

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
        SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"GAMECUBENDualSet"];
        SKLabelNode *instructions0 = [SKLabelNode labelNodeWithFontNamed:@"GAMECUBENDualSet"];
        SKLabelNode *instructions1 = [SKLabelNode labelNodeWithFontNamed:@"GAMECUBENDualSet"];
        SKLabelNode *instructions2 = [SKLabelNode labelNodeWithFontNamed:@"GAMECUBENDualSet"];
        SKLabelNode *back = [SKLabelNode labelNodeWithFontNamed:@"GAMECUBENDualSet"];
        
        title.text = @"HELP";
        title.fontSize = 25;
        title.fontColor = [SKColor blackColor];
        title.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 100);
        
        instructions0.text = @"Drag the small star to try to avoid the";
        instructions0.fontSize = 14;
        instructions0.fontColor = [SKColor blackColor];
        instructions0.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 20);
        
        instructions1.text = @"larger stars, which start following you";
        instructions1.fontSize = 14;
        instructions1.fontColor = [SKColor blackColor];
        instructions1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        instructions2.text = @"and growing bigger if you are too close.";
        instructions2.fontSize = 14;
        instructions2.fontColor = [SKColor blackColor];
        instructions2.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 20);

        back.text = @"RETURN TO MENU";
        back.fontSize = 16;
        back.fontColor = [SKColor blackColor];
        back.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 100);
        back.name = @"back button";
        
        [self addChild: title];
        [self addChild: instructions0];
        [self addChild: instructions1];
        [self addChild: instructions2];
        [self addChild: back];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString: @"back button"]) {
        
        SKTransition *reveal = [SKTransition fadeWithDuration:2];
        
        Menu *scene = [Menu sceneWithSize: self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
    }
}


@end
