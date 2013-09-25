//
//  SettingViewController.h
//  iLifeTracker
//
//  Created by Umesh on 26/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SettingViewController : UIViewController<ADBannerViewDelegate> {
    IBOutlet UITextView     *_aboutUsTextView;
    IBOutlet UILabel        *_notificationLabel;
    IBOutlet UILabel        *_aboutUsLabel;
    IBOutlet UISwitch       *_notificationSwch;
    
   
    
    BOOL ntfBoolValue;
    ADBannerView *adView;
    BOOL bannerIsVisible;
}
@property (nonatomic,assign) BOOL bannerIsVisible;


@property (nonatomic) BOOL ntfBoolValue;

-(IBAction)notificationOnAndOff:(id)sender;
+(SettingViewController *) shareInstanceSetting;

-(void) setNotification;

-(void) createNotificationSchedule:(UILocalNotification *) autoStopNotification autoStop:(NSString *)trackerAutoStop notificatinIdentifier:(bool ) cellPuaseIdentifier pushIdentify:(bool) pauseIdentify trackerName:(NSString *) trackerName
                  trackerSessionId:(NSString *)_trackerSessionId trackerGoal:(NSString *) trackerGoal trackerAlarm:(NSString *) trackerAlarm alarmNotification:(UILocalNotification *)trackerNotification _totalTimeLabel:(NSString *) totalTime currentTime:(NSString *) currentTime;

//-(void) time;

//-(IBAction)medo:(id)sender;
@end
