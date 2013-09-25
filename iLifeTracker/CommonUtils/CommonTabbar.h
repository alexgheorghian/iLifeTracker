//
//  CommonTabbar.h
//  iLifeTracker
//
//  Created by Umesh on 26/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomTabbar.h"
#import "GraphViewController.h"
#import "MyLifeViewController.h"
#import "RewardViewController.h"
#import "SettingViewController.h"
#import "TrackViewController.h"


@interface CommonTabbar : NSObject {
    CustomTabbar *_objCustomTab;
    UINavigationController *_objTrackerNavigation;
}

-(void) addCustomTabbar;
+(CommonTabbar *) CommonTabbarSharedInstance;

@end
