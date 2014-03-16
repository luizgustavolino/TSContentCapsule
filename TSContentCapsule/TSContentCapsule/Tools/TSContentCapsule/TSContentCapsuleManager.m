//
//  TSContentCapsuleManager.m
//  TSContentCapsule
//
//  Created by Labs on 3/16/14.
//  Copyright (c) 2014 Tsubasa. All rights reserved.
//

#import "TSContentCapsuleManager.h"

#pragma mark - private
@interface TSContentCapsuleManager (/*private*/){
    NSMutableArray *threads;
    NSMutableArray *capsulesQueue;
}

@end

#pragma mark - singleton lifecycle
static TSContentCapsuleManager *_tssingleton = nil;

@implementation TSContentCapsuleManager

+(id) sharedManager{
    return _tssingleton;
}

+(id) bootstrapWithThreadCount:(int) howManyThreads{
    if(!_tssingleton) _tssingleton = [[TSContentCapsuleManager alloc] initWithThreadCount:howManyThreads];
    return _tssingleton;
}

+(void) destroy{
    [_tssingleton release], _tssingleton = nil;
}

- (void)dealloc{
    [threads release], threads = nil;
    [capsulesQueue release], capsulesQueue = nil;
    [super dealloc];
}

// Build an array of threads, each one with a unique NSCondition
// after that call 'start' on everyone
- (id)initWithThreadCount:(int) howManyThreads{
    self = [super init];
    if (self) {
        
        capsulesQueue = [[NSMutableArray alloc] init];
        threads = [[NSMutableArray alloc] initWithCapacity:howManyThreads];
        
        for (int i = 0, max = howManyThreads; i < max; i++) {
            TSContentCapsuleThread *aThread = [[TSContentCapsuleThread alloc] initWithTarget:self
                                                                                    selector:@selector(runLoop)
                                                                                      object:nil];
            [aThread attachLock:[[NSCondition new] autorelease]];
            [threads addObject:aThread];
            [aThread release], aThread = nil;
        }
        
        [threads makeObjectsPerformSelector:@selector(start)];
        
    }
    return self;
}

#pragma mark - capsule management
// add capsule into queue
// and then wakeup sleeping threads to see if any of than can take this job
-(void) addCapsuleInQueue:(TSContentCapsuleItem*) item{
    @synchronized(capsulesQueue){
        [capsulesQueue addObject:item];
    }
    @synchronized(threads){
        [threads makeObjectsPerformSelector:@selector(wakeup)];
    }
}

// check if there is a capsule queued, if so then fire that capsule
// loop until the thread is cancelled
-(void) runLoop{
    
    TSContentCapsuleThread *aThread = (TSContentCapsuleThread*)[NSThread currentThread];
    
    do{
        
        TSContentCapsuleItem *nextItem = nil;
        @synchronized(capsulesQueue){
            if(capsulesQueue.count){
                nextItem = [[capsulesQueue firstObject] retain];
                [capsulesQueue removeObjectAtIndex:0];
            }
        }
        
        [nextItem fire];
        [nextItem performSelector:@selector(conclude) onThread:nextItem.contextThread
                       withObject:nil waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
        
        [nextItem release];
        
        BOOL sleep = NO;
        @synchronized(capsulesQueue){
            if(!capsulesQueue.count) sleep = YES;
        }
        
        if(sleep) [aThread sleep];
        
    }while (![NSThread currentThread].isCancelled);
}

@end
