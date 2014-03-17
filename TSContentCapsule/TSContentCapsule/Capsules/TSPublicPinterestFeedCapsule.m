//
//  TSPublicPinterestFeedCapsule.m
//  TSContentCapsule
//
//  Created by Labs on 3/16/14.
//  Copyright (c) 2014 Tsubasa. All rights reserved.
//

#import "TSPublicPinterestFeedCapsule.h"
#import "TSContentCapsuleManager.h"

@implementation TSPublicPinterestFeedCapsule{
    NSString *_username;
    NSArray *_photos;
    id _delegate;
}

+(id) queueFeedWithDelegate:(id<TSPublicPinterestFeedCapsuleDelegate>)delegate user:(NSString *)username{
    TSPublicPinterestFeedCapsule *capsule = [[TSPublicPinterestFeedCapsule alloc] initWithDelegate:delegate
                                                                                              user:username];
    [[TSContentCapsuleManager sharedManager] addCapsuleInQueue:capsule];
    return [capsule autorelease];
}

-(id) initWithDelegate:(id) delegate user:(NSString *)username{
    self = [super init];
    if (self) {
        _delegate = [delegate retain];
        _username = [username retain];
    }
    return self;
}

-(void) fire{
    
    // get Pinterest data
    // and parse document as a NSDictionary
    NSError *readError      = nil;
    NSString *user          = _username && ![_username isEqualToString:@""] ? _username : @"pinterest";
    NSString *feedURLString = [PINTEREST_API_URL stringByReplacingOccurrencesOfString:@"[user]"
                                                                           withString:user];
    NSData *contentData     = [NSData dataWithContentsOfURL:[NSURL URLWithString:feedURLString]];
    
    if(contentData){
        NSDictionary *document = [NSJSONSerialization JSONObjectWithData:contentData
                                                            options:NSJSONReadingAllowFragments
                                                              error:&readError];
        
        if(readError){
            NSLog(@"error: %@", readError);
        }else{
            
            // loop into the document, getting all the medias available
            NSArray *items = [[document objectForKey:@"data"] objectForKey:@"pins"];
            NSMutableArray *response = [NSMutableArray array];
            for (NSDictionary *aItem in items) {
                NSString *mediaURL = [[[aItem objectForKey:@"images"] objectForKey:@"237x"] objectForKey:@"url"];
                if(mediaURL) [response addObject:mediaURL];
            }
            
            //save for later
            [_photos release], _photos = nil;
            _photos = [[NSArray alloc] initWithArray:response];
        }
    }
}

-(void) conclude{
    [_delegate publicPinterestFeed:self didGetPhotos:_photos];
}

- (void)dealloc{
    [_delegate release], _delegate = nil;
    [_username release], _username = nil;
    [_photos release], _photos = nil;
    [super dealloc];
}

@end
