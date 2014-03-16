//
//  TSContentCapsuleItem.m
//  TSContentCapsule
//
//  Created by Labs on 3/16/14.
//  Copyright (c) 2014 Tsubasa. All rights reserved.
//

#import "TSContentCapsuleItem.h"

@implementation TSContentCapsuleItem

+(id) capsule{
    return [[[TSContentCapsuleItem alloc] init] autorelease];
}

- (id)init{
    self = [super init];
    if (self) {
        _contextThread = [[NSThread currentThread] retain];
    }
    return self;
}

-(void) fire{ /* STUB */ }
-(void) conclude{ /* STUB */ }
-(void) discard{ /* STUB */ }

- (void)dealloc{
    
    @synchronized(_contextThread){
        [_contextThread release], _contextThread = nil;
    }
    
    [super dealloc];
}

@end
