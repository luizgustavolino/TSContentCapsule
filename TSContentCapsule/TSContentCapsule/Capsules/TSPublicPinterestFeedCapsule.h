//
//  TSPublicPinterestFeedCapsule.h
//  TSContentCapsule
//
//  Created by Labs on 3/16/14.
//  Copyright (c) 2014 Tsubasa. All rights reserved.
//

#import "TSContentCapsuleItem.h"

#define PINTEREST_API_URL @"http://widgets.pinterest.com/v3/pidgets/users/[user]/pins/"

@class TSPublicPinterestFeedCapsule;

// this protocol tells what this capsules offers as result
// in this case, a array of photos URLs
@protocol TSPublicPinterestFeedCapsuleDelegate <NSObject>

    @optional
    -(void) publicPinterestFeed:(TSPublicPinterestFeedCapsule*) capsule didGetPhotos:(NSArray*) items;
    -(void) publicPinterestFeed:(TSPublicPinterestFeedCapsule*) capsule failWithError:(NSString*) errorMessage;

@end


@interface TSPublicPinterestFeedCapsule : TSContentCapsuleItem

+(id) queueFeedWithDelegate:(id<TSPublicPinterestFeedCapsuleDelegate>) delegate user:(NSString*) username;
-(id) initWithDelegate:(id<TSPublicPinterestFeedCapsuleDelegate>) delegate user:(NSString*) username;

@end
