//
//  TrackerCustomCell.h
//  iLifeTracker
//
//  Created by Umesh on 07/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseController.h"
#import "RewardModel.h"
#import "RwardMessageModel.h"

#import "TrackCustomCellDelegate.h"


@interface TrackerCustomCell : UITableViewCell {
    
    IBOutlet UIButton       *_runButton;
    IBOutlet UILabel        *_trackerNameLabel;
    IBOutlet UILabel        *_startingTimeLabel;
    IBOutlet UILabel        *_totalTimeLabel;
    IBOutlet UIImageView    *_strtStpBtnImgView;
    
    NSTimer                 *_trackerTimer;
    
    NSString                *_trackerSessionId;
    NSString                *_trackerSession;

    UITableView             *_trackerTableView;
    
    BOOL         boolValue ;
    long         timeCounter ;
    int          minutes;
    short          hours;

    id <TrackCustomCellDelegate> totalTimeDelegate;
    
    NSDate          *_startDateTime;
   // NSDate          *_endDateTime;
    NSDate          *_runningTime;
    NSString        *categoryName;
    
    
    long              pauseCounter;
    NSDate          *_storeStartDateTime;
    
    NSString        *storeDatStr;
    //NSString        *endDateStr;
    
    BOOL            isRunning;
    
    NSString        *trackerGoal;
    NSString        *trackerAlarm;
    NSString        *trackerAutoStop;
    
   // long            notificationTime;
    //long            repeatNotificationTime;
   // NSDateFormatter *outputFormatter;
    long           backgoundCounter;
    
    UILocalNotification *trackerNotification;
    UILocalNotification *autoStopNotification;
    
  
    
    bool pauseIdentify; 
    
    bool runIdentify;
    
    bool cellPuaseIdentifier;
    
    NSMutableArray *rewardDataArray;
}

@property (nonatomic,retain ) id <TrackCustomCellDelegate> totalTimeDelegate;

@property (nonatomic , retain) NSTimer   *_trackerTimer;

@property (nonatomic , retain) IBOutlet UIButton       *_runButton;
@property (nonatomic , retain) IBOutlet UILabel *_trackerNameLabel;
@property (nonatomic , retain) IBOutlet UILabel *_startingTimeLabel;
@property (nonatomic , retain) IBOutlet UILabel *_totalTimeLabel;
@property (nonatomic , retain) NSString         *_trackerSessionId;
@property (nonatomic , retain) NSString         *_trackerSession;


@property (nonatomic , retain) NSString        *storeDatStr;
//@property (nonatomic , retain) NSString        *endDateStr;


@property (nonatomic ) BOOL boolValue;
@property (nonatomic )  bool pauseIdentify; 
@property (nonatomic ) long   timeCounter ;

@property (nonatomic )  bool cellPuaseIdentifier;
@property (nonatomic )   long           backgoundCounter;

//background time check
@property (nonatomic )  bool runIdentify;
//@property (nonatomic ) int    minutes ;
//@property (nonatomic ) short  hours ;
@property (nonatomic ) long   pauseCounter ;

@property (retain ,nonatomic)   NSDate   *_startDateTime;
//@property (retain ,nonatomic)   NSDate   *_endDateTime;
@property (retain ,nonatomic)   NSDate   *_runningTime;
@property (retain ,nonatomic)   NSDate   *_storeStartDateTime;

@property (retain ,nonatomic)  IBOutlet UIImageView  *_strtStpBtnImgView;


@property (retain ,nonatomic)  NSString *categoryName;

@property (nonatomic)  BOOL   isRunning;


@property (nonatomic , retain)  NSString       *trackerGoal;
@property (nonatomic , retain)  NSString       *trackerAlarm;
@property (nonatomic , retain)  NSString       *trackerAutoStop;
//@property (nonatomic )          long           notificationTime;
//@property (nonatomic )         long            repeatNotificationTime;

@property (nonatomic , retain) UILocalNotification *trackerNotification;
@property (nonatomic , retain) UILocalNotification *autoStopNotification;

-(IBAction)trackerSession:(id)sender;

-(void)pauseTheTime;
-(void) stopRunningTracker;

-(void) createScheduleForLocalNotification;

-(void) popupViewCategoryName:(NSString *) categoryName1;

-(void) overAllPopup;

@end
