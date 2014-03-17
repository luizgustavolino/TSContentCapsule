//
//  TSContentCapsuleItem.h
//  TSContentCapsule
//
//  Created by Labs on 3/16/14.
//  Copyright (c) 2014 Tsubasa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSContentCapsuleItem : NSObject

@property (readonly, retain) NSThread *contextThread;
@property (readonly) BOOL discarded;

// when extending this class, implement this two:
// - fire: do your background work, the UI won't be blocked by any code writen here
// - conclude: use this to return results to delegate, because it will be called
// by the same thread that allocate this capsule
-(void) fire;
-(void) conclude;

// called by the content capsule manager
-(void) performContextualConclude;
-(void) discard;

@end
