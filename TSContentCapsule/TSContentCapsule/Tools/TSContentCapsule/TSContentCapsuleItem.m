//
//  TSContentCapsuleItem.m
//  TSContentCapsule
//
//  Created by Labs on 3/16/14.
//  Copyright (c) 2014 Tsubasa. All rights reserved.
//

#import "TSContentCapsuleItem.h"

@implementation TSContentCapsuleItem

- (id)init{
    self = [super init];
    if (self) {
        _contextThread  = [[NSThread currentThread] retain];
        _discarded      = NO;
    }
    return self;
}

-(void) fire{ /* STUB */ }
-(void) conclude{ /* STUB */ }


-(void) performContextualConclude{
    [self performSelector:@selector(conclude) onThread:self.contextThread
               withObject:nil waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
}

-(void) discard{
    _discarded = YES;
}

- (void)dealloc{
    
    @synchronized(_contextThread){
        [_contextThread release], _contextThread = nil;
    }
    
    [super dealloc];
}

@end
