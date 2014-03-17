//
//  TSDownloadImageCapsule.m
//  TSContentCapsule
//
//  Created by Labs on 3/16/14.
//  Copyright (c) 2014 Tsubasa. All rights reserved.
//

#import "TSDownloadImageCapsule.h"
#import "TSContentCapsuleManager.h"

@implementation TSDownloadImageCapsule{
    UIImage *_image;
}

+(id) queueDownloadWithImageView:(UIImageView*) imageView url:(NSURL*) imageURL{
    TSDownloadImageCapsule *capsule = [[TSDownloadImageCapsule alloc] initWithImageView:imageView url:imageURL];
    [[TSContentCapsuleManager sharedManager] addCapsuleInQueue:capsule];
    return [capsule autorelease];
}

-(id) initWithImageView:(UIImageView*) imageView url:(NSURL*) imageURL{
    self = [super init];
    if (self) {
        // save for later
        _imageURL = [imageURL retain];
        _imageView = [imageView retain];
    }
    return self;
}

-(void) fire{
    
    // just load data inline from the URL, the 'fire' selector runs inside a
    // background thread, with a autoreleasepool already in place
    NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
    
    if(imageData){
        // release the old image first, to prevent a memory leak
        [_image release], _image = nil;
        _image = [[UIImage imageWithData:imageData] retain];
    }
}

-(void) conclude{
    
    // conclude is always called from the thread that start the capsule
    // in this case, the main thread, so we update the interface here
    self.imageView.image = _image;
}

- (void)dealloc{
    [_image release], _image = nil;
    [_imageView release], _imageView = nil;
    [_imageURL release], _imageURL = nil;
    [super dealloc];
}

@end
