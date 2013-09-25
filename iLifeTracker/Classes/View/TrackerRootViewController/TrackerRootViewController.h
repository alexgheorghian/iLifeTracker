//
//  TrackerRootViewController.h
//  iLifeTracker
//
//  Created by Umesh on 24/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

#import "GraphViewController.h"
#import "MyLifeViewController.h"
#import "RewardViewController.h"
#import "SettingViewController.h"
#import "TrackViewController.h"
#import "iLifeTrackerTabbar.h"

@interface TrackerRootViewController : UIViewController{
  IBOutlet  UIActivityIndicatorView  *spinner;
    
    iLifeTrackerTabbar *trackerTabbarController;
    
    UIWindow *window;
}

@property (nonatomic , retain) iLifeTrackerTabbar *trackerTabbarController;

@property (strong, nonatomic) UIWindow *window;
@end
