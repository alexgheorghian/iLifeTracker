//
//  RewardViewController.h
//  iLifeTracker
//
//  Created by Umesh on 26/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RwdCustomCell.h"
#import "DataBaseController.h"


#import "FbGraph.h"
#import "FbGraphFile.h"
#import "SBJSON.h"

#import <Accounts/Accounts.h>
#import <Accounts/ACAccount.h>
#import <Accounts/ACAccountStore.h>
#import <Twitter/TWRequest.h>


@interface RewardViewController : UIViewController<ADBannerViewDelegate> {
    
    IBOutlet UITableView *rwdTableView;
    NSMutableArray *rewardDataArray;
    int shareCounter;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
     FbGraph                 *objFBGraph;
    
    bool twtMessageSendIdentify;
    bool FaceBookMessageSendIdentify;
    
    IBOutlet UIButton        *_fbBtn;
    IBOutlet UIButton        *_twtBtn;
    IBOutlet UIButton        *_shareBtn;
    NSString *imageNameShare;
    NSString *shareSMS;
    
     ADBannerView *adView;
    
    NSMutableArray *_customRwdCellObjArry;
    BOOL bannerIsVisible;
}
@property (nonatomic,assign) BOOL bannerIsVisible;

@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

//-(IBAction)shareSocialMidea:(id)sender;
//-(IBAction)shareOnFaceBook:(id)sender;
//-(IBAction)shareOnTwitter:(id)sender;


-(void)showAlertForShareFBAndTwitter;

-(IBAction)shareFaceBookAndTwitter:(id)sender;
-(IBAction)sharetwitter:(id)sender;
-(IBAction)shareFaceBook:(id)sender;
//-(NSDate *) convertIntoDateString:(NSString *) dateString;

//-(void) breakTimeAccordingtoDate;

-(void) showAlertA;

+(RewardViewController *) shareInstanceReward;
@end
