
//  Created by Adrian  
//  Copyright (c) 2013 3rd Floor Software Solutions Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackerRootViewController.h"
#import "DataBaseController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    UINavigationController    *_navigationController;
    TrackerRootViewController *_objTrackerRootViecController; 
    bool appInBckgdBoolDisappear;
    NSDate *_runningDate;
    NSDate *_EndDate;
    NSString *trackerId;

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic)  bool appInBckgdBoolDisappear;

-(UINavigationController *) mainNavigationController;
-(void) runningCellWillDisappear;
@end
