//
//  SettingViewController.m
//  iLifeTracker
//
//  Created by Umesh on 26/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"

#import "TrackViewController.h"
#import "TrackerCustomCell.h"

//#import "CQMFloatingController.h"
//#import "PopupViewController.h"

@implementation SettingViewController

@synthesize ntfBoolValue;
@synthesize bannerIsVisible;

static SettingViewController *objSetting;

+(SettingViewController *) shareInstanceSetting{
    if (objSetting == nil) {
        objSetting = [[SettingViewController alloc] init];
    }
    return objSetting;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
        self.tabBarItem.image = [UIImage imageNamed:@"settings"];
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
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
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *image = [UIImage imageNamed:NAVIGATIONBARIMGNAME];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [_notificationLabel setFont:[UIFont fontWithName:FONTNAME size:15]];
    [_aboutUsLabel setFont:[UIFont fontWithName:FONTNAME size:24]];
    _aboutUsTextView.backgroundColor = [UIColor clearColor];
     _aboutUsTextView.userInteractionEnabled = NO;
    ntfBoolValue =NO ;
    //
    
}


- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        banner.frame = CGRectOffset(banner.frame, 0, 50);
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // banner is visible and we move it out of the screen, due to connection issue
        banner.frame = CGRectOffset(banner.frame, 0, -50);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    // NSLog(@"Banner view is beginning an ad action");
    BOOL shouldExecuteAction = YES;
    if (!willLeave && shouldExecuteAction)
    {
        // stop all interactive processes in the app
        // [video pause];
        // [audio pause];
    }
    return shouldExecuteAction;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    // resume everything you've stopped
    // [video resume];
    // [audio resume];
}

-(void) viewWillAppear:(BOOL)animated{
    
    CommonUtilClass *commonObj = [CommonUtilClass CommonUtilSharedInstance];
    adView.backgroundColor = [UIColor clearColor];
    adView = [commonObj iADView];
    //adView.delegate = self;
    [self.view addSubview:adView];
    [self.view bringSubviewToFront:adView];
    
    //[self time];
    
//    DataBaseController *obj = [DataBaseController DBControllerharedInstance];
//    NSMutableArray *trackerDetail = [obj selectRewardData];
//        for (int i = 0; i < [trackerDetail count]; i++) {
//            RewardModel *objCategoryModel = [trackerDetail objectAtIndex:0];
//        NSLog(@"tracker detail for popupview :-> %@",objCategoryModel.categoryName);
//       }

  //  PopupViewController *demoViewController = [[PopupViewController alloc] init];
	
	// 2. Get shared floating controller
	//CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
	
	// 3. Show floating controller with specified content
	//UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
	//[floatingController showInView:[TrackViewController TrackSharedInstance].view
	//	 withContentViewController:demoViewController
		//				  animated:YES];
   
}

//-(void) time{
//    
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"HH:mm:ss a yyyy-MMM-dd"];
//    NSDate *myDate = [df dateFromString: @"23:59:40 PM 2013-Feb-04"];
//    
//    //NSLog(@"curent  %@",myDate);
//     NSString *start = [df stringFromDate:myDate];
//   // NSLog(@"end curent  %@",start);
//    
//    NSDate *Date = [df dateFromString: @"1:01:16 PM 2013-Feb-05"];
//    
//    //NSLog(@"curent  %@",myDate);
//    //NSString *end = [df stringFromDate:Date];
//    
//   // NSLog(@"end curent  %@",end);
//    
//   NSArray *sessionArr = [start componentsSeparatedByString:@":"]; 
//    int hours = [[sessionArr objectAtIndex:0] intValue];
//     NSLog(@"end curent  %i , %@",hours,sessionArr);
//    
//    int minute = [[sessionArr objectAtIndex:1] intValue];
//    NSLog(@"end curent  %i",minute);
//    
//    int counter = 24*60 - hours*60 - minute;
//    NSLog(@"Total time :->   %i",counter);
//}
//




-(IBAction)notificationOnAndOff:(id)sender{
  
        if (_notificationSwch.on) {
            [self setNotification];
            ntfBoolValue = NO;
        }else{
            
            ntfBoolValue = YES;
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
         //   NSLog(@" trackerAutoStop notification schelude :-> %@ ",[[UIApplication sharedApplication] scheduledLocalNotifications]);
           // NSLog(@" ************* trackerAutoStop ");
        }
    //UITextView
}

-(void) setNotification{
    
    TrackViewController *trackObj = [TrackViewController TrackSharedInstance];
    
    NSMutableArray *cellArray =  trackObj._customCellObjArry;
    
    for( TrackerCustomCell *trackerCellObj in cellArray ){
        
       // NSLog(@"tracker is runing :-> %i",trackerCellObj.isRunning);
        if (trackerCellObj.isRunning) {
            [self createNotificationSchedule:trackerCellObj.autoStopNotification autoStop:trackerCellObj.trackerAutoStop notificatinIdentifier:trackerCellObj.cellPuaseIdentifier pushIdentify:trackerCellObj.pauseIdentify trackerName:trackerCellObj._trackerNameLabel.text trackerSessionId:trackerCellObj._trackerSessionId trackerGoal:trackerCellObj.trackerGoal trackerAlarm:trackerCellObj.trackerAlarm alarmNotification:trackerCellObj.trackerNotification _totalTimeLabel:trackerCellObj._totalTimeLabel.text currentTime:trackerCellObj._startingTimeLabel.text];
        }
    }
    
}

-(void) createNotificationSchedule:(UILocalNotification *) autoStopNotification autoStop:(NSString *)trackerAutoStop notificatinIdentifier:(bool ) cellPuaseIdentifier pushIdentify:(bool) pauseIdentify trackerName:(NSString *) trackerName
                  trackerSessionId:(NSString *)_trackerSessionId trackerGoal:(NSString *) trackerGoal trackerAlarm:(NSString *) trackerAlarm alarmNotification:(UILocalNotification *)trackerNotification _totalTimeLabel:(NSString *) totalTime currentTime:(NSString *) currentTime {
    
    if (([trackerGoal intValue] != 0  ) && ([trackerAlarm intValue] != 0) && (!cellPuaseIdentifier && !pauseIdentify)) {
        
        //NSLog(@"  ************************************** trackerAlarm :-> %@   ", trackerGoal); 
        int notificationTime = (([trackerGoal intValue]*60*60) * [trackerAlarm intValue])/100 ;
        
        NSArray   *totalTimeArrTtl;
        NSString  *hoursTtl ;
        NSString  *minuteTtl ;
        NSString  *secondTtl ;
        int  totalRunTime = 0; 
        @try{
            totalTimeArrTtl = [totalTime componentsSeparatedByString:@":"]; 
            hoursTtl = [totalTimeArrTtl objectAtIndex:0];
            minuteTtl = [totalTimeArrTtl objectAtIndex:1];
            secondTtl = [totalTimeArrTtl objectAtIndex:2];
            // NSLog(@" hours :-> %i minute :-> %i  seconds :-> %i",[hours1 intValue],  [minute intValue],[second intValue]);
        }
        @catch (NSException *exception) {
            
        }
        totalRunTime = [hoursTtl intValue]*360 + [minuteTtl intValue]*60 + [secondTtl intValue];
        if(LOGS_ON)  NSLog(@"notificationTime :-> %i  runningtolalTime :-> %i",notificationTime,totalRunTime);
        if(totalRunTime < notificationTime){
            
            
            NSArray   *totalTimeArr;
            NSString  *hours1 ;
            NSString  *minute ;
            NSString  *second ;
            int  runningtolalTime1 = 0; 
            @try{
                NSArray   *totalTimeArr1 = [currentTime componentsSeparatedByString:@" "];
                
                NSString *str = [totalTimeArr1 objectAtIndex:1];
                
                totalTimeArr = [str componentsSeparatedByString:@":"]; 
                hours1 = [totalTimeArr objectAtIndex:0];
                minute = [totalTimeArr objectAtIndex:1];
                second = [totalTimeArr objectAtIndex:2];
                //  NSLog(@" Time :-> %@ hours :-> %i minute :-> %i  seconds :-> %i",str,[hours1 intValue],  [minute intValue],[second intValue]);
            }@catch (NSException *exception) {
                
            }
            
            runningtolalTime1 = [hours1 intValue]*3600 +  [minute intValue]*60 + [second intValue];
            
            if( (totalRunTime + runningtolalTime1) < notificationTime ){
            //if (trackerNotification != nil) trackerNotification = nil;
            int totalFireTime = notificationTime - totalRunTime - runningtolalTime1;
             // NSLog(@"total fire time :-> %i", totalFireTime);
            
            trackerNotification = [[UILocalNotification alloc] init];
            if (trackerNotification == nil) return;
            NSDate *fireTime = [[NSDate date] addTimeInterval:totalFireTime]; // adds  secs
            trackerNotification.fireDate = fireTime;
            //trackerNotification.soundName = UILocalNotificationDefaultSoundName;
            //trackerNotification.repeatInterval = 30;
            NSString *str =@"%%";
            trackerNotification.alertBody = [NSString stringWithFormat:@"You reached %@ %@ of your goal of %@ hours!",trackerAlarm,str,trackerGoal];
            [[UIApplication sharedApplication] scheduleLocalNotification:trackerNotification];
            }
        }
        
        //NSLog(@" percentage notification schelude :-> %@",[[UIApplication sharedApplication] scheduledLocalNotifications]);
        // NSLog(@" ************* alarm  protaction  ");
    }
    
    
    
    
    
    
    
    
    if (([trackerAutoStop  intValue] != 0)&& (!cellPuaseIdentifier && !pauseIdentify) ) {
        //NSLog(@"tracker auto stop protaction ");
        // int repeatNotificationTime =  ([trackerGoal intValue]*60)/ [trackerAutoStop intValue] ;
        
        
            
        
        NSArray   *totalTimeArr;
        NSString  *hours1 ;
        NSString  *minute ;
        NSString  *second ;
        int  runningtolalTime = 0; 
        @try{
            NSArray   *totalTimeArr1 = [currentTime componentsSeparatedByString:@" "];
            
            NSString *str = [totalTimeArr1 objectAtIndex:1];
            
            totalTimeArr = [str componentsSeparatedByString:@":"]; 
            hours1 = [totalTimeArr objectAtIndex:0];
            minute = [totalTimeArr objectAtIndex:1];
            second = [totalTimeArr objectAtIndex:2];
           //  NSLog(@" Time :-> %@ hours :-> %i minute :-> %i  seconds :-> %i",str,[hours1 intValue],  [minute intValue],[second intValue]);
        }@catch (NSException *exception) {
            
        }
        
        runningtolalTime = [hours1 intValue]*3600 +  [minute intValue]*60 + [second intValue];
        
        int repeatNotificationTime =   [trackerAutoStop intValue]*60 ;
        
      //  NSLog(@"repeatNotificationTime :->%i repeate notification :-> %i",repeatNotificationTime,( repeatNotificationTime - (runningtolalTime%repeatNotificationTime)) );
        runningtolalTime =  repeatNotificationTime - (runningtolalTime%repeatNotificationTime);
        //
        bool firstNotificationIdentify = YES;
        
        autoStopNotification  = [[UILocalNotification alloc] init];
        
        // NSMutableDictionary *dicObj = [[NSMutableDictionary alloc] init];
        //[dicObj setObject:_trackerNameLabel.text forKey:@""];
        
        NSDate *now = [NSDate date];
        
        autoStopNotification.soundName = _trackerSessionId;
        // autoStopNotification.userInfo = dicObj;
        autoStopNotification.alertBody = [NSString stringWithFormat:@"Your tracker %@ is still running. Would you like to stop it ?",trackerName];
        //NSLog(@"repeatNotificationTime :->  %@  ", autoStopNotification);
       // _runButton.enabled = NO;
        for( int i = 0; i <= 30; i++ ) {
            //NSLog(@"repeatNotificationTime :->  %i  ", repeatNotificationTime*i);
            if (firstNotificationIdentify) {
                
                autoStopNotification.fireDate = [NSDate dateWithTimeInterval:runningtolalTime sinceDate:now];
                [[UIApplication sharedApplication] scheduleLocalNotification: autoStopNotification];
                firstNotificationIdentify = NO;
            }else{
            
            autoStopNotification.fireDate = [NSDate dateWithTimeInterval:(runningtolalTime+ repeatNotificationTime*i) sinceDate:now];
            [[UIApplication sharedApplication] scheduleLocalNotification: autoStopNotification];
            }
        }
        //_runButton.enabled = YES;
       
       // NSLog(@" trackerAutoStop notification schelude :-> %@ ",[[UIApplication sharedApplication] scheduledLocalNotifications]);
       // NSLog(@" ************* trackerAutoStop ");
    }
    
}


-(void) breakCurrentTime{
    
}

//-(IBAction)medo:(id)sender{
//    
//    //
//    PopupViewController *demoViewController = [[PopupViewController alloc] init];
//	
//	// 2. Get shared floating controller
//	CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
//	
//	// 3. Show floating controller with specified content
//	UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//	[floatingController showInView:[rootViewController view]
//		 withContentViewController:demoViewController
//						  animated:YES];
//
//}

@end
