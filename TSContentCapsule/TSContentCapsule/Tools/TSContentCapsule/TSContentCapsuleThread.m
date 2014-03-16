//
//  TSContentCapsuleThread.m
//  TSContentCapsule
//
//  Created by Labs on 3/16/14.
//  Copyright (c) 2014 Tsubasa. All rights reserved.
//

#import "TSContentCapsuleThread.h"
#import "TSContentCapsuleManager.h"

@implementation TSContentCapsuleThread

-(void) attachLock:(NSCondition*) aLock{
    if(!_lock) _lock = [aLock retain];
}

- (void)dealloc{
    [_lock release], _lock = nil;
    [super dealloc];
}

-(void) sleep{
    [self.lock lock];
    [self.lock wait];
    [self.lock unlock];
}

-(void) wakeup{
    [self.lock lock];
    [self.lock signal];
    [self.lock unlock];
}

@end
