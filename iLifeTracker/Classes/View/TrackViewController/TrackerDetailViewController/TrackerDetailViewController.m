//
//  TrackerDetailViewController.m
//  iLifeTracker
//
//  Created by Umesh on 14/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "TrackerDetailViewController.h"

#define NAVIGATIONTITLE          @"    Tracker Details"
#define EDITTRACKER              @"     Edit Tracker"

#define NAVIGATIONFELTBTNNAME    @"Back"

#define NAVIGATIONRIGHTBTNNAME   @"Edit"

#define HSTDLTSELECTEDBTN        @"detail_button.png"
#define HSTDLTNRMBTN             @"non_selected.png"

#define FBNORMALBTN              @"fb.png"
#define FBSELECTEDBTN            @"fb_Sel.png"
#define TWTNORMALBTN             @"twitter_sel.png"
#define TWTSELECTEDBTN           @"twitter.png"

@implementation TrackerDetailViewController
@synthesize trackerName,_trackerSession,_trackerCategory, _trackerID , _trackerTotalTime ,activityIndicator,shareCounter,trackerIsRunning;
@synthesize bannerIsVisible;
#pragma mark - View lifecycle
static bool fbBoolValue = YES;
static bool twtBoolValue = YES;
 static long currentSession = 0 ; 
//static   int shareCounter = 0;
//static  bool twiterAlertIdentify = NO;
static bool faceBookTwitterAlertIdentifier = YES;
static TrackerDetailViewController *objTrackerDetail;

+(TrackerDetailViewController *) shareInstanceTrackerDetail{
    if (objTrackerDetail == nil) {
        objTrackerDetail = [[TrackerDetailViewController alloc] init];
    }
    return objTrackerDetail;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Add label with navigation tittleview bar
    self.navigationItem.titleView =[CommonUtilClass navigationTittle:NAVIGATIONTITLE ];
    
    //set image on navigationbar.
    UIImage *image = [UIImage imageNamed:NAVIGATIONBARIMGNAME];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //set image on left navigationbar item.
    UIButton *leftNavigationbarButton = [CommonUtilClass setImage_OnNavigationbarButton:NAVIGATIONRIGHTBUTTONIMG buttonIdentifier:NAVIGATIONRIGHTBUTTON buttonName:NAVIGATIONFELTBTNNAME];
    UIBarButtonItem *leftNavigationbarItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavigationbarButton];
    [leftNavigationbarButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftNavigationbarItem;
    leftNavigationbarButton=nil;
    //Set image on right navigationbar item.
    UIButton *rightNavigationbarButton= [CommonUtilClass setImage_OnNavigationbarButton:NAVIGATIONRIGHTBUTTONIMG buttonIdentifier:NAVIGATIONLEFTBUTTON buttonName:NAVIGATIONRIGHTBTNNAME];
    UIBarButtonItem *rightNavigationbarItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavigationbarButton];
    [rightNavigationbarButton addTarget:self action:@selector(editTracker) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightNavigationbarItem;
    rightNavigationbarButton=nil;
    
    //
    _trackerDetailView.backgroundColor      = [UIColor clearColor];
    _trackerDetailTableView.backgroundColor = [UIColor clearColor]; 
        
   // NSLog(@" detail : -> %d",[_trackerSessionArray count]);
    _trackerDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [_boldTitleLabel1 setFont:[UIFont fontWithName:FONTNAME size:24]];
//    [_boldTitleLabel2 setFont:[UIFont fontWithName:FONTNAME size:24]];
//    [_boldTitleLabel3 setFont:[UIFont fontWithName:FONTNAME size:24]];
//    [_boldTitleLabel4 setFont:[UIFont fontWithName:FONTNAME size:24]];
//    [_boldTitleLabel5 setFont:[UIFont fontWithName:FONTNAME size:24]];
//    [_boldTitleLabel6 setFont:[UIFont fontWithName:FONTNAME size:24]];
//    [_boldTitleLabel7 setFont:[UIFont fontWithName:FONTNAME size:24]];
    shareCounter = 0;
    activityIndicator.hidden = YES;
    
    //
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        banner.frame = CGRectOffset(banner.frame, 0, 50);
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // banner is visible and we move it out of the screen, due to connection issue
        banner.frame = CGRectOffset(banner.frame, 0, -50);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    // NSLog(@"Banner view is beginning an ad action");
    BOOL shouldExecuteAction = YES;
    if (!willLeave && shouldExecuteAction)
    {
        // stop all interactive processes in the app
        // [video pause];
        // [audio pause];
    }
    return shouldExecuteAction;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    // resume everything you've stopped
    // [video resume];
    // [audio resume];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if([[UIScreen mainScreen] bounds].size.height == 568.0f || [[UIScreen mainScreen] bounds].size.width == 568.0f){
        adView.frame = CGRectMake(0,405,320,50);
    }
    else{
        adView.frame = CGRectMake(0,315,320,50);
    }
}

-(void) viewWillAppear:(BOOL)animated{
    
   
    CommonUtilClass *commonObj = [CommonUtilClass CommonUtilSharedInstance];
    adView.backgroundColor = [UIColor clearColor];
    adView = [commonObj iADView];
    //adView.delegate = self;
    [self.view addSubview:adView];
    [self.view bringSubviewToFront:adView];
    [self initTrackerDetail];
    if([[UIScreen mainScreen] bounds].size.height == 568.0f || [[UIScreen mainScreen] bounds].size.width == 568.0f){
        adView.frame = CGRectMake(0,455,320,50);
    }
    else{
        adView.frame = CGRectMake(0,365,320,50);
    }
    [_historyBtn setSelected:NO];
    [_detailBtn setSelected:YES];
    [_historyBtn setBackgroundImage:[UIImage imageNamed:HSTDLTNRMBTN] forState:UIControlStateSelected];  
    [_detailBtn setBackgroundImage:[UIImage imageNamed:HSTDLTSELECTEDBTN] forState:UIControlStateNormal]; 
    [_trackerDetailTableView reloadData];
    
    message =  [NSString stringWithFormat:@"Tracker Name : %@ (%@) \n Number of sessions: %@ \n Longest Session : %@ \n Avg Session : %@ \n Shortest Session : %@ ",trackerName,_trackerCategory,_sessionNoLabel.text,_longestSessionlabel.text,_avgSessionNoLabel.text, _shortSessionNoLabel.text];
    //message = @"hello";
    //
    currentSession = _trackerTotalTime;
}



-(void) initTrackerDetail{
    bool boolValue = TRUE;
    _trackerDetailTableView.hidden = YES;
    _trackerDetailView.hidden = NO;
    
    DataBaseController *obj = [DataBaseController DBControllerharedInstance];
    _trackerSessionArray    = [obj  trackerSessionDetailTrackerName:_trackerID] ;
    
    _trackerNameLabel.text =[obj currentTrackerNameTrackerId:_trackerID]; 
    
    _shortestSession = 0;
    _longestSession = 0;
    _trackerSession = @"00:00:00";
    
    for (TrackerSessionModel *objTrackerSession in _trackerSessionArray){
        if (boolValue ) {
            _longestSession = [objTrackerSession.trackerSesion intValue];
            _shortestSession = [objTrackerSession.trackerSesion intValue];
            _trackerSession = objTrackerSession.trackerTotalTime;
            //_trackerNameLabel.text = objTrackerSession.trackerName;
            boolValue = FALSE;
        }else{
            if ([objTrackerSession.trackerSesion intValue]>_longestSession) {
                _longestSession = [objTrackerSession.trackerSesion intValue]; 
            }
            if ([objTrackerSession.trackerSesion intValue] < _shortestSession ) {
                _shortestSession = [objTrackerSession.trackerSesion intValue];  
            }
        }
    }
    
    //Set Detail page
   // NSArray *sessionArr = [[NSArray alloc] init ];
    long sessionArr =  [_trackerSession intValue];
    long   totalTime;
    totalTime    = sessionArr;
    
        if ([_trackerSessionArray count] > 0) {
        _avgSessionNoLabel.text = [CommonUtilClass convetIntoTimeFormatSecond:(totalTime/[_trackerSessionArray count])];
    } else{
        _avgSessionNoLabel.text = [CommonUtilClass convetIntoTimeFormatSecond:totalTime]; 
    }
    //_trackerNameLabel.text = trackerName;
    _sessionNoLabel.text =  [NSString stringWithFormat:@"%d",[_trackerSessionArray count]];  
    _shortSessionNoLabel.text = [CommonUtilClass convetIntoTimeFormatSecond:_shortestSession] ;
    _longestSessionlabel.text = [CommonUtilClass convetIntoTimeFormatSecond:_longestSession] ;
    _categoryLabel.text = _trackerCategory;
}





-(void) goBack{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void) editTracker{
    NSLog(@"trackerIsRunning :-> %i",trackerIsRunning);
    if (!trackerIsRunning) {
        
    AddTrackerViewController *obj = [AddTrackerViewController new];
    obj.editTracker = YES;
    obj._TrackerID = _trackerID;
    obj.title   = EDITTRACKER;
    
    [self.navigationController pushViewController:obj animated:YES];
    }
}


#pragma mark -
#pragma mark trackerDetail button
-(IBAction)trackerDetail:(id)sender{
    
    _trackerDetailView.hidden = NO ;
    _trackerDetailTableView.hidden = YES;
    [self initTrackerDetail];
    [_historyBtn setSelected:NO];
    [_detailBtn setSelected:YES];
    
    [_historyBtn setBackgroundImage:[UIImage imageNamed:HSTDLTNRMBTN] forState:UIControlStateSelected];  
    
    [_detailBtn setBackgroundImage:[UIImage imageNamed:HSTDLTSELECTEDBTN] forState:UIControlStateNormal]; 
    
}


#pragma mark -
#pragma mark tracker History button
-(IBAction)trackerHistory:(id)sender{
    _trackerDetailView.hidden = YES ;
    _trackerDetailTableView.hidden = NO;
    
    [_historyBtn setSelected:YES];
    [_detailBtn setSelected:NO];
    
    [_historyBtn setBackgroundImage:[UIImage imageNamed:HSTDLTSELECTEDBTN] forState:UIControlStateSelected];  
    
    [_detailBtn setBackgroundImage:[UIImage imageNamed:HSTDLTNRMBTN] forState:UIControlStateNormal]; 
}




#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_trackerSessionArray count];//[[parser xmlDataArray] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    TrackerDetailCustomCell *cell = (TrackerDetailCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TrackerDetailCustomCell" owner:nil options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    TrackerSessionModel *obj            = [_trackerSessionArray objectAtIndex:indexPath.row];
    [self dateInAMAndPMFormate:obj.trackerStartTime];
    [cell  startTimeLbl].text           =[self dateInAMAndPMFormate:obj.trackerStartTime];// obj.trackerStartTime;
    [cell  endTimeLbl].text             =[self dateInAMAndPMFormate:obj.trackerEndTime];// obj.trackerEndTime;
    [cell  durationTimeLbl].text        = [CommonUtilClass convetIntoTimeFormatSecond:[obj.trackerSesion intValue]];
    
    [cell.boldTitleLabel1 setFont:[UIFont fontWithName:FONTNAME size:24]];
    [cell.boldTitleLabel2 setFont:[UIFont fontWithName:FONTNAME size:24]];
    [cell.boldTitleLabel3 setFont:[UIFont fontWithName:FONTNAME size:24]];
    return cell;
}


-(NSString *) dateInAMAndPMFormate:(NSString *) trackerDate{
    NSArray *array;
    NSString *time ;
    NSString *amPm ;
    NSString *date;
    @try {
        array = [trackerDate componentsSeparatedByString:@" "]; 
        time = [array objectAtIndex:0];
        amPm = [array objectAtIndex:1];
        date = [array objectAtIndex:2];
    }
    @catch (NSException *exception) {
        if(LOGS_ON)   NSLog(@" TrackDetailViewController : dateInAMAndPMFormate : NSException ");
    }
    
    NSArray   *crttimeArray;
    NSString  *crthours ;
    NSString  *crtminute ;
    NSString  *crtsecond ;
    @try {
    crttimeArray = [time componentsSeparatedByString:@":"];
    
    crthours  = [crttimeArray objectAtIndex:0];
    crtminute = [crttimeArray objectAtIndex:1];
    crtsecond = [crttimeArray objectAtIndex:2];
    }
    @catch (NSException *exception) {
        if(LOGS_ON)   NSLog(@" TrackDetailViewController : dateInAMAndPMFormate : NSException ");
    }
    int hours = [crthours intValue];
    
    if ([amPm isEqualToString:@"PM"]) {
        if ( hours > 12) {
            hours = hours - 12;
             //NSLog(@" time divition trackerTimeAndDate :-> %i ",hours);
        }
       
    }
    NSString *trackerTimeAndDate = [NSString stringWithFormat:@"%i:%@:%@ %@ %@",hours,crtminute,crtsecond,amPm,date];
    //NSLog(@" *****************************************");
    return trackerTimeAndDate;
}



- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}


//
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        TrackerSessionModel *objTrackerSession   = [_trackerSessionArray objectAtIndex:indexPath.row];
      
        currentSession   = currentSession - [objTrackerSession.trackerSesion intValue];
      //  NSLog(@" currentSession  :-> %ld  trackerSesion: -> %i ",currentSession ,[objTrackerSession.trackerSesion intValue]  );
        DataBaseController *obj = [DataBaseController DBControllerharedInstance];
        //Delete session record 
        [obj deleteTrackerSessionRow:[objTrackerSession.trackerId intValue]];
        // Update Total Time
        [obj updateTackerSessionTrackerName:_trackerID trackerSetion:[NSString stringWithFormat:@"%d",currentSession]];
        [_trackerSessionArray removeObjectAtIndex:indexPath.row];
        [aTableView reloadData];
    } 
}


-(IBAction)shareFaceBook:(id)sender{
   // UIButton *fbButton;
    NSURL        *requestUrl = [NSURL URLWithString:@"http://www.google.com"];
   // NSURLRequest *requestObj = [NSURLRequest requestWithURL:requestUrl];
    NSData       *loadTest   = [NSData dataWithContentsOfURL:requestUrl];
    
//    if (loadTest == nil) {
//        NSLog(@"No internet");
//    } else {
//        NSLog(@"Yes internet");
//    }
    if(loadTest != nil){
    if (fbBoolValue) {
        [_fbBtn setSelected:YES];
        //[_fbBtn setBackgroundImage:[UIImage imageNamed:FBSELECTEDBTN] forState:UIControlStateSelected];
        fbBoolValue = NO; 
        //NSLog(@"select facebook ");
        
        objFBGraph = [[FbGraph alloc]initWithFbClientID:FbClientID];
        //mark some permissions for your access token so that it knows what permissions it has
        [objFBGraph authenticateUserWithCallbackObject:self andSelector:@selector(FBGraphResponse) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins,publish_checkins,email"];
        activityIndicator.hidden = NO;
       // activityIndicator =[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 200, 100, 100)];
        //activityIndicator = CGRectMake(200, 50, 100, 100);
        activityIndicator.color = [UIColor redColor];
        //[self.view addSubview:activityIndicator];
        [activityIndicator startAnimating];
           //NSLog(@" shareFaceBook  selected");
        
    } else{
        [_fbBtn setSelected:NO];
       // [_fbBtn setBackgroundImage:[UIImage imageNamed:FBNORMALBTN] forState:UIControlStateNormal];
        fbBoolValue = YES;   
    }
    }else {
        CommonUtilClass *obj = [CommonUtilClass CommonUtilSharedInstance];
        [obj  showAlertView:@"NO internet" title:@"Share"];
    }
   
}



- (void)FBGraphResponse
{
    @try 
    {
        if (objFBGraph.accessToken) 
        {
            [activityIndicator stopAnimating];
            activityIndicator.hidden = YES;

        }
    }
    @catch (NSException *exception) {
        
        activityIndicator.hidden = YES;
        [activityIndicator stopAnimating];
        // NSLog(@"NSException in facebook connection : -> %@",exception);
    }
}



#define UPDATE_WITH_MEDIA_TWITTER @"https://upload.twitter.com/1/statuses/update_with_media.json"
#define UPDATE_WITH_TEXT_TWITTER @"https://api.twitter.com/1/statuses/update.json"

-(IBAction)sharetwitter:(id)sender{
    
    if (twtBoolValue) {
       //   NSLog(@" sharetwitter  selected");
        [_twtBtn setSelected:YES];
      //  [_twtBtn setBackgroundImage:[UIImage imageNamed:TWTSELECTEDBTN] forState:UIControlStateSelected];
        twtBoolValue = NO; 
        
                
    }else{
        
        [_twtBtn setSelected:NO];
      //  [_twtBtn setBackgroundImage:[UIImage imageNamed:TWTNORMALBTN] forState:UIControlStateNormal];
        twtBoolValue = YES; 
    }
}


-(IBAction)shareFaceBookAndTwitter:(id)sender{
    NSURL        *requestUrl = [NSURL URLWithString:@"http://www.google.com"];
    // NSURLRequest *requestObj = [NSURLRequest requestWithURL:requestUrl];
    NSData       *loadTest   = [NSData dataWithContentsOfURL:requestUrl];
    
    //    if (loadTest == nil) {
    //        NSLog(@"No internet");
    //    } else {
    //        NSLog(@"Yes internet");
    //    }
    if(loadTest != nil){
        
       
        
        if (!twtBoolValue) {
            // NSLog(@" twtBoolValue  selected"); 
            
            
            ACAccountStore *account = [[ACAccountStore alloc] init];
            ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            
            // Request access from the user to access their Twitter account
            [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error)
             {
                  twtMessageSendIdentify = NO; 
                 // Did user allow us access?
                 if (granted == YES)
                 {
                     //twiterAlertIdentify = YES;
                     // Populate array with all available Twitter accounts
                     NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                     
                     // Sanity check
                     if ([arrayOfAccounts count] > 0){
                         
                         if(LOGS_ON) NSLog(@" user login with twitter");
                         
                         // Keep it simple, use the first account available
                         ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                         
                         // Build a twitter request
                         TWRequest *postRequest = nil; 
                         NSData *myData = nil;
                         
                         UIImage *image;
                         
                         if( image )
                         {
                             postRequest = [[TWRequest alloc] initWithURL: [NSURL URLWithString:UPDATE_WITH_MEDIA_TWITTER] parameters:nil requestMethod:TWRequestMethodPOST];
                             
                             myData = UIImagePNGRepresentation(image);
                             [postRequest addMultiPartData:myData withName:@"media" type:@"image/png"];
                              NSLog(@" track detail image twit");
                         }
                         else
                         {
                             postRequest = [[TWRequest alloc] initWithURL:  [NSURL URLWithString:UPDATE_WITH_TEXT_TWITTER] parameters:nil requestMethod:TWRequestMethodPOST];
                         }
                         myData = [message dataUsingEncoding:NSUTF8StringEncoding];
                         [postRequest addMultiPartData:myData withName:@"status" type:@"text/plain"];
                         
                         
                         // Post the request
                         [postRequest setAccount:acct];
                         
                         // Block handler to manage the response
                         [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                          {
                              if(LOGS_ON) NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
                              if (responseData)
                              {
                                  // Parse the JSON response
                                  NSError *jsonError = nil;
                                  //id resp = [NSJSONSerialization JSONObjectWithData:responseData
                                  //                                          options:0
                                  //                                            error:&jsonError];
                                  if (jsonError) {
                                      if(LOGS_ON)  NSLog(@"Json Parsing Error :%@", [jsonError localizedDescription]);
                                      twtMessageSendIdentify = NO;
                                  }
                                  else{
                                     //  NSLog(@"JSON RESPONSE AFTER UPLOAD ->%@",resp);
                                      twtMessageSendIdentify = YES;
                                      
                                      if (fbBoolValue) {
                                           [self performSelectorOnMainThread:@selector(showAlertForShareFBAndTwitter) withObject:nil waitUntilDone:NO];
                                          // NSLog(@"message send on twtBoolValue");
                                      }else{
                                          if(faceBookTwitterAlertIdentifier){
                                              faceBookTwitterAlertIdentifier = NO; 
                                          }else{
                                              [self performSelectorOnMainThread:@selector(showAlertForShareFBAndTwitter) withObject:nil waitUntilDone:NO];
                                          }
                                      }
                                      
                                  }}}];
                     }
                 } else{
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]]; 
                     //twiterAlertIdentify = NO;
                 }
             }];
            
        //  [self showAlertForShareFBAndTwitter];  
           
        } else if(twtBoolValue){
             //NSLog(@" twtBoolValue not selected");  
            twtMessageSendIdentify = NO; 
            //[self showAlertForShareFBAndTwitter];
              
        }
        if (fbBoolValue) {
            if(LOGS_ON)  NSLog(@" facebook  selected");
            FaceBookMessageSendIdentify = NO;
        }else if(!fbBoolValue){
            
//            NSMutableDictionary *variable = [[NSMutableDictionary alloc]initWithCapacity:1];
//            [variable setObject:message forKey:@"message"];
//            [objFBGraph doGraphPost:@"me/feed" withPostVars:variable];  
            NSMutableDictionary *variable = [[NSMutableDictionary alloc]initWithCapacity:1];
            [variable setObject:message forKey:@"message"];
            [objFBGraph doGraphPost:@"me/feed" withPostVars:variable];
            NSLog(@"message send on face book");
            FaceBookMessageSendIdentify = YES;
            if (twtBoolValue) {
                [self performSelectorOnMainThread:@selector(showAlertForShareFBAndTwitter) withObject:nil waitUntilDone:NO];
               // NSLog(@"message send on twtBoolValue");
            }else{
                if(faceBookTwitterAlertIdentifier){
                    faceBookTwitterAlertIdentifier = NO; 
                }else{
                   [self performSelectorOnMainThread:@selector(showAlertForShareFBAndTwitter) withObject:nil waitUntilDone:NO];
                }
            }
        }
    }else {
        CommonUtilClass *obj = [CommonUtilClass CommonUtilSharedInstance];
        [obj  showAlertView:@"NO internet" title:@"Share"];
        
    }
    
    //[NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(showAlert) userInfo:nil repeats:NO];
}


//-(void) showAlert{
//   // NSLog(@"*****************  showAlert");
//    [self showAlertForShareFBAndTwitter];
//}
    


-(void)showAlertForShareFBAndTwitter{
    shareCounter = [[NSUserDefaults standardUserDefaults] integerForKey:@"number"];
    shareCounter ++;
   
    
    // NSLog(@"***************** after twitter            shareCounter :-> %i",shareCounter);
    NSString *messageText;
    if ((twtMessageSendIdentify) && (FaceBookMessageSendIdentify)) {
         messageText = @"Tracker details successfully shared on Facebook and Twitter"; 
        CommonUtilClass *obj = [CommonUtilClass CommonUtilSharedInstance];
        [obj  showAlertView:messageText title:@"Share"]; 
        
                
    }
    else if (twtMessageSendIdentify) {
        messageText = @"Tracker details successfully shared on Twitter";
        CommonUtilClass *obj = [CommonUtilClass CommonUtilSharedInstance];
        [obj  showAlertView:messageText title:@"Share"]; 
         // NSLog(@"share tracker detail on social media ");
    }else if(FaceBookMessageSendIdentify){
        messageText = @"Tracker details successfully shared on Facebook";
        CommonUtilClass *obj = [CommonUtilClass CommonUtilSharedInstance];
        [obj  showAlertView:messageText title:@"Share"];
    }
    faceBookTwitterAlertIdentifier = YES;
    
    
    
    
    // Social Media
    // TrackerDetailViewController *objTrackerDetail = [TrackerDetailViewController shareInstanceTrackerDetail];
    //shareCounter = objTrackerDetail.shareCounter;
    // NSLog(@" shareCounter :-> %i",shareCounter);
    
    NSArray *intervalArray1 = nil;
    short numberofStarSelected1;
    NSString *imageName;
    DataBaseController *obj1 = [DataBaseController DBControllerharedInstance];
    NSMutableArray *rewardDataArrayStartic = [obj1 selectRewardMessageDataCategoryName];
    for (RwardMessageModel *objRewardSMS in rewardDataArrayStartic) {
        
        if ([@"Social Media" isEqualToString:objRewardSMS.categoryName]) {
            
            numberofStarSelected1 = [ objRewardSMS.starCount intValue];
           // NSLog(@"");
            //imageName            = objRewardSMS.rewardImage;
            imageName            = objRewardSMS.rewardImage;
            intervalArray1 = [objRewardSMS.rewardInterval componentsSeparatedByString:@","]; 
        }
    }
    
    
    short totalStar1 = 0;
     int totalTimeForTotalStar;
    for (NSString *str in intervalArray1) {
        
        int interval = [str intValue];
        // NSLog(@" interval cfcbvbcv :-> %i",interval);
        if(shareCounter < interval )
        {
            break;
        }
          totalTimeForTotalStar = [str intValue]; 
        totalStar1++;
    }
    
    
    
    
    NSString *messageShare;
    NSString *shareOnShocialMidea;
    
    for (RwardMessageModel *objRewardSMS in rewardDataArrayStartic) {
        //NSLog(@"reward message data category name Track Cell :-> %@", objRewardSMS.starCount);
        if ([@"Social Media" isEqualToString:objRewardSMS.categoryName]) {
            // PopupViewController *objPopup = [[PopupViewController alloc] init];
            if (totalStar1 == 1) {
                messageShare = objRewardSMS.rewardMessage1;
                
                // shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  %@ category for tracking %i hours of activitiy.",totalStar1,_trackerCategory,totalTimeForTotalStar];
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  Social Media  for tracking %i Media of activity.",totalStar1,shareCounter];
                //NSString *str1 = [str stringByAppendingFormat:@"star of the %",categoryName1];
                //NSString *str1 = [@" star of the " stringByAppendingFormat:@"%",categoryName1];
                
                //=@"I just unlocked the 3rd star of the Sports category for tracking 50 hours of activitiy.";
                // NSLog(@"message 1 :-> %@ :-> %@",messageShare,shareOnShocialMidea);
                break;
            }else if (totalStar1 == 2) {
                messageShare = objRewardSMS.rewardMessage2;
                
                //shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  %@ category for tracking %i hours of activitiy.",totalStar,_trackerCategory,totalTimeForTotalStar];
                //  NSLog(@"message 2 :-> %@ :-> %@",messageShare,shareOnShocialMidea);
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  Social Media  for tracking %i Media of activity.",totalStar1,shareCounter];
                break;
            }else if (totalStar1 == 3) {
                messageShare = objRewardSMS.rewardMessage3;
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  Social Media  for tracking %i Media of activity.",totalStar1,shareCounter];                
                //shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  %@ category for tracking %i hours of activitiy.",totalStar1,_trackerCategory,totalTimeForTotalStar];
                //NSLog(@"message 3:-> %@ :-> %@",messageShare,shareOnShocialMidea);
                break;
            }else if (totalStar1 == 4) {
                messageShare = objRewardSMS.rewardMessage4;
                
                //shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  %@ category for tracking %i hours of activitiy.",totalStar1,_trackerCategory,totalTimeForTotalStar];
                //  NSLog(@"message 4:-> %@ :-> %@",messageShare,shareOnShocialMidea);
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  Social Media  for tracking %i Media of activity.",totalStar1,shareCounter];
                break;
            }else if (totalStar1 == 5) {
                messageShare = objRewardSMS.rewardMessage4;
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  Social Media  for tracking %i Media of activity.",totalStar1,shareCounter];                // shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  %@ category for tracking %i hours of activitiy.",totalStar,categoryName1,totalTimeForTotalStar];
                // NSLog(@"message 5:-> %@ :-> %@",messageShare,shareOnShocialMidea); 
                break;
                
            }
        }
    }
    
     
    // NSLog(@"numberofStarSelectedr  :-> %i",numberofStarSelected1);
    //NSLog(@"totalStar  :-> %i",totalStar1);
    if((numberofStarSelected1 < totalStar1)){ 
        
        PopupViewController *demoViewController = [[PopupViewController alloc] init];
        // 2. Get shared floating controller
        CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
        
        floatingController.selectedImageCounter  = totalStar1; 
        floatingController.imageName = imageName;
        floatingController.message = messageShare;
        floatingController.messageShareOnTwtAndFB = shareOnShocialMidea;
         floatingController.socialMediaIdentify = YES;
        floatingController.overallIndtify = YES;
        [floatingController showInView:self.view
             withContentViewController:demoViewController
                              animated:YES];
        [obj1 updateRewardStarCountCatregoryName:@"Social Media" trackerSetion:[NSString stringWithFormat:@"%i",totalStar1]];
        
    }
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:shareCounter forKey:@"number"];
}


@end
