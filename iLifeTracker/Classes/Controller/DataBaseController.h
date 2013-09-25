
//
//  Created by Adrian
//  Copyright (c) 2013 3rd Floor Software Solutions Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBase.h"
#import "CommonUtilClass.h"


@interface DataBaseController : NSObject {
    //CommonUtilClass *_objCommonUtilClass;

}

+ (DataBaseController *) DBControllerharedInstance;



-(void) addDefaultTracker;

-(void) selectDataFromFBRegistrationTable:(NSString *) emailId;

-(BOOL) InsertDataIntoTrackerTableTrackerName:(NSString *)tackerName category:(NSString *)categoryName goalHours:(NSString *) goalHours alarm:(NSString *)alarm autoStopIntervel:(NSString *)autoStopIntervel;

-(void) insertTrackerCurrentSessionTrackerName:(NSString *) trackerName;

-(NSMutableArray *) selectCurrentSessionRecordTrackerName;


-(void) updateTrackerCurentSetionTimeCounter:(NSString *) timeCounter startDate:(NSDate *) startDate stroeDate:(NSDate *) stroeDate pauseCounter:(NSString *) pauseCounter indexNo:(NSString *) indexNo pauseIdentify:(NSString *) pauseIdentify runIdentify:(NSString *) runIdentify trackerName:(NSInteger) trackerID;

-(NSMutableArray *) trackerDetail;


-(void ) updateTackerSessionTrackerName:(NSInteger) trackerId trackerSetion:(NSString *) trackerSession;


-(void ) insertTackerDetailTrakerID:(NSInteger) trackerId  trackerName:(NSString *) trackerName categoryName:(NSString *) categoryName trackerSession:(NSString *) session trackerStartTime:(NSString *) trackerStartTime trackerEndTime:(NSDate *) trackerEndTime;

-(NSMutableArray *) trackerSessionDetailTrackerName:(NSInteger) TrackerId ;

-(void) deleteTrackerSessionRow:(NSInteger ) TrackerId;

-(NSMutableArray *) selectTrackerOneRecordTrackerID:(NSInteger) trackerID;

-(void) updateTrackerRecordTrakerID:(NSInteger) trackerID trackerName: (NSString *)tackerName category:(NSString *)categoryName goalHours:(NSString *) goalHours alarm:(NSString *)alarm autoStopIntervel:(NSString *)autoStopIntervel;

-(void) deleteTracker:(NSString *) trackerName;

-(void) deleteTrackerSessionRecords:(NSString *) trackerName;

-(NSMutableArray *) myLifeRecentActivityTrackerName;

-(NSMutableArray *) myLifeDetailInfo;

-(NSString *) currentTrackerNameTrackerId:(NSInteger) trackerId;


//Graph
//-(NSMutableArray *) selectTrackerSessionForGraph;

-(NSMutableArray *) selectTrackerSessionInfo;
//Reward.

-(NSMutableArray *) selectRewardDataCategoryName:(NSString *) categoryName;

-(NSMutableArray *) selectRewardMessageDataCategoryName;

-(void ) updateRewardStarCountCatregoryName:(NSString *) categoryName trackerSetion:(NSString *) startCounter;

-(long ) totalTimeAllOver;

@end
