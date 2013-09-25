//
//  TrackViewController.h
//  iLifeTracker
//
//  Created by Umesh on 26/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtilClass.h"
#import "AddTrackerViewController.h"
#import "TrackerCustomCell.h"
#import "DataBaseController.h"
#import "TrackerDetailModel.h"
#import "TrackCustomCellDelegate.h"
#import "TrackerDetailViewController.h"
#import "CrntSessionModel.h"


@interface TrackViewController : UIViewController  <TrackCustomCellDelegate,ADBannerViewDelegate>{
    UIBarButtonItem         *leftNavigationbarItem;  //custom left navigationbaritem. 
    UIBarButtonItem         *rightNavigationbarItem;
    
    NSMutableArray          *_customCellObjArry;
    IBOutlet UITableView    *_trackersessionTableView;
    
    NSMutableArray          *_trackersNameArray;
    BOOL boolValue;
    
    NSMutableArray          *_newTrackerObjectArray;
    
     NSMutableArray         *_currentSessionArray;
    
    ADBannerView *adView;
    BOOL bannerIsVisible;
}
@property (nonatomic,assign) BOOL bannerIsVisible;


@property (nonatomic , retain)  NSMutableArray   *_customCellObjArry;
//-(IBAction)trackerSession:(id)sender;

//-(void) updateTotalTime;
-(void) runningCellWillAppear;
-(void) runningCellWillDisappear;
//-(void) timeBreak:(NSString *) time;

+(TrackViewController *) TrackSharedInstance;

-(double) timeBreak:(NSString *) runningTime;

-(NSDate *) convertIntoDateString:(NSString *) dateString;

@end
