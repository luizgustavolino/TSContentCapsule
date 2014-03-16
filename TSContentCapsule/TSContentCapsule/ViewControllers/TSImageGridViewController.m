//
//  TSImageGridViewController.m
//  TSContentCapsule
//
//  Created by Labs on 3/16/14.
//  Copyright (c) 2014 Tsubasa. All rights reserved.
//

#import "TSImageGridViewController.h"

@implementation TSImageGridViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadPins];
}

-(IBAction) loadPins{
    [TSPublicPinterestFeedCapsule queueFeedWithDelegate:self user:self.uiPinUsername.text];
    [self.uiPinUsername resignFirstResponder];
}

-(void) publicPinterestFeed:(TSPublicPinterestFeedCapsule *)capsule didGetPhotos:(NSArray *)items{
    
    // configure space / tile size
    int thumbsPerLine       = 5;
    int topMargin           = 40;
    CGSize containerSize    = self.uiScrollview.frame.size;
    CGSize thumbSize        = CGSizeMake(containerSize.width/thumbsPerLine, containerSize.width/thumbsPerLine);
    
    // remove old tiles
    if(!tiles) tiles = [[NSMutableArray alloc] init];
    [tiles makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [tiles removeAllObjects];
    
    // loop getting each tile url
    for (int i = 0, max = items.count; i < max; i++) {
        
        // build a tile and add as a scrolview subview
        CGRect tileFrame        = CGRectMake(thumbSize.width*(i%thumbsPerLine),
                                             topMargin+(i/thumbsPerLine)*thumbSize.height,
                                             thumbSize.width, thumbSize.height);
        UIImageView *tile       = [[UIImageView alloc] initWithFrame:tileFrame];
        tile.backgroundColor    = [UIColor colorWithWhite:0.8+(arc4random()%10)/100.0 alpha:1.0];
        tile.contentMode        = UIViewContentModeScaleAspectFill;
        tile.clipsToBounds      = YES;
        
        // queue the image download
        NSURL *imageURL = [NSURL URLWithString:[items objectAtIndex:i]];
        [TSDownloadImageCapsule queueDownloadWithImageView:tile url:imageURL];
        
        // add tile and do memory management
        [self.uiScrollview addSubview:tile];
        [tiles addObject:tile];
        [tile release], tile = nil;
    }
    
    CGSize contentSize = CGSizeMake(containerSize.width,
                                    topMargin+ceil(items.count/(float)thumbsPerLine)*thumbSize.height);
    [self.uiScrollview setContentSize:contentSize];
    
}


@end
