//
//  RewardViewController.m
//  iLifeTracker
//
//  Created by Umesh on 26/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RewardViewController.h"
#import "TrackerDetailViewController.h"

#define GENERALIMAGE        @""
#define SPORTIMAGE          @"Sports.png"
#define WORKIMAGE           @"work.png"
#define TRAVELIMAGE         @"travel.png"
#define LIFESTYLE           @"lifestyle.png"
#define INTERNETIMAGE       @"internet.png"
#define SHOPPINGIMAGE       @"shopping.png"
#define OVERALLIMAGE        @""
#define SOCIALMEDIAIMAGES   @"social_media.png"

#define DEFAUTLIMAGE @"blanks_icon.png"
//stopwatch.png
//trophy.png
#define STARSELECTED @"golden_star.png"
#define STARNORMAL   @"pop_up_white_star_ipad.png"


@implementation RewardViewController
@synthesize activityIndicator;
@synthesize bannerIsVisible;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Rewards";
        self.tabBarItem.image = [UIImage imageNamed:@"rewards"];
    }
    return self;
}



static RewardViewController *objReward;

+(RewardViewController *) shareInstanceReward{
    if (objReward == nil) {
        objReward = [[RewardViewController alloc] init];
    }
    return objReward;
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
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:NAVIGATIONBARIMGNAME];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    // Do any additional setup after loading the view from its nib.
    
    rwdTableView.backgroundColor = [UIColor blackColor];
    rwdTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //
    
    
    _customRwdCellObjArry = [NSMutableArray new];
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

-(void) viewWillAppear:(BOOL)animated{
    
    CommonUtilClass *commonObj = [CommonUtilClass CommonUtilSharedInstance];
    adView.backgroundColor = [UIColor clearColor];
    adView = [commonObj iADView];
    //adView.delegate = self;
    [self.view addSubview:adView];
    [self.view bringSubviewToFront:adView];
    DataBaseController *obj = [DataBaseController DBControllerharedInstance];

    // rewardDataArray = [obj selectRewardMessageDataCategoryName];
    
    long totalTime = [obj totalTimeAllOver];

    //NSLog(@" total time :-> %ld",totalTime);
    
     activityIndicator.hidden = YES;
    
    
    //
    NSMutableArray *rewardDataArrayStartic = [obj selectRewardMessageDataCategoryName];
    
    NSArray *intervalArray = nil;
    short numberofStarSelected;
    NSString *imageName;
    
    for (RwardMessageModel *objRewardSMS in rewardDataArrayStartic) {
      
        if ([@"Overall" isEqualToString:objRewardSMS.categoryName]) {
           
            numberofStarSelected = [ objRewardSMS.starCount intValue];
            imageName            = objRewardSMS.rewardImage;
            intervalArray = [objRewardSMS.rewardInterval componentsSeparatedByString:@","]; 
        }
    }
        
    
    short totalStar = 0;
    for (NSString *str in intervalArray) {
        
        int interval = [str intValue]*3600;
        if(totalTime  <= interval)
        {
            break;
        }
        totalStar++;
    }
    //  NSLog(@"numberofStarSelectedr  :-> %i",numberofStarSelected);
    //  NSLog(@"totalStar  :-> %i",totalStar);
    if((numberofStarSelected < totalStar)){ 

        [obj updateRewardStarCountCatregoryName:@"Overall" trackerSetion:[NSString stringWithFormat:@"%i",totalStar]];
    }
    
//    TrackerDetailViewController *objTrackerDetail = [TrackerDetailViewController shareInstanceTrackerDetail];
//        shareCounter = objTrackerDetail.shareCounter;
//        NSLog(@" shareCounter :-> %i",shareCounter);
    
   // Social Media
    TrackerDetailViewController *objTrackerDetail = [TrackerDetailViewController shareInstanceTrackerDetail];
    shareCounter = objTrackerDetail.shareCounter;
   // NSLog(@" shareCounter :-> %i",shareCounter);
    
    NSArray *intervalArray1 = nil;
    short numberofStarSelected1;
   // NSString *imageName1;
    
    for (RwardMessageModel *objRewardSMS in rewardDataArrayStartic) {
        
        if ([@"Social Media" isEqualToString:objRewardSMS.categoryName]) {
            
            numberofStarSelected1 = [ objRewardSMS.starCount intValue];
            imageName            = objRewardSMS.rewardImage;
            intervalArray1 = [objRewardSMS.rewardInterval componentsSeparatedByString:@","]; 
        }
    }
    
    
    short totalStar1 = 0;
    for (NSString *str in intervalArray1) {
        
        int interval = [str intValue];
       // NSLog(@" interval cfcbvbcv :-> %i",interval);
        if(shareCounter < interval)
        {
            break;
        }
        totalStar1++;
    }
   // NSLog(@"numberofStarSelectedr  :-> %i",numberofStarSelected1);
    //NSLog(@"totalStar  :-> %i",totalStar1);
   // if((numberofStarSelected1 < totalStar1)){ 
        
     //   [obj updateRewardStarCountCatregoryName:@"Social Media" trackerSetion:[NSString stringWithFormat:@"%i",totalStar1]];
    //}

    
    rewardDataArray = [obj selectRewardMessageDataCategoryName];
    
    //
    RwardMessageModel *objRewardSMS = [rewardDataArray objectAtIndex:0];
    int rewardCounter = [objRewardSMS.starCount intValue];
    imageNameShare = objRewardSMS.rewardImage;
    if(rewardCounter >0){
        // [cell.categoryImageView setImage:[UIImage imageNamed:objRewardSMS.rewardImage]];
        
        NSArray *intervalArray = [objRewardSMS.rewardInterval componentsSeparatedByString:@","]; 
        if((rewardCounter <= [intervalArray count] )){
            
            //I have reached 3 stars out of 5 for tracking 50 hours of Travel
            NSString *noStar = [@"I have reached " stringByAppendingString:[NSString stringWithFormat:@"%i stars out of  5 for tracking ",rewardCounter]];
            NSString *nextStarHours = [noStar stringByAppendingString:[intervalArray objectAtIndex:(rewardCounter-1)]];
            NSString *sendMessage = [nextStarHours stringByAppendingString:@"  hours of "];
            shareSMS =[sendMessage stringByAppendingString:objRewardSMS.categoryName];
            _shareBtn.enabled = YES;
            _twtBtn.enabled = YES; 
            _fbBtn.enabled  = YES;
        }
    }else{
        //NSLog(@" reward value :-> %i",rewardCounter);
        _shareBtn.enabled = NO;
        _twtBtn.enabled = NO; 
        _fbBtn.enabled  = NO;
    }
    //
    
    
    [rwdTableView reloadData];
}

#pragma mark :->
#pragma mark Tableview Datasource mathod .
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [rewardDataArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        
//        static NSString *CellIdentifier = @"Cell";
//        RwdCustomCell *cell = (RwdCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil) {
//            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RwdCustomCell" owner:nil options:nil];
//            cell = [topLevelObjects objectAtIndex:0];
//        }
    
    
    //TrackerDetailModel *objTrackerDetailModel = [_trackersNameArray objectAtIndex:indexPath.row];
    
    RwdCustomCell *cell ; // = (TrackerCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    @try {
        cell =  [_customRwdCellObjArry objectAtIndex:indexPath.row];
    }
    @catch (NSException *exception) {
        //if(LOGS_ON)  NSLog(@"TrackViewController : cellForRowAtIndexPath :error -> %@",exception);
    }
    
    if (cell == nil) 
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RwdCustomCell" owner:nil options:nil];
        //if(LOGS_ON) NSLog(@"TrackViewController : cellForRowAtIndexPath : new cell create");
        //        [_customCellObjArry addObject:[topLevelObjects objectAtIndex:0]];
        [_customRwdCellObjArry insertObject:[topLevelObjects objectAtIndex:0] atIndex:indexPath.row];
        cell =  [_customRwdCellObjArry objectAtIndex:indexPath.row];
    
    }
    
    RwardMessageModel *objRewardSMS = [rewardDataArray objectAtIndex:indexPath.row];
    cell.smsTextView.editable = NO;
    cell.smsTextView.scrollEnabled = NO;
    cell.smsTextView.backgroundColor = [UIColor clearColor];
    cell.smsTextView.userInteractionEnabled = NO;
    int rewardCounter = [objRewardSMS.starCount intValue];
     NSArray *intervalArray = [objRewardSMS.rewardInterval componentsSeparatedByString:@","];
    if(rewardCounter >0 && rewardCounter < 5){
        [cell.categoryName setText:@""];
    [cell.categoryImageView setImage:[UIImage imageNamed:objRewardSMS.rewardImage]];
        
       
        if((rewardCounter < [intervalArray count] ) && (indexPath.row != 8)){
       // NSLog(@" image : -> %@",[intervalArray objectAtIndex:rewardCounter]);
            NSString *nextStarHours = [@"Next Star at " stringByAppendingString:[intervalArray objectAtIndex:rewardCounter]];
            cell.smsTextView.text =[nextStarHours stringByAppendingString:@"  hours !"];
        }else{
            //NSLog(@" image : -> %@",[intervalArray objectAtIndex:rewardCounter]);
            NSString *nextStarHours = [@"Next Star at " stringByAppendingString:[intervalArray objectAtIndex:rewardCounter]];
            cell.smsTextView.text =[nextStarHours stringByAppendingString:@"  Social Media Shares !"];
        }
    }else{
       [cell.categoryImageView setImage:[UIImage imageNamed:DEFAUTLIMAGE]]; 
        cell.categoryName.textColor = [UIColor grayColor];
        if ([objRewardSMS.categoryName isEqualToString:@"Social Media"]) {
             cell.smsTextView.text = [[intervalArray objectAtIndex:0] stringByAppendingString:@" Social Media until the next star."];
        }else
        cell.smsTextView.text = [[intervalArray objectAtIndex:0] stringByAppendingString:@" hour until the next star."];
        [cell.categoryName setText:objRewardSMS.categoryName];
        
    }
    if (rewardCounter == 5) {
        
         [cell.categoryImageView setImage:[UIImage imageNamed:objRewardSMS.rewardImage]];
         cell.smsTextView.text =@"Achievement completed !";
         [cell.categoryName setText:@""];
    }
    cell.rwdStar1.image = [UIImage imageNamed:STARNORMAL]; 
    cell.rwdStar2.image = [UIImage imageNamed:STARNORMAL];
    cell.rwdStar3.image = [UIImage imageNamed:STARNORMAL];
    cell.rwdStar4.image = [UIImage imageNamed:STARNORMAL];
    cell.rwdStar5.image = [UIImage imageNamed:STARNORMAL];
    
    for (int i = 0 ; i < rewardCounter; i++) {
        if (i == 0) {
            cell.rwdStar1.image = [UIImage imageNamed:STARSELECTED];
        } else  if (i == 1) {
            cell.rwdStar2.image = [UIImage imageNamed:STARSELECTED];
        } else  if (i == 2) {
            cell.rwdStar3.image = [UIImage imageNamed:STARSELECTED];
        } else  if (i == 3) {
            cell.rwdStar4.image = [UIImage imageNamed:STARSELECTED];
        } else  if (i == 4) {
            cell.rwdStar5.image = [UIImage imageNamed:STARSELECTED];
        } 
        
    }
    [cell.backGroundImage setImage:[UIImage imageNamed:@"list_bg1.png"]];
    
       return cell;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

// I have reached 3 stars out of 5 for tracking 50 hours of Travel
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView reloadData];
    
      RwardMessageModel *objRewardSMS = [rewardDataArray objectAtIndex:indexPath.row];
     imageNameShare = objRewardSMS.rewardImage;
    //NSLog(@" image name selected :-> %@", imageNameShare);
      int rewardCounter = [objRewardSMS.starCount intValue];

    if(rewardCounter >0){
       // [cell.categoryImageView setImage:[UIImage imageNamed:objRewardSMS.rewardImage]];
        
        NSArray *intervalArray = [objRewardSMS.rewardInterval componentsSeparatedByString:@","]; 
        if((rewardCounter <= [intervalArray count] ) && (indexPath.row != 8)){
            
            //I have reached 3 stars out of 5 for tracking 50 hours of Travel
            NSString *noStar = [@"I have reached " stringByAppendingString:[NSString stringWithFormat:@"%i stars out of  5 for tracking ",rewardCounter]];
            NSString *nextStarHours = [noStar stringByAppendingString:[intervalArray objectAtIndex:(rewardCounter-1)]];
            NSString *sendMessage = [nextStarHours stringByAppendingString:@"  hours of "];
           shareSMS =[sendMessage stringByAppendingString:objRewardSMS.categoryName];
        }else{
          
            NSString *noStar = [@"I have reached " stringByAppendingString:[NSString stringWithFormat:@"%i stars out of 5 for tracking ",rewardCounter]];
            NSString *nextStarHours = [noStar stringByAppendingString:[intervalArray objectAtIndex:(rewardCounter-1)]];
            NSString *sendMessage = [nextStarHours stringByAppendingString:@"   Social Media Shares"];
            shareSMS =sendMessage; //[sendMessage stringByAppendingString:objRewardSMS.categoryName];
        }
       _shareBtn.enabled = YES; 
        _twtBtn.enabled = YES; 
        _fbBtn.enabled  = YES;
    }else{
        _shareBtn.enabled = NO;
        _twtBtn.enabled = NO; 
        _fbBtn.enabled  = NO;
    }
    
    for (RwdCustomCell *cell1 in _customRwdCellObjArry) {
       // RwdCustomCell *cell1 =
        [cell1.backGroundImage setImage:[UIImage imageNamed:@"list_bg1.png"]];
    }
     RwdCustomCell *cell = (RwdCustomCell *) [tableView cellForRowAtIndexPath:indexPath];
   [cell.backGroundImage setImage:[UIImage imageNamed:@"list_bg.png"]]; 
    
    
   // NSLog(@" share reward on soxial midea :-> %@",objRewardSMS.starCount);
}


//static bool twitterIdetify= NO;
//static bool facebookIdentify = NO;
//-(IBAction)shareSocialMidea:(id)sender{
//    
//    
//}
//
//-(IBAction)shareOnFaceBook:(id)sender{
//    
//    if (facebookIdentify) {
//        [sender setSelected:YES];
//        facebookIdentify = NO;
//    }else{
//        [sender setSelected:NO];
//        facebookIdentify = YES;
//    } 
//}
//
//
//-(IBAction)shareOnTwitter:(id)sender{
//    
//    if (twitterIdetify) {
//        [sender setSelected:YES];
//        twitterIdetify = NO;
//    }else{
//        [sender setSelected:NO];
//        twitterIdetify = YES;
//    }
//}

static bool fbBoolValue = YES;
static bool twtBoolValue = YES;
static bool faceBookTwitterAlertIdentifier = YES;

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
                         
                         UIImage *image = [UIImage imageNamed:imageNameShare];
                         
                         if( image )
                         {
                             postRequest = [[TWRequest alloc] initWithURL: [NSURL URLWithString:UPDATE_WITH_MEDIA_TWITTER] parameters:nil requestMethod:TWRequestMethodPOST];
                             
                             myData = UIImagePNGRepresentation(image);
                             [postRequest addMultiPartData:myData withName:@"media" type:@"image/png"];
                         }
                         else
                         {
                             postRequest = [[TWRequest alloc] initWithURL:  [NSURL URLWithString:UPDATE_WITH_TEXT_TWITTER] parameters:nil requestMethod:TWRequestMethodPOST];
                         }
                         myData = [shareSMS dataUsingEncoding:NSUTF8StringEncoding];
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
            
//            //            NSMutableDictionary *variable = [[NSMutableDictionary alloc]initWithCapacity:1];
//            //            [variable setObject:message forKey:@"message"];
//            //            [objFBGraph doGraphPost:@"me/feed" withPostVars:variable];  
//            NSMutableDictionary *variable = [[NSMutableDictionary alloc]initWithCapacity:1];
//            [variable setObject:shareSMS forKey:@"message"];
//            [objFBGraph doGraphPost:@"me/feed" withPostVars:variable];
//           // NSLog(@"message send on face book");
            
            //*************
            NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:2];
            
            //create a UIImage (you could use the picture album or camera too)
           // NSLog(@" image name :-> %@", imageNameShare);
            UIImage *picture = [UIImage imageNamed:imageNameShare];
            //create a FbGraphFile object insance and set the picture we wish to publish on it
            FbGraphFile *graph_file = [[FbGraphFile alloc] initWithImage:picture];
            
            //finally, set the FbGraphFileobject onto our variables dictionary....
            [variables setObject:graph_file forKey:@"file"];
            
            [variables setObject:shareSMS forKey:@"message"];
            
            //the fbGraph object is smart enough to recognize the binary image data inside the FbGraphFile
            //object and treat that is such.....
            //FbGraphResponse *fb_graph_response = [fbGraph doGraphPost:@"117795728310/photos" withPostVars:variables];
            [objFBGraph doGraphPost:@"me/photos" withPostVars:variables];
            //******************
            
            
            
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
   // shareCounter ++;
    //NSLog(@"***************** after twitter");
    NSString *messageText;
    if ((twtMessageSendIdentify) && (FaceBookMessageSendIdentify)) {
        messageText = @"Reward details successfully shared on Facebook and Twitter"; 
        CommonUtilClass *obj = [CommonUtilClass CommonUtilSharedInstance];
        [obj  showAlertView:messageText title:@"Share"]; 
    }
    else if (twtMessageSendIdentify) {
        messageText = @"Reward details successfully shared on Twitter";
        CommonUtilClass *obj = [CommonUtilClass CommonUtilSharedInstance];
        [obj  showAlertView:messageText title:@"Share"]; 
        // NSLog(@"share tracker detail on social media ");
    }else if(FaceBookMessageSendIdentify){
        messageText = @"Reward details successfully shared on Facebook";
        CommonUtilClass *obj = [CommonUtilClass CommonUtilSharedInstance];
        [obj  showAlertView:messageText title:@"Share"];
    }
    faceBookTwitterAlertIdentifier = YES;
}

//-(void) showAlertA{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share" message:@"zczc" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//    [alert addButtonWithTitle:@"Ok"];
//    
//    [alert show];  
//}

@end
