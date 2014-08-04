//
//  CrowdedData.h
//  Crowded
//
//  Created by Alex Yeh on 6/15/14.
//  Copyright (c) 2014 Alex Yeh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrowdedData : NSObject {
    int score;
}
@property (nonatomic, assign) int score;
+ (id)sharedManager;

@end
