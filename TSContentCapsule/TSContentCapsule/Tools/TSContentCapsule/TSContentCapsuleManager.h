//
//  TSContentCapsuleManager.h
//  TSContentCapsule
//
//  Created by Labs on 3/16/14.
//  Copyright (c) 2014 Tsubasa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSContentCapsuleThread.h"
#import "TSContentCapsuleItem.h"

// discardQueuedCapsules keys:
#define kCCCapsuleClass @"kCCCapsuleClass"



@interface TSContentCapsuleManager : NSObject

+(id) bootstrapWithThreadCount:(int) howManyThreads;
+(id) sharedManager;
+(void) destroy;

-(void) addCapsuleInQueue:(TSContentCapsuleItem*) item;
-(void) discardQueuedCapsules:(NSDictionary*) filter;

@end
