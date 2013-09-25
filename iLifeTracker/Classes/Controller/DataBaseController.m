
//
//  Created by Adrian
//  Copyright (c) 2013 3rd Floor Software Solutions Inc. All rights reserved.
//

#import "DataBaseController.h"
#import "RewardModel.h"

#define USERREGISTRATIONTITLE       @"Warning"

#define USERREGISTRATIONSMS         @"Someone already registered with this email."

#define USERREGISTRATIONPWDSMS      @"Confirm password not match."

#define USERREGISTRATIONFIELDSMS    @"You must fill all fields."

#define  ADDTRACKERALERTSMS     @"Tracker add successfully."
#define  UPDATETRACKERALERTSMS     @"Changes saved successfully."
#define  ADDTRACKERTITLE        @"Add Tracker"

#define USERREGISTEREDSMS       @"User registered successfully."
#define USERREGISTEREDTITALE    @"Registration"

#define TRACKERNAMEALREADYEXIST @"A tracker with this name already exists."

@implementation DataBaseController

//static NSInteger loginUserId = 1 ;

static DataBaseController *_objDBController = nil;

+ (DataBaseController *) DBControllerharedInstance {
    if (_objDBController == nil) {
        _objDBController = [[DataBaseController alloc] init];
    }
    
    return _objDBController;
}

#pragma mark:->
#pragma Mark user Registraction 



#pragma mark:->
#pragma Mark Add fefault 2 tracker 
-(void) addDefaultTracker{
    DataBase *obj = [DataBase DatabasesharedInstance];
    NSString *query;
   query     = [NSString stringWithFormat:@"INSERT  INTO Tracker (TRACKER_NAME,TRACKER_CATEGORY)  VALUES (\"Gym\",\"Sports\")"];
    [obj insertData:query];
    query     = [NSString stringWithFormat:@"INSERT  INTO Tracker (TRACKER_NAME,TRACKER_CATEGORY)  VALUES (\"Running\",\"Sports\")"];
    [obj insertData:query];
    
    
    
    query     = [NSString stringWithFormat:@"INSERT  INTO TrackerCurrentSession (TRACKER_NAME,T_ID)  VALUES (\"Gym\",\"1\")"];
    [obj insertData:query];
    
    query     = [NSString stringWithFormat:@"INSERT  INTO TrackerCurrentSession (TRACKER_NAME,T_ID)  VALUES (\"Running\",\"2\")"];
    [obj insertData:query];
}
//
//

-(void) selectDataFromFBRegistrationTable:(NSString *) emailId{
  
}

#pragma mark:->
#pragma mark Add Tracker 

-(BOOL) InsertDataIntoTrackerTableTrackerName:(NSString *)tackerName category:(NSString *)categoryName goalHours:(NSString *) goalHours alarm:(NSString *)alarm autoStopIntervel:(NSString *)autoStopIntervel {
    
   //  CommonUtilClass *objCommonUtilClass = [CommonUtilClass CommonUtilSharedInstance];
    DataBase *obj = [DataBase DatabasesharedInstance];
    
    NSString *query     = [NSString stringWithFormat:@"SELECT T_ID FROM Tracker WHERE TRACKER_NAME LIKE \"%@\"",tackerName];
    NSMutableArray *loginArraay =  [obj selectRowForAnyTable:query];

    if ([loginArraay count] != 0) {
        //[objCommonUtilClass showAlertView:TRACKERNAMEALREADYEXIST title:ADDTRACKERTITLE];
        return NO;
    }else{

       
     NSString *query     = [NSString stringWithFormat:@"INSERT  INTO Tracker (TRACKER_NAME,TRACKER_CATEGORY,GOAL_HOUR,ALARM_PRT,AUTOSTOPINTERVEL)  VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",tackerName,categoryName,goalHours,alarm,autoStopIntervel];
        [obj insertData:query];
        
        [self insertTrackerCurrentSessionTrackerName:tackerName];
       //[objCommonUtilClass showAlertView:ADDTRACKERALERTSMS title:ADDTRACKERTITLE];
        return YES;
    }
}

#pragma Current session Detail

-(void) insertTrackerCurrentSessionTrackerName:(NSString *) trackerName{
    
     DataBase *obj = [DataBase DatabasesharedInstance];
    
    NSString *query     = [NSString stringWithFormat:@"SELECT T_ID FROM Tracker WHERE TRACKER_NAME LIKE \"%@\"",trackerName];
    NSMutableArray *loginArraay =  [obj selectRowForAnyTable:query];
    int trackerId;
    for (NSString *obj in loginArraay) {
        trackerId = [obj intValue];
    }
    
    NSString *query1     = [NSString stringWithFormat:@"INSERT  INTO TrackerCurrentSession (TRACKER_NAME,T_ID)  VALUES (\"%@\",\"%i\")",trackerName,trackerId];
    [obj insertData:query1];
}


-(NSMutableArray *) selectCurrentSessionRecordTrackerName{
    
    DataBase *obj = [DataBase DatabasesharedInstance];
    NSString *query     = [NSString stringWithFormat:@"SELECT TRACKER_NAME ,TIME_COUNTER,STARTDATE,STOREDATE,PAUSECOUNTER,INDEX_NO,PAUSE_IDENTIFY,RUN_IDENTIFY FROM TrackerCurrentSession"];
    
    NSMutableArray *trackerArr =  [obj selectCurrentSession:query];
    
    return trackerArr;
}


-(void) updateTrackerCurentSetionTimeCounter:(NSString *) timeCounter startDate:(NSDate *) startDate stroeDate:(NSDate *) stroeDate pauseCounter:(NSString *) pauseCounter indexNo:(NSString *) indexNo pauseIdentify:(NSString *) pauseIdentify runIdentify:(NSString *) runIdentify trackerName:(NSInteger) trackerID{
    
     DataBase *obj = [DataBase DatabasesharedInstance];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss a yyyy-MMM-dd"];
    NSString *start = [outputFormatter stringFromDate:startDate];
   NSString *end = [outputFormatter stringFromDate:stroeDate];
    
    
    
    NSString *query     = [NSString stringWithFormat:@"UPDATE  TrackerCurrentSession SET  TIME_COUNTER=\"%@\", STARTDATE=\"%@\", STOREDATE=\"%@\", PAUSECOUNTER=\"%@\", INDEX_NO=\"%@\" ,PAUSE_IDENTIFY=\"%@\", RUN_IDENTIFY=\"%@\"   WHERE  T_ID = \"%i\" ",timeCounter,start,end,pauseCounter,indexNo,pauseIdentify,runIdentify,trackerID];
    [obj insertData:query];
    
    //NSLog(@" Data base  updateTrackerCurentSetionTimeCounter ");

}





-(void) updateTrackerRecordTrakerID:(NSInteger) trackerID trackerName: (NSString *)tackerName category:(NSString *)categoryName goalHours:(NSString *) goalHours alarm:(NSString *)alarm autoStopIntervel:(NSString *)autoStopIntervel {
    CommonUtilClass *objCommonUtilClass = [CommonUtilClass CommonUtilSharedInstance];
    DataBase *obj = [DataBase DatabasesharedInstance];
    
    NSString *query     = [NSString stringWithFormat:@"SELECT T_ID FROM Tracker WHERE TRACKER_NAME LIKE \"%@\" and T_ID <> \"%i\"",tackerName,trackerID];
    NSMutableArray *loginArraay =  [obj selectRowForAnyTable:query];
    if ([loginArraay count] != 0) {
        
        [objCommonUtilClass showAlertView:TRACKERNAMEALREADYEXIST title:ADDTRACKERTITLE];
    }else{
        
        
        NSString *query     = [NSString stringWithFormat:@"UPDATE  Tracker SET  TRACKER_NAME=\"%@\", TRACKER_CATEGORY=\"%@\", GOAL_HOUR=\"%@\", ALARM_PRT=\"%@\", AUTOSTOPINTERVEL=\"%@\"   WHERE  T_ID = \"%i\"",tackerName,categoryName,goalHours,alarm,autoStopIntervel,trackerID];
        [obj insertData:query];
        
        //NSLog(@"*************************** :-> %i",trackerID);
        
        NSString *querySessionn     = [NSString stringWithFormat:@"UPDATE  TrackerDetail SET   TRACKER_NAME = \"%@\" WHERE   T_ID = \"%i\" ",tackerName,trackerID];
        [obj insertData:querySessionn];
        
        //TrackerCurrentSession table
        NSString *query1     = [NSString stringWithFormat:@"UPDATE  TrackerCurrentSession SET   TRACKER_NAME = \"%@\" WHERE   T_ID = \"%i\" ",tackerName,trackerID];
        [obj insertData:query1];
        
        [objCommonUtilClass showAlertView:UPDATETRACKERALERTSMS title:ADDTRACKERTITLE];
    }
}

#pragma mark:->
#pragma mark Select  Add TrackerName

-(NSMutableArray *) trackerDetail {
    DataBase *obj = [DataBase DatabasesharedInstance];
    NSString *query     = [NSString stringWithFormat:@"SELECT TRACKER_NAME ,TRACKER_CATEGORY,TRACKER_SESSION,T_ID,GOAL_HOUR,ALARM_PRT,AUTOSTOPINTERVEL FROM Tracker "];
    //order by  T_ID DESC
    NSMutableArray *trackerArr =  [obj selectTrackerDetail:query];
    
    return trackerArr;
}


-(void ) updateTackerSessionTrackerName:(NSInteger) trackerId trackerSetion:(NSString *) trackerSession {
     // NSLog(@" updateTackerSessionTrackerName :-> %@  trackerId :-> %i",trackerSession,trackerId);
   // NSLog(@" trackerSession :-> %@",trackerSession);
    DataBase *obj = [DataBase DatabasesharedInstance];
    NSString *query     = [NSString stringWithFormat:@"UPDATE  Tracker SET   TRACKER_SESSION = \"%@\" WHERE  T_ID = \"%i\"  ",trackerSession,trackerId];
    [obj insertData:query]; 
    
   
}


-(NSMutableArray *) selectTrackerOneRecordTrackerID:(NSInteger) trackerID{
    DataBase *obj = [DataBase DatabasesharedInstance];
    NSString *query     = [NSString stringWithFormat:@"SELECT TRACKER_NAME ,TRACKER_CATEGORY, GOAL_HOUR,ALARM_PRT, AUTOSTOPINTERVEL FROM Tracker where T_ID =\"%i\"",trackerID];
    NSMutableArray *trackerArr =  [obj selectTrackerRecord:query];
    
    return trackerArr;
}

#pragma mark:->
#pragma mark Select   Tracker Detail

-(void ) insertTackerDetailTrakerID:(NSInteger) trackerId  trackerName:(NSString *) trackerName categoryName:(NSString *) categoryName trackerSession:(NSString *) session trackerStartTime:(NSString *) trackerStartTime trackerEndTime:(NSDate *) trackerEndTime{
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss a yyyy-MMM-dd"];
    NSString *start = trackerStartTime ;// [outputFormatter stringFromDate:trackerStartTime];
    NSString *end = [outputFormatter stringFromDate:trackerEndTime];
    

    NSString *startDate = start;
    NSArray *startDateArray = [startDate componentsSeparatedByString:@" "];
    NSString *currentDate;
    @try{
    currentDate = [startDateArray objectAtIndex:2];
    }@catch (NSException *e) {
        NSLog(@" DatabaseController : insertTackerDetailTrakerID :  Exception :");
    }
     NSString  *trackerSessionDate = [currentDate stringByAppendingString:trackerName];
    
    DataBase *obj = [DataBase DatabasesharedInstance];
    NSString *query     = [NSString stringWithFormat:@"INSERT  INTO TrackerDetail (T_ID,TRACKER_NAME,TRACKER_CATEGORY,TRACKER_SESSION,TRACKER_STARTTIME,TRACKER_ENDTIME,DATE)  VALUES (\"%i\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",trackerId,trackerName,categoryName,session, start, end,trackerSessionDate];
    [obj insertData:query];
    
}


-(NSMutableArray *) trackerSessionDetailTrackerName:(NSInteger ) TrackerId  {
    DataBase *obj = [DataBase DatabasesharedInstance];
    
    NSString *query     = [NSString stringWithFormat:@"SELECT TD.TD_ID ,T.TRACKER_NAME,TD.TRACKER_CATEGORY,TD.TRACKER_SESSION,TD.TRACKER_STARTTIME , TD.TRACKER_ENDTIME, T.TRACKER_SESSION FROM Tracker AS T , TrackerDetail AS TD  where T.T_ID = \"%i\" and TD.T_ID = \"%i\"",TrackerId,TrackerId];
    NSMutableArray *trackerArr =  [obj selectTrackerSessionDetail:query];
    return trackerArr;
}

#pragma mark:->
#pragma mark delete row   Tracker session Detail
-(void) deleteTrackerSessionRow:(NSInteger ) TrackerId{
    // NSLog(@" delete row ");
    DataBase *obj = [DataBase DatabasesharedInstance];
    NSString *query     = [NSString stringWithFormat:@"DELETE FROM TrackerDetail WHERE TD_ID = \"%i\" ",TrackerId];
    [obj insertData:query]; 
    
   
}

#pragma mark:->
#pragma mark   Delete  Tracker 

-(void) deleteTracker:(NSString *) trackerName{
    
    DataBase *obj = [DataBase DatabasesharedInstance];
    NSString *query     = [NSString stringWithFormat:@"DELETE FROM Tracker WHERE  TRACKER_NAME =\"%@\" ",trackerName];
    [obj insertData:query];
    
    
    
    //Tracker Record delete TrackerCurrentSession table TrackerCurrentSession
    NSString *query1     = [NSString stringWithFormat:@"DELETE FROM TrackerCurrentSession WHERE TRACKER_NAME =\"%@\" ",trackerName];
    [obj insertData:query1];
}

-(void) deleteTrackerSessionRecords:(NSString *) trackerName{
    
    DataBase *obj = [DataBase DatabasesharedInstance];
    NSString *query     = [NSString stringWithFormat:@"DELETE FROM TrackerDetail WHERE  TRACKER_NAME =\"%@\" ",trackerName];
    [obj insertData:query];
}

#pragma mark:->
#pragma mark   Delete  Tracker
-(NSMutableArray *) myLifeDetailInfo{
    DataBase *obj = [DataBase DatabasesharedInstance];
    
    NSString *query     = [NSString stringWithFormat:@"SELECT TRACKER_NAME,TRACKER_CATEGORY,SUM(TRACKER_SESSION),max(TRACKER_SESSION),COUNT(TRACKER_NAME) from Tracker GROUP BY TRACKER_CATEGORY"];
    
    NSMutableArray *trackerArr =  [obj selectMyLifeData:query];
    
    return trackerArr;
}

-(NSMutableArray *) myLifeRecentActivityTrackerName{

    DataBase *obj = [DataBase DatabasesharedInstance];
    
    NSString *query     = [NSString stringWithFormat:@"SELECT  TRACKER_NAME,TRACKER_STARTTIME , TRACKER_ENDTIME ,TRACKER_SESSION FROM TrackerDetail   order by  TD_ID DESC LIMIT 5"];
    
    NSMutableArray *trackerArr =  [obj selectMylifeRecentActivity:query];
    return trackerArr;
}


-(NSString *) currentTrackerNameTrackerId:(NSInteger) trackerId{
    NSString *trackerName;
   // NSLog(@"**************** :-. %i ", trackerId);
    DataBase *obj = [DataBase DatabasesharedInstance];
    NSString *query     = [NSString stringWithFormat:@"SELECT TRACKER_NAME FROM Tracker WHERE T_ID=\"%i\" ",trackerId];
    NSMutableArray *trackerNameArray =  [obj selectRowForAnyTable:query];
     if([trackerNameArray count] != 0){
         
         trackerName = [trackerNameArray objectAtIndex:0];
     }
    return trackerName;
}

#pragma mark:->
#pragma mark   Delete  Tracker


-(NSMutableArray *) selectTrackerSessionInfo{
    DataBase *obj = [DataBase DatabasesharedInstance];
    NSString *query     = [NSString stringWithFormat:@"SELECT TRACKER_NAME,SUM(TRACKER_SESSION), TRACKER_SESSION,TRACKER_STARTTIME,TRACKER_ENDTIME FROM TrackerDetail  GROUP BY  DATE; "];
    NSMutableArray *array =  [obj selectGraphInfo:query];
    return array;
}


-(NSMutableArray *) selectRewardDataCategoryName:(NSString *) categoryName{
    DataBase *obj = [DataBase DatabasesharedInstance];
    NSString *query     = [NSString stringWithFormat:@"SELECT TRACKER_CATEGORY,SUM(TRACKER_SESSION) from Tracker WHERE TRACKER_CATEGORY =\"%@\" GROUP BY TRACKER_CATEGORY",categoryName];
     NSMutableArray *trackerArr =  [obj selectRewardData:query];
    

    
    return trackerArr;
}


-(NSMutableArray *) selectRewardMessageDataCategoryName{
    DataBase *obj = [DataBase DatabasesharedInstance];
    NSString *query     = [NSString stringWithFormat:@"SELECT CATEGORY_NAME,REWARDS_INTERVAL,REWARDS_IMAGE,CUSTOM_MESSAGE1,CUSTOM_MESSAGE2,CUSTOM_MESSAGE3,CUSTOM_MESSAGE4,CUSTOM_MESSAGE5,SELECTED_STARCOUNT from CategoryRewardMessage"];
    NSMutableArray *trackerArr =  [obj selectRewardMessageData:query];
    

   
    
    return trackerArr;
}

//

-(void ) updateRewardStarCountCatregoryName:(NSString *) categoryName trackerSetion:(NSString *) startCounter {
    DataBase *obj = [DataBase DatabasesharedInstance];
    NSString *query     = [NSString stringWithFormat:@"UPDATE  CategoryRewardMessage SET   SELECTED_STARCOUNT = \"%@\" WHERE  CATEGORY_NAME = \"%@\"  ",startCounter,categoryName];
    [obj insertData:query]; 
    
    
}


-(long ) totalTimeAllOver{
    DataBase *obj = [DataBase DatabasesharedInstance];
    NSString *query     = [NSString stringWithFormat:@" SELECT SUM(TRACKER_SESSION) FROM Tracker"];
    long totalTime = [obj overAllToalTime:query];
    
    return totalTime;
}
@end
