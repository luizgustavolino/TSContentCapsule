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

+(id) capsule;

-(void) fire;
-(void) conclude;
-(void) discard;

@end
