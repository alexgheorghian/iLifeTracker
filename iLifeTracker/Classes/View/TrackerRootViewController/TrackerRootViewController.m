//
//  TrackerRootViewController.m
//  iLifeTracker
//
//  Created by Umesh on 24/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrackerRootViewController.h"
#import "AppDelegate.h"
#import "CustomNavigationController.h"
@implementation TrackerRootViewController
@synthesize trackerTabbarController;
@synthesize window = _window ;
#pragma mark - View lifecycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
      [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(ifileTrackerLoginPage) userInfo:nil repeats:NO];
    
    spinner.transform = CGAffineTransformMakeScale(1, 1);
    
    //[spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleB];
   //spinner.center = CGPointMake(160,240);
    [spinner startAnimating];
    
    
//    NSMutableArray *cellobj = [[NSUserDefaults standardUserDefaults]  objectForKey:TRACKCELLOBJARRAY];
//    for ( NSMutableDictionary* dict in cellobj){
//    NSLog(@"Root : runningCellWillAppear:  nsuserdefault :-> %@ ",dict);
//    }
}


-(void) ifileTrackerLoginPage{
    [spinner stopAnimating];
   // LoginViewController    *objLoginViewController;
   // objLoginViewController = [[LoginViewController alloc] init];
    //[self.navigationController pushViewController:objLoginViewController animated:YES];
    
   // CommonTabbar *obj = [CommonTabbar CommonTabbarSharedInstance];
    //[obj addCustomTabbar];
    
    
    
     trackerTabbarController = [iLifeTrackerTabbar tabBarShareInstance];
       UIViewController *objMyLife = [[MyLifeViewController alloc] initWithNibName:@"MyLifeViewController" bundle:nil];
    CustomNavigationController  *_objMyLifeNavigation    =   [[CustomNavigationController alloc] initWithRootViewController:objMyLife];

    UIViewController *objGraph = [[GraphViewController alloc] initWithNibName:@"GraphViewController" bundle:nil];
    CustomNavigationController *_objGraphNavigation    =   [[CustomNavigationController alloc] initWithRootViewController:objGraph];
    
    
    UIViewController *objTrack=[TrackViewController TrackSharedInstance];
    CustomNavigationController *_objTackNavigation  =  [[CustomNavigationController alloc] initWithRootViewController:objTrack];
    
    
    UIViewController *objReward=[RewardViewController shareInstanceReward];
     CustomNavigationController  *_objRewardNavigation    =   [[CustomNavigationController alloc] initWithRootViewController:objReward];
    
    UIViewController *objSetting=[SettingViewController shareInstanceSetting];
     CustomNavigationController  *_objSettingNavigation    =   [[CustomNavigationController alloc] initWithRootViewController:objSetting];
   
    
   
   trackerTabbarController.viewControllers = [NSArray arrayWithObjects: _objMyLifeNavigation,_objGraphNavigation ,_objTackNavigation,_objRewardNavigation,_objSettingNavigation, nil];
    
    self.window = (UIWindow*)[[UIApplication sharedApplication].windows objectAtIndex:0];
    //self.window.rootViewController = self.trackerTabbarController;
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    UINavigationController *nav = [app mainNavigationController];
    [nav.view removeFromSuperview];
    self.window.rootViewController = nil;
    //[self.window addSubview:trackerTabbarController.view];
    self.window.rootViewController = trackerTabbarController;
    
}


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
//{
//    //self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//    return YES;
//    
//    
//}

@end
