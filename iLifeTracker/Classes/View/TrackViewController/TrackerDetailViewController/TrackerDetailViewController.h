//
//  TrackerDetailViewController.h
//  iLifeTracker
//
//  Created by Umesh on 14/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtilClass.h"
#import "TrackerDetailCustomCell.h"
#import "DataBaseController.h"
#import "TrackerSessionModel.h"
#import "AddTrackerViewController.h"
#import "FbGraph.h"
#import "SBJSON.h"
#import "CQMFloatingController.h"
#import "PopupViewController.h"
#import "TrackViewController.h"

#import <Accounts/Accounts.h>
#import <Accounts/ACAccount.h>
#import <Accounts/ACAccountStore.h>
#import <Twitter/TWRequest.h>

@class SA_OAuthTwitterEngine;

@interface TrackerDetailViewController : UIViewController<ADBannerViewDelegate> {
  
    IBOutlet UIView         *_trackerDetailView;
    IBOutlet UITableView    *_trackerDetailTableView;
    
    NSString                *trackerName;
    NSString                *_trackerSession;
    NSString                *_trackerCategory;
    NSMutableArray          *_trackerSessionArray;
    
    IBOutlet UILabel        *_trackerNameLabel;
    IBOutlet UILabel        *_categoryLabel;
    IBOutlet UILabel        *_sessionNoLabel;
    IBOutlet UILabel        *_longestSessionlabel;
    IBOutlet UILabel        *_avgSessionNoLabel;
    IBOutlet UILabel        *_shortSessionNoLabel;
    
    int                     _longestSession;
    int                     _shortestSession;
    
    int                     _trackerTotalTime;
    int                     _trackerID;
    
//     IBOutlet UILabel        *_boldTitleLabel1;
//     IBOutlet UILabel        *_boldTitleLabel2;
//     IBOutlet UILabel        *_boldTitleLabel3;
//     IBOutlet UILabel        *_boldTitleLabel4;
//     IBOutlet UILabel        *_boldTitleLabel5;
//     IBOutlet UILabel        *_boldTitleLabel6;
//     IBOutlet UILabel        *_boldTitleLabel7;
    
    IBOutlet UIButton        *_historyBtn;
    IBOutlet UIButton        *_detailBtn;
    IBOutlet UIButton        *_fbBtn;
    IBOutlet UIButton        *_twtBtn;
    
     FbGraph                 *objFBGraph;
    
       SA_OAuthTwitterEngine *_engine;
    NSString                 *message;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    bool twtMessageSendIdentify;
    bool FaceBookMessageSendIdentify;
    
    int shareCounter;
    //
    ADBannerView *adView;
    bool  trackerIsRunning;
    BOOL bannerIsVisible;
}
@property (nonatomic,assign) BOOL bannerIsVisible;

+(TrackerDetailViewController *) shareInstanceTrackerDetail;

-(IBAction)trackerDetail:(id)sender;
-(IBAction)trackerHistory:(id)sender;
//-(NSString *) convetIntoTimeFormatSecond:(NSInteger) second;

-(IBAction)shareFaceBook:(id)sender;
-(IBAction)sharetwitter:(id)sender;

@property (nonatomic , retain ) NSString *trackerName;
@property (nonatomic , retain ) NSString *_trackerSession;
@property (nonatomic , retain ) NSString *_trackerCategory;
@property (nonatomic )  int   _trackerID;

@property (nonatomic )  int       _trackerTotalTime;

@property (nonatomic )  int shareCounter;
@property (nonatomic )  bool  trackerIsRunning;

@property (nonatomic , retain ) IBOutlet UIActivityIndicatorView *activityIndicator;
-(void) initTrackerDetail;

-(IBAction)shareFaceBookAndTwitter:(id)sender;


//-(IBAction)updateTwitter:(id)sender; 
//-(void)uplaodToTwitterimage:(UIImage*)image caption:(NSString*)caption;

-(void) showAlertForShareFBAndTwitter;

-(NSString *) dateInAMAndPMFormate:(NSString *) trackerDate;
//-(void) sendMessageOnTwitter;
//-(void) sendMessageOnFaceBook;
@end
