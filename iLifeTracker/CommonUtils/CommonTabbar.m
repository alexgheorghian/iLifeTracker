//
//  CommonTabbar.m
//  iLifeTracker
//
//  Created by Umesh on 26/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommonTabbar.h"

@implementation CommonTabbar

static  CommonTabbar *_objCommonTabbar;
+(CommonTabbar *) CommonTabbarSharedInstance{
    
    if (_objCommonTabbar == nil) {
        _objCommonTabbar = [[CommonTabbar alloc] init];
    }
    
 return _objCommonTabbar;
}


-(void) addCustomTabbar{
    MyLifeViewController *objMyLife     =   [[MyLifeViewController alloc] init];
    GraphViewController  *objGraph      =   [[GraphViewController alloc] init];
    
    TrackViewController  *objTrack      =   [[TrackViewController alloc] init];
    _objTrackerNavigation               =   [[UINavigationController alloc] initWithRootViewController:objTrack];
    
    RewardViewController *objReward     =   [[RewardViewController alloc] init];
    SettingViewController *objSeting    =   [[SettingViewController alloc] init];
    
    _objCustomTab                       =   [[CustomTabbar alloc] init];
    
    _objCustomTab.viewControllers     = [NSMutableArray arrayWithObjects: objMyLife,objGraph,_objTrackerNavigation,objReward,objSeting , nil];
    
    UIWindow *window = (UIWindow*)[[UIApplication sharedApplication].windows objectAtIndex:0];
   window.rootViewController =  _objCustomTab;
    
    //[window addSubview:_objCustomTab.view];
}


@end
