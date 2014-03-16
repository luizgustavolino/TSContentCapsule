//
//  TSDownloadImageCapsule.h
//  TSContentCapsule
//
//  Created by Labs on 3/16/14.
//  Copyright (c) 2014 Tsubasa. All rights reserved.
//

#import "TSContentCapsuleItem.h"

@interface TSDownloadImageCapsule : TSContentCapsuleItem

@property (nonatomic, readonly) UIImageView* imageView;
@property (nonatomic, readonly) NSURL* imageURL;

+(id) queueDownloadWithImageView:(UIImageView*) imageView url:(NSURL*) imageURL;
-(id) initWithImageView:(UIImageView*) imageView url:(NSURL*) imageURL;

@end
