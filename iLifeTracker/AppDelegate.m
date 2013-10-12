


#import "AppDelegate.h"
#import "SettingViewController.h"
#import "TrackViewController.h"
#import "TrackerCustomCell.h"

#define TabBarNOTIFICATIONNAME  @"tabbarNotification"
#define CELLIMGVIEW @"imageView"
#define CELLCOUNTER @"counter"
#define CELLSTRTDATE @"startDate"
#define CELLSTOREDATE @"storeDate"
#define CELLPAUSECOUNT @"pauseCount"
#define CELLTIMER @"cellTimer"
#define CELLINDEXNO @"cellindex"
@implementation UINavigationController (Rotation)
- (BOOL)shouldAutorotate
{
    
    BOOL result = self.topViewController.shouldAutorotate;
    
    return result;
}
- (NSUInteger)supportedInterfaceOrientations
{
    
    NSUInteger result = self.topViewController.supportedInterfaceOrientations;
    return result;
}
@end

@implementation AppDelegate
@synthesize window = _window ,appInBckgdBoolDisappear ;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // Override point for customization after application launch.
    _objTrackerRootViecController = [[TrackerRootViewController alloc] initWithNibName:@"TrackerRootViewController" bundle:nil];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:_objTrackerRootViecController];
    
    self.window.rootViewController = _navigationController;
    [self.window makeKeyAndVisible];
    
    DataBaseController *obj = [DataBaseController DBControllerharedInstance];
    
    NSMutableArray  *myLifeInfoArray = [obj trackerDetail];
    if ([myLifeInfoArray count] == 0) {
        [obj addDefaultTracker];
    }

    return YES;
}





-(UINavigationController *) mainNavigationController
{
   return _navigationController;
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    SettingViewController *obj = [SettingViewController shareInstanceSetting];
   
    UIAlertView *alertView;
    NSString *string = [NSString stringWithFormat:@"%@", notification.alertBody];
    

    if (!obj.ntfBoolValue) {     
        if([string length] < 50){
            
            NSString *bfrPrtg;
            NSString *aftPrtg;
            @try{
           NSArray *array = [string componentsSeparatedByString:@"%%"]; 
           bfrPrtg = [array objectAtIndex:0];
           aftPrtg = [array objectAtIndex:1];
            }@catch (NSException *e) {
            }
            NSString *str = [bfrPrtg stringByAppendingString:@" % "];
            NSString *str1 = [str stringByAppendingString:aftPrtg];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ALARM"];
            
            alertView = [[UIAlertView alloc] initWithTitle:@"Running Tracker"
                                                        message:str1
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
            [alertView show]; 
            alertView = nil;
        }
        else
        {
            UIAlertView *sendMessage = [[UIAlertView alloc] initWithTitle:@"Running Tracker" message:string delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
            trackerId = notification.soundName;
            [sendMessage show];
            
        }
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if(buttonIndex == 0)
    {   
    } 
    else if(buttonIndex == 1)
    {
        TrackViewController  * objTrack= [TrackViewController TrackSharedInstance]; 
        
        for (TrackerCustomCell *trackerCellObj in objTrack._customCellObjArry) {
            if ([trackerCellObj._trackerSessionId isEqualToString:trackerId] && trackerCellObj.isRunning) {
                [trackerCellObj   stopRunningTracker];
    }
  }
 }
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    if(!appInBckgdBoolDisappear){

    }

 
}



-(void) runningCellWillDisappear{
    TrackViewController  * objTrack= [TrackViewController TrackSharedInstance]; 
    
    for (int i =0; i< [objTrack._customCellObjArry count]; i++) {
        TrackerCustomCell *obj = [objTrack._customCellObjArry objectAtIndex:i];
         NSLog(@" app delegate running tracker :-> %i ", obj.isRunning);
        if (obj.isRunning) {
            NSLog(@" app delegate running tracker :-> %@",[NSString stringWithFormat:@"%i",obj.pauseIdentify]);
            DataBaseController *obj1 = [DataBaseController DBControllerharedInstance];
            
            [obj1 updateTrackerCurentSetionTimeCounter:[NSString stringWithFormat:@"%i",obj.timeCounter]  startDate:obj._startDateTime stroeDate:obj._storeStartDateTime pauseCounter:[NSString stringWithFormat:@"%i",obj.pauseCounter] indexNo:[NSString stringWithFormat:@"%i",i] pauseIdentify:[NSString stringWithFormat:@"%i",obj.pauseIdentify] runIdentify:@"1" trackerName:[obj._trackerSessionId intValue]];
        }
    }
        

}

- (void)applicationWillResignActive:(UIApplication *)application
{
 
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
 
}

@end

