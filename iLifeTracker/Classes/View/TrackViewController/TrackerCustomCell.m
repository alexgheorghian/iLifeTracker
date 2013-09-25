//
//  TrackerCustomCell.m
//  iLifeTracker
//
//  Created by Umesh on 07/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "TrackerCustomCell.h"
#import "AppDelegate.h"

#define ALERTTITLE @"Running Tracker"
#define ALERTSMS   @"Your tracker is currently running. What would you like to do?"
#define TabBarNOTIFICATIONNAME      @"tabbarNotification"

#define ALARMSMS  @"You have done your."


#import "CQMFloatingController.h"
#import "PopupViewController.h"
#import "TrackViewController.h"

@implementation TrackerCustomCell
@synthesize _totalTimeLabel,_trackerNameLabel,_startingTimeLabel,boolValue,_trackerSessionId,_trackerSession ,totalTimeDelegate, timeCounter , pauseCounter; //,minutes,hours,

@synthesize  categoryName,isRunning,_runningTime,_storeStartDateTime,_startDateTime,_trackerTimer,pauseIdentify,cellPuaseIdentifier,backgoundCounter,_runButton,storeDatStr;

@synthesize trackerGoal, trackerAlarm, trackerAutoStop,trackerNotification,autoStopNotification,_strtStpBtnImgView,runIdentify;

//static bool puaseIdentifier =NO;

//static bool rewadDataIdentify = YES;


-(IBAction)trackerSession:(id)sender{
    
    
    if ((!boolValue) && (!runIdentify)) {
        
       // NSLog( @" trackerSession " );
        boolValue = YES;
        _trackerTimer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(targetMethod:) userInfo:nil repeats:YES];
        
        [_strtStpBtnImgView setAlpha:0.0];
        [UIView animateWithDuration:1 animations:^{
            [_strtStpBtnImgView setAlpha:1.0];
            [_strtStpBtnImgView setImage:[UIImage imageNamed:@"stop.png"]];
        }];
        
        _startingTimeLabel.textColor = [UIColor greenColor];
        
        self._startDateTime = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm:ss a yyyy-MMM-dd"];
        //NSString  *backgroundTime = [outputFormatter stringFromDate:_startDateTime];
        //NSLog(@"newDateString %@", _startDateTime);
        //Tracker  Starting time
        if (!cellPuaseIdentifier && !pauseIdentify) {
            _storeStartDateTime = _startDateTime;
            isRunning = YES;
            storeDatStr = [outputFormatter stringFromDate:_startDateTime];
            //NSLog(@"newDateString %@", backgroundTime);
            
            //  NSLog(@" start ");
            // NSLog( @" !puaseIdentifier  no" );
        }
        else{
            cellPuaseIdentifier = NO;  
            //  NSLog(@" End  ");
            // NSLog( @"  puaseIdentifier yes  " );
        }
        // Percentage tracker goal.
        [self createScheduleForLocalNotification];
        
       
        //Database
        DataBaseController *obj = [DataBaseController DBControllerharedInstance];
        
        [obj updateTrackerCurentSetionTimeCounter:[NSString stringWithFormat:@"%i",timeCounter] startDate:_startDateTime stroeDate:_storeStartDateTime pauseCounter:[NSString stringWithFormat:@"%i",pauseCounter] indexNo:@"0" pauseIdentify:@"0" runIdentify:@"1" trackerName:[_trackerSessionId intValue]];
        //
        pauseIdentify = NO;
        
    }else{
        
        UIAlertView *sendMessage = [[UIAlertView alloc] initWithTitle:ALERTTITLE message:ALERTSMS delegate:self cancelButtonTitle:@"Stop" otherButtonTitles:@"Pause",nil];
        [sendMessage show];
    }
}



-(void) createScheduleForLocalNotification{
    if (([trackerGoal intValue] != 0  ) && ([trackerAlarm intValue] != 0) && (!cellPuaseIdentifier && !pauseIdentify)) {
        
       // NSLog(@"  ************************************** trackerAlarm :-> %@   ", trackerGoal); 
        int notificationTime = (([trackerGoal intValue]*60*60) * [trackerAlarm intValue])/100 ;
        
        NSArray   *totalTimeArr;
        NSString  *hours1 ;
        NSString  *minute ;
        NSString  *second ;
        int  runningtolalTime = 0; 
        @try{
            
            totalTimeArr = [_totalTimeLabel.text componentsSeparatedByString:@":"]; 
            hours1 = [totalTimeArr objectAtIndex:0];
            minute = [totalTimeArr objectAtIndex:1];
            second = [totalTimeArr objectAtIndex:2];
            // NSLog(@" hours :-> %i minute :-> %i  seconds :-> %i",[hours1 intValue],  [minute intValue],[second intValue]);
        }
        @catch (NSException *exception) {
            
        }
        runningtolalTime = [hours1 intValue]*360 + [minute intValue]*60 + [second intValue];
       //  NSLog(@"notificationTime :-> %i  runningtolalTime :-> %i",notificationTime,runningtolalTime);
        
        
        //
        //NSString *eidtIdentify = [[NSUserDefaults standardUserDefaults] stringForKey:@"edit"];
        
       // [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"edit"];
        
        
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"EDIT"]) {
            [[NSUserDefaults standardUserDefaults] setInteger:runningtolalTime forKey:@"TOTALTIME"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"EDIT"];
           // NSLog(@" Edit yes ");
        }
        notificationTime = notificationTime + [[NSUserDefaults standardUserDefaults] integerForKey:@"TOTALTIME"];
        //*****
        
        if(runningtolalTime < notificationTime){
            //if (trackerNotification != nil) trackerNotification = nil;
            int totalFireTime = notificationTime - runningtolalTime;
           //  NSLog(@"total fire time :-> %i", totalFireTime);
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
        
        //NSLog(@" percentage notification schelude :-> %@",[[UIApplication sharedApplication] scheduledLocalNotifications]);
        // NSLog(@" ************* alarm  protaction  ");
    }
    //
    if (([trackerAutoStop  intValue] != 0)&& (!cellPuaseIdentifier && !pauseIdentify) ) {
        //NSLog(@"tracker auto stop protaction ");
        // int repeatNotificationTime =  ([trackerGoal intValue]*60)/ [trackerAutoStop intValue] ;
        int repeatNotificationTime =   [trackerAutoStop intValue]*60 ;
        
        autoStopNotification  = [[UILocalNotification alloc] init];
        
        // NSMutableDictionary *dicObj = [[NSMutableDictionary alloc] init];
        //[dicObj setObject:_trackerNameLabel.text forKey:@""];
        
        NSDate *now = [NSDate date];
        
        autoStopNotification.soundName = _trackerSessionId;
        // autoStopNotification.userInfo = dicObj;
        autoStopNotification.alertBody = [NSString stringWithFormat:@"Your tracker %@ is still running. Would you like to stop it ?",_trackerNameLabel.text];
        //NSLog(@"repeatNotificationTime :->  %@  ", autoStopNotification);
        _runButton.enabled = NO;
        for( int i = 1; i <= 30; i++ ) {
            //NSLog(@"repeatNotificationTime :->  %i  ", repeatNotificationTime*i);
            autoStopNotification.fireDate = [NSDate dateWithTimeInterval:repeatNotificationTime*i sinceDate:now];
            [[UIApplication sharedApplication] scheduleLocalNotification: autoStopNotification];
        }
        _runButton.enabled = YES;
        
       // NSLog(@" trackerAutoStop notification schelude :-> %@ ",[[UIApplication sharedApplication] scheduledLocalNotifications]);
       // NSLog(@" ************* trackerAutoStop ");
    }
    
}





-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if(buttonIndex == 0)
    {
        [self stopRunningTracker];
        //        
    } 
    else if(buttonIndex == 1)
    {
        //  pause button.
        [self pauseTheTime]; 
        
    }
    
}

//
-(void)pauseTheTime
{
    
    
    pauseIdentify = YES;
    cellPuaseIdentifier = YES;
    boolValue = NO;
    pauseCounter = timeCounter + minutes*60 + hours*3600;
    //
    DataBaseController *obj = [DataBaseController DBControllerharedInstance];
    
    [obj updateTrackerCurentSetionTimeCounter:[NSString stringWithFormat:@"%i",timeCounter] startDate:_startDateTime stroeDate:_storeStartDateTime pauseCounter:[NSString stringWithFormat:@"%i",pauseCounter] indexNo:@"0" pauseIdentify:@"1" runIdentify:@"1" trackerName:[_trackerSessionId intValue]];
    
    
    timeCounter = 0;
    minutes = 0;
    hours = 0;
    
    // NSLog(@"    pauseCounter :-> %ld",pauseCounter);
    if ([_trackerTimer isValid] ) {
        [_trackerTimer invalidate];
        _trackerTimer = nil;
    } 
    
    [UIView animateWithDuration:1 animations:^{
        [_strtStpBtnImgView setAlpha:1.0];
        [_strtStpBtnImgView setImage:[UIImage imageNamed:@"pause.png"]];
    }];
    _startingTimeLabel.textColor = [UIColor yellowColor];
    
    runIdentify = NO;
    
}


//
-(void) stopRunningTracker{
    
    
    // Stop button.
    boolValue = NO;
    if ([_trackerTimer isValid] ) {
        [_trackerTimer invalidate];
        _trackerTimer = nil;
    } 
    //Chage image on button through animatiion 
    [_strtStpBtnImgView setAlpha:0.0];
    [UIView animateWithDuration:1 animations:^{
        [_strtStpBtnImgView setAlpha:1.0];
        [_strtStpBtnImgView setImage:[UIImage imageNamed:@"play.png"] ];
    }];
    //set current time
    _startingTimeLabel.text =@"Current 00:00:00";
    _startingTimeLabel.textColor = [UIColor redColor]; 
    //upate tracker session .
    //NSArray *sessionArr = [[NSArray alloc] init ];
    long sessionArr =  [_trackerSession intValue];
    
    //NSLog(@" minute  :-> %i ,puase :->  %ld",minutes,pauseCounter);
    //Tracker  End time
    // NSTimeInterval timeDifference = [_runningTime timeIntervalSinceDate:_startDateTime] + pauseCounter;
    // NSLog(@" minute  :-> %i ,puase :->  %ld , interval %ld",minutes,pauseCounter,timeDifference );    
    long curentSession =  timeCounter + minutes *60 +hours *3600;
    sessionArr = sessionArr + timeCounter + minutes *60 +hours *3600 ;
    // update total time 
    //trkScd = trkScd + trkMinute*60 + trkHour*360;
    DataBaseController *obj = [DataBaseController DBControllerharedInstance];
    [obj updateTackerSessionTrackerName:[_trackerSessionId intValue] trackerSetion:[NSString stringWithFormat:@"%d",sessionArr]];
    
    
    [totalTimeDelegate updateTrackerTotalTime];
    NSDate *end = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss a yyyy-MMM-dd"];
    
    // NSLog(@"newDateString id ********* : -> %@",_trackerSessionId);
    
    [obj insertTackerDetailTrakerID:[_trackerSessionId intValue] trackerName:_trackerNameLabel.text categoryName:categoryName trackerSession:[NSString stringWithFormat:@"%ld", curentSession] trackerStartTime:storeDatStr trackerEndTime:end];
    pauseCounter = 0;
    isRunning = NO;
    
    //
    [obj updateTrackerCurentSetionTimeCounter:@"0" startDate:_startDateTime stroeDate:_storeStartDateTime pauseCounter:@"0" indexNo:@"0" pauseIdentify:@"0" runIdentify:@"0" trackerName:[_trackerSessionId intValue]];
    
    
    
    timeCounter = 0;
    minutes = 0;
    hours = 0;
    // notificationTime = 0;
    
    //Local noticication Cancel
    if (trackerNotification != nil) {
        [[UIApplication sharedApplication] cancelLocalNotification:trackerNotification];
       // NSLog(@" Stop  notification schelude :-> %@",[[UIApplication sharedApplication] scheduledLocalNotifications]);
       // NSLog(@" ************* Stop   ");
    }
    //Repeated interval notification.
   
    if (autoStopNotification != nil) {
        //NSLog(@"cancel auto stop notification ");
        
       // [[UIApplication sharedApplication] cancelLocalNotification:autoStopNotification];
       // [NSThread detachNewThreadSelector:@selector(startTheBackgroundThread:) toTarget:self withObject:autoStopNotification];
        
        NSArray *notification = [[UIApplication sharedApplication] scheduledLocalNotifications];
        
        for (UILocalNotification *lt in notification) {
            if ([lt.soundName isEqualToString:_trackerSessionId]) {
                 [[UIApplication sharedApplication] cancelLocalNotification:lt];
                // NSLog(@" ************* sound Name   ");
            }
            
            
        }
        
        //NSLog(@" Stop  notification schelude :-> %@",[[UIApplication sharedApplication] scheduledLocalNotifications]);
        //NSLog(@" ************* Stop   ");
    }
    
    
    //Make nil of curennt date.
    if (_runningTime != Nil) {
        _runningTime  = nil; 
    } if (_storeStartDateTime != nil) {
        _storeStartDateTime = nil;
    }if (_startDateTime != nil) {
        _startDateTime    = nil;
    }
    pauseIdentify = NO;
    //background time check 
    runIdentify = NO;
    
    
    [self popupViewCategoryName:categoryName];
   // [self overAllPopup];

}


-(void) popupViewCategoryName:(NSString *) categoryName1{
    //NSLog(@"ghgghghfghfgh");
    
    //NSMutableArray *rewardDataArray;
     DataBaseController *obj = [DataBaseController DBControllerharedInstance];
    NSMutableArray *trackerDetail = [obj selectRewardDataCategoryName:categoryName1];
   
        //
       rewardDataArray = [obj selectRewardMessageDataCategoryName];
     
    NSArray *intervalArray = nil;
    short numberofStarSelected;
    NSString *imageName;
    
    for (RwardMessageModel *objRewardSMS in rewardDataArray) {
        //NSLog(@"reward message data category name Track Cell :-> %@", objRewardSMS.starCount);
       if ([categoryName1 isEqualToString:objRewardSMS.categoryName]) {
           if(LOGS_ON)  NSLog(@"reward message data category name Track Cell :-> %@", objRewardSMS.categoryName);
           if(LOGS_ON)  NSLog(@"ctegory :-> %@", categoryName1);
             if(LOGS_ON) NSLog(@"reward message data category name Track Cell :-> %@", objRewardSMS.rewardInterval);
             if(LOGS_ON) NSLog(@"reward message data category name Track Cell :-> %@", objRewardSMS.starCount);
           numberofStarSelected = [ objRewardSMS.starCount intValue];
           imageName            = objRewardSMS.rewardImage;
           intervalArray = [objRewardSMS.rewardInterval componentsSeparatedByString:@","]; 
           
        }
        
    }
    long totalTime;
    @try{
        RewardModel *objCategoryModel = [trackerDetail objectAtIndex:0];
        totalTime = [objCategoryModel.tolatTime intValue];
    }@catch (NSException *e) {
        
    }

    short totalStar = 0;
    int totalTimeForTotalStar;
    for (NSString *str in intervalArray) {
        int interval = [str intValue]*3600;
        if(LOGS_ON)  NSLog(@"totalTime  :-> %ld",totalTime);
       if(LOGS_ON)   NSLog(@"interval  :-> %i",interval);
        if(totalTime  <= interval)
        {
            break;
        }
        totalTimeForTotalStar = [str intValue];
        totalStar++;
    }
 
    NSString *messageShare;
    NSString *shareOnShocialMidea;
    
    for (RwardMessageModel *objRewardSMS in rewardDataArray) {
        //NSLog(@"reward message data category name Track Cell :-> %@", objRewardSMS.starCount);
        if ([categoryName1 isEqualToString:objRewardSMS.categoryName]) {
           // PopupViewController *objPopup = [[PopupViewController alloc] init];
            if (totalStar == 1) {
                messageShare = objRewardSMS.rewardMessage1;
                
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  %@ category for tracking %i hours of activity.",totalStar,categoryName1,totalTimeForTotalStar];
                //NSString *str1 = [str stringByAppendingFormat:@"star of the %",categoryName1];
                //NSString *str1 = [@" star of the " stringByAppendingFormat:@"%",categoryName1];
                
                 //=@"I just unlocked the 3rd star of the Sports category for tracking 50 hours of activitiy.";
               // NSLog(@"message 1 :-> %@ :-> %@",messageShare,shareOnShocialMidea);
                 break;
            }else if (totalStar == 2) {
                messageShare = objRewardSMS.rewardMessage2;
                
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  %@ category for tracking %i hours of activity.",totalStar,categoryName1,totalTimeForTotalStar];
              //  NSLog(@"message 2 :-> %@ :-> %@",messageShare,shareOnShocialMidea);
                 break;
            }else if (totalStar == 3) {
                messageShare = objRewardSMS.rewardMessage3;
                
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  %@ category for tracking %i hours of activity.",totalStar,categoryName1,totalTimeForTotalStar];
                 //NSLog(@"message 3:-> %@ :-> %@",messageShare,shareOnShocialMidea);
                 break;
            }else if (totalStar == 4) {
                messageShare = objRewardSMS.rewardMessage4;
                
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  %@ category for tracking %i hours of activity.",totalStar,categoryName1,totalTimeForTotalStar];
                 NSLog(@"message 4:-> %@ :-> %@",messageShare,shareOnShocialMidea);
                 break;
            }else if (totalStar == 5) {
               messageShare = objRewardSMS.rewardMessage4;
                
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  %@ category for tracking %i hours of activity.",totalStar,categoryName1,totalTimeForTotalStar];
                // NSLog(@"message 5:-> %@ :-> %@",messageShare,shareOnShocialMidea); 
                break;
                
            }
        }
    }

    
    //NSLog(@"numberofStarSelectedr  :-> %i",numberofStarSelected);
    //  NSLog(@"totalStar  :-> %i",totalStar);

    if((numberofStarSelected < totalStar)){ //|| (  totalStar < numberofStarSelected)){
    PopupViewController *demoViewController = [[PopupViewController alloc] init];
	
	// 2. Get shared floating controller
	CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    
    floatingController.selectedImageCounter  = totalStar; 
        floatingController.imageName = imageName;
        floatingController.message = messageShare;
        floatingController.messageShareOnTwtAndFB = shareOnShocialMidea;
        floatingController.socialMediaIdentify = NO;
        floatingController.overallIndtify = NO;
	[floatingController showInView:[TrackViewController TrackSharedInstance].view
		 withContentViewController:demoViewController
						  animated:YES];
        [obj updateRewardStarCountCatregoryName:categoryName1 trackerSetion:[NSString stringWithFormat:@"%i",totalStar]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissAlert:) name:@"loginComplete" object:nil];
    }else{
         [self overAllPopup];
    }
    
    
            
    
//    NSLog(@"numberofStarSelected  :-> %i", numberofStarSelected);
//     NSLog(@"totalStar  :-> %i", totalStar);
//    
//    numberofStarSelected = totalStar;
//    NSLog(@"after numberofStarSelected  :-> %i", numberofStarSelected);
    
    
    
//    
//    PopupViewController *demoViewController = [[PopupViewController alloc] init];
//	
//	// 2. Get shared floating controller
//	CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
//    
//   // floatingController.selectedImageCounter  = totalStar; 
//   // floatingController.imageName = imageName;
//	[floatingController showInView:[TrackViewController TrackSharedInstance].view
//		 withContentViewController:demoViewController
//						  animated:YES];
}

- (void)dismissAlert:(NSNotification *)note {
    
   // NSLog(@"Received Notification - "); 
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(overAllPopupShow) userInfo:nil repeats:NO];
    
    
}
-(void) overAllPopupShow{
     [self overAllPopup];
}
//-(void) startTheBackgroundThread:(NSNotification *) localNotification{
//    
//    
//    NSArray *notification = [[UIApplication sharedApplication] scheduledLocalNotifications];
//    
//    for (UILocalNotification *lt in notification) {
//        if ([lt.soundName isEqualToString:_trackerSessionId]) {
//            [[UIApplication sharedApplication] cancelLocalNotification:lt];
//            NSLog(@" ************* sound Name   ");
//        }
//    }
//    
//    NSLog(@" Stop  notification schelude :-> %@",[[UIApplication sharedApplication] scheduledLocalNotifications]);
//    NSLog(@" ************* Stop   ");
//}






-(void) targetMethod :(id) sender{
    
    //Tracker  End time
    if (!runIdentify) {
        
        
        _runningTime = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm:ss a yyyy-MMM-dd"];
        
        
        NSTimeInterval timeDifference = [_runningTime timeIntervalSinceDate:_startDateTime];
        
        timeCounter =  round(timeDifference) + pauseCounter;
        //NSLog(@" targetMethod custom not "); 
    }else if(runIdentify){
        //NSLog(@" targetMethod custom  :-> %ld",timeCounter); 
        backgoundCounter =backgoundCounter +1 ;
        timeCounter = backgoundCounter;
        //NSLog(@" targetMethod custom ");
    }
    
    
    if (timeCounter >= 3600 ) {
        hours   = timeCounter/3600 ;
    }
    if (timeCounter >= 60 ) {
        minutes = timeCounter/60;
        timeCounter  = timeCounter % 60;
        if (minutes >= 60) {
            minutes = minutes % 60;
        }
    }
    
    self._startingTimeLabel.text = [NSString stringWithFormat:@"Current %02d:%02d:%02d",hours,minutes,timeCounter];
    
   
        //NSLog(@"tracker auto stop protaction ");
        // int repeatNotificationTime =  ([trackerGoal intValue]*60)/ [trackerAutoStop intValue] ;
//        int repeatNotificationTime =   [trackerAutoStop intValue]*60 ;
//   
//     if (([trackerAutoStop  intValue] != 0)&& (timeCounter%repeatNotificationTime == 0) ) {
//        //  NSLog(@"repeatNotificationTime :-> %i enter :-> %i timecounter :-> %i ",repeatNotificationTime,(timeCounter%repeatNotificationTime),timeCounter );
//         
//    UIAlertView *sendMessage = [[UIAlertView alloc] initWithTitle:@"Running Tracker" message:[NSString stringWithFormat:@"Your tracker %@ is still running. Would you like to stop it ?",_trackerNameLabel.text] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
//    //trackerId = notification.soundName;
//    [sendMessage show];
//     }

}



-(void) overAllPopup{
    
    
    //
     DataBaseController *obj = [DataBaseController DBControllerharedInstance];
    
    // rewardDataArray = [obj selectRewardMessageDataCategoryName];
    long totalTime = [obj totalTimeAllOver];
    NSMutableArray *rewardDataArrayStartic = [obj selectRewardMessageDataCategoryName];
    
    NSArray *intervalArray = nil;
    short numberofStarSelected;
    NSString *imageName;
    
    for (RwardMessageModel *objRewardSMS in rewardDataArrayStartic) {
        //NSLog(@"reward message data category name Track Cell :-> %@", objRewardSMS.starCount);
        if ([@"Overall" isEqualToString:objRewardSMS.categoryName]) {
            if(LOGS_ON)  NSLog(@"reward message data category name Track Cell :-> %@", objRewardSMS.categoryName);
            //if(LOGS_ON)  NSLog(@"ctegory :-> %@", categoryName1);
            if(LOGS_ON) NSLog(@"reward message data category name Track Cell :-> %@", objRewardSMS.rewardInterval);
            if(LOGS_ON) NSLog(@"reward message data category name Track Cell :-> %@", objRewardSMS.starCount);
            numberofStarSelected = [ objRewardSMS.starCount intValue];
            imageName            = objRewardSMS.rewardImage;
            intervalArray = [objRewardSMS.rewardInterval componentsSeparatedByString:@","]; 
            
        }
        
    }
    
    short totalStar = 0;
    int totalTimeForTotalStar;
    for (NSString *str in intervalArray) {
        int interval = [str intValue]*3600;
       // if(LOGS_ON)  NSLog(@"totalTime  :-> %ld",totalTime);
        //if(LOGS_ON)   NSLog(@"interval  :-> %i",interval);
        if(totalTime  <= interval)
        {
            break;
        }
        totalTimeForTotalStar = [str intValue];
        totalStar++;
    }
    
    NSString *messageShare;
    NSString *shareOnShocialMidea;
    
    for (RwardMessageModel *objRewardSMS in rewardDataArray) {
        //NSLog(@"reward message data category name Track Cell :-> %@", objRewardSMS.starCount);
        if ([@"Overall" isEqualToString:objRewardSMS.categoryName]) {
            // PopupViewController *objPopup = [[PopupViewController alloc] init];
            if (totalStar == 1) {
                messageShare = objRewardSMS.rewardMessage1;
                
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  Overall  for tracking %i hours of activity.",totalStar,totalTimeForTotalStar];
                //NSString *str1 = [str stringByAppendingFormat:@"star of the %",categoryName1];
                //NSString *str1 = [@" star of the " stringByAppendingFormat:@"%",categoryName1];
                
                //=@"I just unlocked the 3rd star of the Sports category for tracking 50 hours of activitiy.";
                // NSLog(@"message 1 :-> %@ :-> %@",messageShare,shareOnShocialMidea);
                break;
            }else if (totalStar == 2) {
                messageShare = objRewardSMS.rewardMessage2;
                
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  Overall  for tracking %i hours of activity.",totalStar,totalTimeForTotalStar];
                //  NSLog(@"message 2 :-> %@ :-> %@",messageShare,shareOnShocialMidea);
                break;
            }else if (totalStar == 3) {
                messageShare = objRewardSMS.rewardMessage3;
                
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  Overall  for tracking %i hours of activity.",totalStar,totalTimeForTotalStar];
                //NSLog(@"message 3:-> %@ :-> %@",messageShare,shareOnShocialMidea);
                break;
            }else if (totalStar == 4) {
                messageShare = objRewardSMS.rewardMessage4;
                
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  Overall  for tracking %i hours of activity.",totalStar,totalTimeForTotalStar];
                NSLog(@"message 4:-> %@ :-> %@",messageShare,shareOnShocialMidea);
                break;
            }else if (totalStar == 5) {
                messageShare = objRewardSMS.rewardMessage4;
                
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  Overall  for tracking %i hours of activity.",totalStar,totalTimeForTotalStar];
                // NSLog(@"message 5:-> %@ :-> %@",messageShare,shareOnShocialMidea); 
                break;
                
            }
        }
    }
    
    
     NSLog(@"numberofStarSelectedr  :-> %i",numberofStarSelected);
      NSLog(@"totalStar  :-> %i",totalStar);
    
    if((numberofStarSelected < totalStar)){ //|| (  totalStar < numberofStarSelected)){
        PopupViewController *demoViewController = [[PopupViewController alloc] init];
        
        // 2. Get shared floating controller
        CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
        
        floatingController.selectedImageCounter  = totalStar; 
        floatingController.imageName = imageName;
        floatingController.message = messageShare;
        floatingController.messageShareOnTwtAndFB = shareOnShocialMidea;
        floatingController.overallIndtify = YES;
        floatingController.socialMediaIdentify = NO;
        [floatingController showInView:[TrackViewController TrackSharedInstance].view
             withContentViewController:demoViewController
                              animated:YES];
      //  [obj updateRewardStarCountCatregoryName:categoryName1 trackerSetion:[NSString stringWithFormat:@"%i",totalStar]];
         [obj updateRewardStarCountCatregoryName:@"Overall" trackerSetion:[NSString stringWithFormat:@"%i",totalStar]];
    }
    

}

@end
