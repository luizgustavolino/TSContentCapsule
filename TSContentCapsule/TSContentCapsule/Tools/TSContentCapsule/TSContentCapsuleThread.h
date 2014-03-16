//
//  TSContentCapsuleThread.h
//  TSContentCapsule
//
//  Created by Labs on 3/16/14.
//  Copyright (c) 2014 Tsubasa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSContentCapsuleThread : NSThread

@property (readonly) NSCondition *lock;

-(void) attachLock:(NSCondition*) aLock;
-(void) sleep;
-(void) wakeup;

@end
