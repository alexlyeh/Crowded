//
//  CrowdedData.m
//  Crowded
//
//  Created by Alex Yeh on 6/15/14.
//  Copyright (c) 2014 Alex Yeh. All rights reserved.
//

#import "CrowdedData.h"

@implementation CrowdedData
@synthesize score;

+ (id)sharedManager {
    static CrowdedData *crowdedData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        crowdedData = [[self alloc] init];
        
    });
    return crowdedData;
}

//Initialize and allocate any variables declared.
- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

@end
