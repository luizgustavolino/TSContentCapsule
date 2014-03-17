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
    NSMutableArray *runningCapsules;
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
    [runningCapsules release], runningCapsules = nil;
    [super dealloc];
}

// Build an array of threads, each one with a unique NSCondition
// after that call 'start' on everyone
- (id)initWithThreadCount:(int) howManyThreads{
    self = [super init];
    if (self) {
        
        capsulesQueue   = [[NSMutableArray alloc] init];
        runningCapsules = [[NSMutableArray alloc] init];
        threads         = [[NSMutableArray alloc] initWithCapacity:howManyThreads];
        
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

#pragma mark - capsule management: add

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

#pragma mark - capsule management: discard


-(void) discardQueuedCapsules:(NSDictionary*) filter{
    [self discardQueuedCapsules:filter queue:runningCapsules];
    [self discardQueuedCapsules:filter queue:capsulesQueue];
}

-(void) discardQueuedCapsules:(NSDictionary*) filter queue:(NSMutableArray*) queue{
    
    // loop each filter, each capsule queued
    // saving garabage to discard latter
    @synchronized(queue){
        
        // Get one item
        NSMutableArray *garbage = [NSMutableArray array];
        for (NSString *aKey in filter) {
            for (TSContentCapsuleItem *aItem in queue) {
                id value = [filter objectForKey:aKey];
                
                // and then check filters
                if([aKey isEqualToString:kCCCapsuleClass]){
                    if([aItem isKindOfClass:(Class)value]) [garbage addObject:aItem];
                }
                
            }
        }
        
        // dispose gargabe
        if(garbage.count) [queue removeObjectsInArray:garbage];
        
    }
}

#pragma mark - capsule management: run

// check if there is a capsule queued, if so then fire that capsule
// loop until the thread is cancelled
-(void) runLoop{
    
    TSContentCapsuleThread *aThread = (TSContentCapsuleThread*)[NSThread currentThread];
    TSContentCapsuleItem *nextItem = nil;
    BOOL sleep;
    
    do{
        
        sleep = NO;
        
        @autoreleasepool {
            
            // pick a capsule
            @synchronized(capsulesQueue){
                nextItem = [[capsulesQueue firstObject] retain];
                [capsulesQueue removeObject:nextItem];
            }
            
            // fire that capsule
            if(nextItem){

                @synchronized(runningCapsules){
                    [runningCapsules addObject:nextItem];
                }
                
                if(!nextItem.discarded) [nextItem fire];
                if(!nextItem.discarded) [nextItem performContextualConclude];
                
                @synchronized(runningCapsules){
                    [runningCapsules removeObject:nextItem];
                }
                
                [nextItem release];
            }
            
            // sleep
            @synchronized(capsulesQueue){
                if(!capsulesQueue.count) sleep = YES;
            }
            
        }
        
        if(sleep) [aThread sleep];
        
    }while (![NSThread currentThread].isCancelled);
}

@end
