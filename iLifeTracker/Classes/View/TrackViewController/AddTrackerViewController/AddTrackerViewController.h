//
//  AddTrackerViewController.h
//  iLifeTracker
//
//  Created by Umesh on 28/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtilClass.h"
#import "SelectCategoryViewController.h"
#import "DataBaseController.h"
#import "UpdateTrackerModel.h"

@interface AddTrackerViewController : UIViewController<ADBannerViewDelegate> {

    NSString              *title;
    IBOutlet UITextField  *_nameTextField;
    IBOutlet UIScrollView *_addTrackerScrollView;
    
    NSString              *_selectedCategoryName;
    IBOutlet UILabel      *_categoryNameLabel;
    IBOutlet UIButton     *_categoryNameButton;
    
    IBOutlet UIStepper   *_goalHourStepper;
    IBOutlet UILabel     *_goalHourLabel;
    
    IBOutlet UILabel      *_alarmLablel;
    IBOutlet UILabel      *_autoStopLabel;

    IBOutlet UISwitch    *_goalSwich;
    IBOutlet UISwitch    *_alarmSwitch;
    IBOutlet UISwitch    *_autoStopSwitch;
    
    IBOutlet UILabel     *_trackerNameTitleLabel;
    IBOutlet UILabel     *_categoryNameTitleLabel;
    
    IBOutlet UILabel     *_autoStopTtlLabel ;
    IBOutlet UILabel     *_autoStopNextTtlLabel;
    
    IBOutlet UISlider *_alarmSlider;
    IBOutlet UISlider *_notificationSlider;
    
    BOOL               editTracker;
    int          _TrackerID;
    
    NSMutableArray    *_trackerRecordArray;
    
   IBOutlet UIView    *touchView;
   ADBannerView *adView;
    BOOL bannerIsVisible;
}
@property (nonatomic,assign) BOOL bannerIsVisible;

@property (nonatomic , retain) NSString   *_selectedCategoryName;
//@property (nonatomic , retain) NSString   *title;

@property (nonatomic ) int          _TrackerID;;
@property (nonatomic ) BOOL    editTracker;


-(IBAction) alarmSliderChangeState:(id) sender;

-(IBAction)selectCategoryName:(id)sender;

-(IBAction)selectGoalHour:(id)sender;

-(IBAction)selectNotificationTime:(id)sender;

-(IBAction)SwichButtonOnAndOff:(id)sender;

@end
