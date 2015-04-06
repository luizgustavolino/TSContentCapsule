//
//  TSImageGridViewController.h
//  TSContentCapsule
//
//  Created by Labs on 3/16/14.
//  Copyright (c) 2014 Tsubasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSPublicPinterestFeedCapsule.h"
#import "TSContentCapsuleManager.h"
#import "TSDownloadImageCapsule.h"

@interface TSImageGridViewController : UIViewController<TSPublicPinterestFeedCapsuleDelegate, UITextFieldDelegate>{
    
}

@property (nonatomic, assign) IBOutlet UIScrollView *uiScrollview;
@property (nonatomic, assign) IBOutlet UITextField *uiPinUsername;

-(IBAction) loadPins;

@end
