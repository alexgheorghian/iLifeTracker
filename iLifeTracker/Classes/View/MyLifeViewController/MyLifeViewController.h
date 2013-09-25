//
//  MyLifeViewController.h
//  iLifeTracker
//
//  Created by Umesh on 26/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginWithFacebook.h"
#import "FbGraph.h"
#import "SBJSON.h"
#import "LoginViewController.h"

#import "CorePlot-CocoaTouch.h"
#import "CustomGraph.h"
#import "MyLifeCustomCell.h"
#import "TrackerDetailModel.h"
#import "CommonUtilClass.h"
#import "TrackerSessionModel.h"
#import "CategoryInfoModel.h"

@interface MyLifeViewController : UIViewController <CPTPlotDataSource, UIActionSheetDelegate,ADBannerViewDelegate> {
    
    IBOutlet UIScrollView *_myLifeScrollView;
    
    IBOutlet UILabel      *_boldTitleLabel1;
    IBOutlet UILabel      *_boldTitleLabel2;
    IBOutlet UILabel      *_boldTitleLabel3;
    IBOutlet UILabel      *_boldTitleLabel4;
    IBOutlet UILabel      *_boldTitleLabel5;
    IBOutlet UILabel      *_boldTitleLabel6;
    
    IBOutlet UILabel      *_tolalTimeLabel ;
    IBOutlet UILabel      *_totalTrackersLabel  ;
    IBOutlet UILabel      *_mostUsedTrackerLebal;
    
    IBOutlet UILabel      *_CategoryLabel;
    IBOutlet UILabel      *_tolalTimeCtgLabel;
    IBOutlet UILabel      *_totalTrackerCtgLabel;
    IBOutlet UILabel      *_mostUsedTrackerCtgLabel;
    IBOutlet UILabel      *_recentActivityLabel;
    
    IBOutlet UIPickerView  *_categoryNamePickerView;
    IBOutlet UITableView   *_myLifeTableView;
     
    IBOutlet UILabel  *_categoryNameLabel;
    
    NSMutableArray    *_categoryArray;
    
    //
    NSMutableArray    *_myLifeInfoArray;
    
    int               trackerTotalTimeCounter;
    NSString          *_mostUseTracker;
    NSMutableArray    *trackerSessionArr;
    
    NSMutableArray    *recentActivityArr;
    IBOutlet UIView   *pickerClossView;
    
   ADBannerView *adView;
    BOOL bannerIsVisible;
}
@property (nonatomic,assign) BOOL bannerIsVisible;

//@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
//@property (nonatomic, strong) IBOutlet UIBarButtonItem *themeButton;
@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTTheme *selectedTheme;


@property (nonatomic, strong) NSMutableArray    *trackerSessionArr;
@property (nonatomic, strong) NSMutableArray    *recentActivityArr;
@property (nonatomic, strong) NSMutableArray    *_myLifeInfoArray;
@property (nonatomic, strong)  NSMutableArray   *_categoryArray;
-(void)initPlot;
-(void)configureHost;
-(void)configureGraph;
-(void)configureChart;
-(void)configureLegend;

-(IBAction)selectCategoryName:(id)sender;

//-(IBAction)logOut:(id)sender;

-(IBAction) closePickerView:(id)sender;
@end
