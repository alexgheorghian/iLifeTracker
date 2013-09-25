//
//  TrackViewController.m
//  iLifeTracker
//
//  Created by Umesh on 26/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrackViewController.h"
#import "AppDelegate.h"

#define NAVIGATIONTITLE            @"                        Track"
#define ADDTRACKERTITLE            @"       Add Tracker"

#define NAVIGATIONBARITEMNAME      @"NULL"
#define RUNINGTRACKERSMS           @"Tracker is running, Please stop all tracker."
#define RUNINGTRACKERTITLE         @"Running Tracker"

#define CELLIMGVIEW @"imageView"
#define CELLCOUNTER @"counter"
#define CELLSTRTDATE @"startDate"
#define CELLSTOREDATE @"storeDate"
#define CELLPAUSECOUNT @"pauseCount"
#define CELLTIMER @"cellTimer"
#define CELLINDEXNO @"cellindex"

@implementation TrackViewController
@synthesize _customCellObjArry,bannerIsVisible;


 bool timer = YES; 

static  TrackViewController *_objTracker;
+(TrackViewController *) TrackSharedInstance {
    
    if (_objTracker == nil) {
        _objTracker = [[TrackViewController alloc] init];
    }
    
    return _objTracker;
}
#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Track";
        self.tabBarItem.image = [UIImage imageNamed:@"track"];
    }
    return self;
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
    //self.navigationItem.titleView =[CommonUtilClass navigationTittle:NAVIGATIONTITLE];

    //set image on navigationbar.
    UIImage *image = [UIImage imageNamed:NAVIGATIONBARIMGNAME];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

    //Set image on right navigationbar item.
    UIButton *rightNavigationbarButton= [CommonUtilClass setImage_OnNavigationbarButton:NAVIGATIONPLUSTBUTTONIMG buttonIdentifier:NAVIGATIONPLUSTBUTTON buttonName:NAVIGATIONBARITEMNAME];
    rightNavigationbarItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavigationbarButton];
    [rightNavigationbarButton addTarget:self action:@selector(addTracker) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightNavigationbarItem;
    rightNavigationbarButton=nil;
    //
    self._customCellObjArry = [[NSMutableArray alloc] init];
    
    _trackersessionTableView.backgroundColor = [UIColor clearColor];
    
    _trackersessionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

-(void) viewWillAppear:(BOOL)animated{
   // NSLog(@" viewWillAppear ");
    CommonUtilClass *commonObj = [CommonUtilClass CommonUtilSharedInstance];
    adView.backgroundColor = [UIColor clearColor];
    adView = [commonObj iADView];
    if([[UIScreen mainScreen] bounds].size.height == 568.0f || [[UIScreen mainScreen] bounds].size.width == 568.0f){
        adView.frame = CGRectMake(0,405,320,50);
    }
    else{
        adView.frame = CGRectMake(0,315,320,50);
    }
   // adView.delegate = self;
    [self.view addSubview:adView];
    [self.view bringSubviewToFront:adView];
    [self runningCellWillAppear];
    
    DataBaseController *obj = [DataBaseController DBControllerharedInstance];
    _trackersNameArray = [obj trackerDetail];
    
    [_trackersessionTableView reloadData];
    
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.appInBckgdBoolDisappear = NO;
}



-(void) viewWillDisappear:(BOOL)animated{
    
    //[self runningCellWillDisappear];
    if([[UIScreen mainScreen] bounds].size.height == 568.0f || [[UIScreen mainScreen] bounds].size.width == 568.0f){
        adView.frame = CGRectMake(0,405,320,50);
    }
    else{
        adView.frame = CGRectMake(0,315,320,50);
    }
     AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.appInBckgdBoolDisappear = YES;
}


-(void) runningCellWillAppear{
    

    
     DataBaseController *obj = [DataBaseController DBControllerharedInstance];
    _currentSessionArray  = [obj  selectCurrentSessionRecordTrackerName];
    
    for(CrntSessionModel *cell in _currentSessionArray ){
          
        break;
    }
}

//
-(double) timeBreak:(NSString *) runningTime{
    
//    NSArray *array;
//    NSString *time ;
//    NSString *amPm ;
//    NSString *date;
//    @try{
//     array = [runningTime componentsSeparatedByString:@" "]; 
//     time = [array objectAtIndex:0];
//     amPm = [array objectAtIndex:1];
//     date = [array objectAtIndex:2];
//    }@catch (NSException *e) {
//      if(LOGS_ON)  NSLog(@" TrackViewController : timeBreak : NSException ");
//    }
//    
// if(LOGS_ON) NSLog(@"date  %@", runningTime);
//    
//NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss a"];
//NSDate *anyDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@ %@",date,time,amPm] ];
//NSString  *backgroundTime1 = [dateFormat stringFromDate:anyDate];
//   // NSLog(@"*************** cell.startDate : runningTime 1 Date  :-> %@",anyDate);
//if(LOGS_ON)  NSLog(@"*************** cell.startDate : runningTime   :-> %@",backgroundTime1);
//
//NSDate *_runningTime = [NSDate date];
//NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//[outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss a"];
//NSString  *backgroundTime12 = [outputFormatter stringFromDate:_runningTime];
//
//if(LOGS_ON)  NSLog(@"*************** cell.startDate 2 current :-> %@",backgroundTime12);
//
//
//NSTimeInterval timeDifference = [_runningTime timeIntervalSinceDate:anyDate];
//    timeDifference = round(timeDifference);
//    
//    return timeDifference;
    NSArray *dateTimeArray;
        NSString *time ;
        NSString *amPm ;
        NSString *date;
    
    NSArray   *timeArray;
    NSString  *hours ;
    NSString  *minute ;
    NSString  *second ;
    
   
    @try{
        dateTimeArray = [runningTime componentsSeparatedByString:@" "]; 
        time = [dateTimeArray objectAtIndex:0];
        amPm = [dateTimeArray objectAtIndex:1];
        date = [dateTimeArray objectAtIndex:2];
        
        timeArray = [time componentsSeparatedByString:@":"];
        
        hours  = [timeArray objectAtIndex:0];
        minute = [timeArray objectAtIndex:1];
        second = [timeArray objectAtIndex:2];
         // NSLog(@"star hours :-> %@ , minute :-> %@ , seconds :-> %@",hours,minute,second);
    }@catch (NSException *e) {
        if(LOGS_ON)  NSLog(@" TrackViewController : timeBreak : NSException ");
    }
   // NSLog(@" start date time :-> %@ time :-> %@",runningTime,time);
    
    
    NSDate *_runningTime = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss a yyyy-MMM-dd"];
    NSString  *crtTime = [outputFormatter stringFromDate:_runningTime];
   
    
    NSArray *crtdateTimeArray;
    NSString *crttime ;
    NSString *crtamPm ;
    NSString *crtdate;
    
    NSArray   *crttimeArray;
    NSString  *crthours ;
    NSString  *crtminute ;
    NSString  *crtsecond ;
    
    @try{
        crtdateTimeArray = [crtTime componentsSeparatedByString:@" "]; 
        crttime = [crtdateTimeArray objectAtIndex:0];
        crtamPm = [crtdateTimeArray objectAtIndex:1];
        crtdate = [crtdateTimeArray objectAtIndex:2];
        // NSLog(@" current date time :-> %@ , time :-> %@",crtTime,crtamPm);
        crttimeArray = [crttime componentsSeparatedByString:@":"];
        
        crthours  = [crttimeArray objectAtIndex:0];
        crtminute = [crttimeArray objectAtIndex:1];
        crtsecond = [crttimeArray objectAtIndex:2];
        // NSLog(@"current hours :-> %@ , minute :-> %@ , seconds :-> %@",crthours,crtminute,crtsecond);
        
    }@catch (NSException *e) {
        if(LOGS_ON)  NSLog(@" TrackViewController : timeBreak : NSException ");
    }
   // NSLog(@" ****************** start Date :-> %@",date);
   //  NSLog(@" ****************** start Date :-> %@",crtdate);
    int hoursInt  = [hours intValue];
    int minuteInt = [minute intValue];
    int secondInt = [second intValue];
    
   int crthoursInt    = [crthours intValue];
   int crtminuteInt   = [crtminute intValue];
   int  crtsecondInt  = [crtsecond intValue];
    
    long totalSecond = 0;
    if ([crtdate isEqualToString:date]) {
      //  NSLog(@"same date ");
        if (([crtamPm isEqualToString:@"PM"]) && ([crthours intValue]< 12)) {
            crthoursInt = crthoursInt + 12;
        }
        if (([amPm isEqualToString:@"PM"]) && ([hours intValue]< 12)) {
            hoursInt = hoursInt + 12;
        } 
        if (([amPm isEqualToString:@"AM"]) && ([hours intValue]  == 12)) {
            hoursInt = 0;
        }
        if (([crtamPm isEqualToString:@"AM"]) && ([crthours intValue] == 12)) {
            crthoursInt = 0;
        }
       // if ([amPm isEqualToString:crtdate]) {
            
            //long a = crthoursInt*3600 + crtminuteInt*60 + crtsecondInt;
            //long b = hoursInt*3600 + minuteInt*60 + secondInt; 
            //totalSecond = a - b;
        totalSecond = crthoursInt*3600 + crtminuteInt*60 + crtsecondInt - hoursInt*3600 - minuteInt*60 - secondInt;
            // NSLog(@"same  amPm ");
        //}
//    else if([crthours intValue] ){
//        if (([crtamPm isEqualToString:@"PM"]) && ([crthours intValue]< 12)) {
//            
//        }
//        long a = [crthours intValue]*3600 + [crtminute intValue]*60 + [crtsecond intValue];
//        long b = [hours intValue]*3600 +[minute intValue]*60 +[second intValue]; 
//
//        totalSecond = a - b;
//          NSLog(@"difference  amPm ");
//    }
        
    } else{
       // NSLog(@"difference  date ");
        
        if (([crtamPm isEqualToString:@"PM"]) && ([crthours intValue]< 12)) {
            crthoursInt = crthoursInt + 12;
        }
        if (([amPm isEqualToString:@"PM"]) && ([hours intValue]< 12)) {
            hoursInt = hoursInt + 12;
        } 
        if (([amPm isEqualToString:@"AM"]) && ([hours intValue]  == 12)) {
            hoursInt = 0;
        }
        if (([crtamPm isEqualToString:@"AM"]) && ([crthours intValue] == 12)) {
            crthoursInt = 0;
        }
        // if ([amPm isEqualToString:crtdate]) {
        
       // long a = crthoursInt*3600 + crtminuteInt*60 + crtsecondInt;
       // long b = hoursInt*3600 + minuteInt*60 + secondInt; 
      //  totalSecond = a - b;
        
    
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setDateFormat:@"yyyy-MM-dd"];
//        NSDate *anyDate = [dateFormat dateFromString:date];
//        
//        NSDate *anyDate1 = [dateFormat dateFromString:crtdate];
//        
//        NSTimeInterval timeDifference = [anyDate1  timeIntervalSinceDate:anyDate];
//        int a = round(timeDifference);
//        a = a/(3600*24);
//        NSLog(@"*************** Day  :-> %i",a);
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *anyDate = [dateFormat dateFromString:date];
        
        NSDate *anyDate1 = [dateFormat dateFromString:crtdate];
        
        NSTimeInterval timeDifference = [anyDate1  timeIntervalSinceDate:anyDate];
        int day = round(timeDifference);
        day = day/(3600*24);
       // NSLog(@"*************** Day  :-> %i",day);
        
        totalSecond = 24*3600*day - hoursInt*3600 - minuteInt*60 - secondInt + crthoursInt*3600 + crtminuteInt*60 + crtsecondInt;
    }
    
   // NSLog(@" total second :-> %ld",totalSecond);
    
    return totalSecond;
}

//
-(NSDate *) convertIntoDateString:(NSString *) dateString{
    //if(LOGS_ON) NSLog(@" convertIntoDateString :-> %@",dateString);
    NSArray *array;
    NSString *time ;
    NSString *amPm ;
    NSString *date;
    @try {
        array = [dateString componentsSeparatedByString:@" "]; 
        time = [array objectAtIndex:0];
        amPm = [array objectAtIndex:1];
        date = [array objectAtIndex:2];
    }
    @catch (NSException *exception) {
      if(LOGS_ON)   NSLog(@" TrackViewController : convertIntoDateString : NSException ");
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss a"];
    NSDate *anyDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@ %@",date,time,amPm] ];
    
   // if(LOGS_ON) 
   if(LOGS_ON) NSLog(@" date string convert into date :-> %@", anyDate);
    return anyDate;
}



-(void) runningCellWillDisappear{
    //NSMutableArray *cellArray =[[NSMutableArray alloc] init ];  
    if(LOGS_ON) NSLog(@"Track :  runningCellWillDisappear ");
    
    for (int i =0; i< [_customCellObjArry count]; i++) {
        TrackerCustomCell *obj = (TrackerCustomCell *)[_customCellObjArry objectAtIndex:i];
        if(LOGS_ON)  NSLog(@"  running tracker :  :-> %i",obj.isRunning);
        if (obj.isRunning) {
       if(LOGS_ON)  NSLog(@"  running tracker :  pauseIdentify :-> %i",obj.pauseIdentify);
       // NSLog(@"  running tracker :  _storeStartDateTime :-> %@",obj._storeStartDateTime);
            DataBaseController *obj1 = [DataBaseController DBControllerharedInstance];
            
            [obj1 updateTrackerCurentSetionTimeCounter:[NSString stringWithFormat:@"%i",obj.timeCounter]  startDate:obj._startDateTime stroeDate:obj._storeStartDateTime pauseCounter:[NSString stringWithFormat:@"%i",obj.pauseCounter] indexNo:[NSString stringWithFormat:@"%i",i] pauseIdentify:[NSString stringWithFormat:@"%i",obj.pauseIdentify] runIdentify:@"1" trackerName:[obj._trackerSessionId intValue]];
        }
    }
}








-(void) addTracker{
    boolValue = NO;
    
//    for(TrackerCustomCell *cell in _customCellObjArry ){
//        
//        if (cell.isRunning) {
//            boolValue  = cell.isRunning;
//            break;
//        }
//    }
//    if (boolValue) {
//        [[CommonUtilClass CommonUtilSharedInstance] showAlertView:RUNINGTRACKERSMS title:RUNINGTRACKERTITLE];
    //}else{
    
    AddTrackerViewController *objAddTracker = [[AddTrackerViewController alloc] init];
    objAddTracker.hidesBottomBarWhenPushed = YES;
        
    objAddTracker.editTracker = NO;
        objAddTracker.title   = ADDTRACKERTITLE;
    [self.navigationController pushViewController:objAddTracker animated:YES];
    
   // }
}


#pragma mark :->
#pragma mark Tableview Datasource mathod .
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_trackersNameArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  // static NSString *CellIdentifier = @"Cell";
    TrackerDetailModel *objTrackerDetailModel = [_trackersNameArray objectAtIndex:indexPath.row];

    TrackerCustomCell *cell ; // = (TrackerCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    @try {
        cell =  [_customCellObjArry objectAtIndex:indexPath.row];
    }
    @catch (NSException *exception) {
        //if(LOGS_ON)  NSLog(@"TrackViewController : cellForRowAtIndexPath :error -> %@",exception);
    }
    
    if (cell == nil) 
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TrackerCustomCell" owner:nil options:nil];
        //if(LOGS_ON) NSLog(@"TrackViewController : cellForRowAtIndexPath : new cell create");
//        [_customCellObjArry addObject:[topLevelObjects objectAtIndex:0]];
        [_customCellObjArry insertObject:[topLevelObjects objectAtIndex:0] atIndex:indexPath.row];
        cell =  [_customCellObjArry objectAtIndex:indexPath.row];
        
        //
               for ( CrntSessionModel *objCRT in _currentSessionArray) {
                  // NSLog(@"tracker name : _> %@",objTrackerDetailModel.trackerName);
                   //NSLog(@"tracker runnign name ->%@", objCRT.trackerName);
                  // NSLog(@"tracker runnign name ->%@", objCRT.runIdentify);
                  // NSLog(@"*************************************************************************");
                   if (([objTrackerDetailModel.trackerName isEqualToString:objCRT.trackerName]) && ([objCRT.runIdentify intValue] == 1)) {
                       
                       

                       
                      // NSDate *startDate = (NSDate * ) objCRT.startDate ;
                      // NSDate *storeDate = (NSDate * ) objCRT.storeDate ;
                       
                       cell._storeStartDateTime = [self convertIntoDateString:objCRT.storeDate];
                       cell._startDateTime      = [self convertIntoDateString:objCRT.startDate];
                       cell.storeDatStr = objCRT.storeDate;
                       cell.pauseIdentify = objCRT.pauseIdentify;
                       cell.pauseCounter = [objCRT.pauseCounter intValue];
                        
                       //cell
                        if ([objCRT.pauseIdentify intValue] == 0 ) {
                            cell.runIdentify  = YES;
                            long runningTime = [self  timeBreak:objCRT.startDate];
                            runningTime = runningTime + [objCRT.pauseCounter intValue];
                            
                            //if(LOGS_ON) NSLog(@"***************** puse not  long value :-> %ld ",runningTime);
                            cell.backgoundCounter = runningTime;
                             NSString *runTime = [@"Current " stringByAppendingString:[CommonUtilClass convetIntoTimeFormatSecond:runningTime]];
                           cell._startingTimeLabel.text = runTime;
                            
                            cell._trackerTimer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:cell selector:@selector(targetMethod:) userInfo:nil repeats:YES];
                             [cell._strtStpBtnImgView setImage:[UIImage imageNamed:@"stop.png"]];
                             cell._startingTimeLabel.textColor = [UIColor greenColor];
                            //if(LOGS_ON) NSLog(@"***************** puse not ");
                            
                            
                        }else if([objCRT.pauseIdentify intValue] == 1){
                            cell.timeCounter = [objCRT.pauseCounter intValue];
                            NSString *pauseTime = [@"Current " stringByAppendingString:[CommonUtilClass convetIntoTimeFormatSecond:[objCRT.pauseCounter intValue]]];
                            cell._startingTimeLabel.text = pauseTime;
                           [cell._strtStpBtnImgView setImage:[UIImage imageNamed:@"pause.png"]];
                            cell._startingTimeLabel.textColor = [UIColor yellowColor];
                             //if(LOGS_ON) NSLog(@"***************** puse yes ");
                        }
                   }
        }
                   
        //
        
    }
    
//    @try {
//        cell =  [_customCellObjArry objectAtIndex:indexPath.row];
//    }
//    @catch (NSException *exception) {
//      //if(LOGS_ON)  NSLog(@"TrackViewController : cellForRowAtIndexPath :error -> %@",exception);
//    }
  //  TrackerDetailModel *objTrackerDetailModel = [_trackersNameArray objectAtIndex:indexPath.row];
    
    //NSLog(@" tracker :-> %@",objTrackerDetailModel.trackerSessionID);
     [cell._trackerNameLabel setFont:[UIFont fontWithName:FONTNAME size:17]];
    
    [cell._trackerNameLabel setText:objTrackerDetailModel.trackerName];
    [cell._totalTimeLabel   setText:[CommonUtilClass convetIntoTimeFormatSecond:[objTrackerDetailModel.trackerSetion intValue]]];
    
    cell._trackerSessionId = objTrackerDetailModel.trackerSessionID;
    cell._trackerSession    = objTrackerDetailModel.trackerSetion;
    
    cell.totalTimeDelegate = self;
    cell.categoryName = objTrackerDetailModel.trackerCategory;
    
    cell.trackerAlarm     = objTrackerDetailModel.alaram ;
    cell.trackerGoal      = objTrackerDetailModel.goal ;
    cell.trackerAutoStop  = objTrackerDetailModel.autoStop ;
    

    
     return cell;
}




#pragma mark :->
#pragma mark Tableview delegate mathod .

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    TrackerDetailViewController *objTrackerDetail = [TrackerDetailViewController shareInstanceTrackerDetail];
    objTrackerDetail.hidesBottomBarWhenPushed = YES;
    
    TrackerCustomCell *cell = (TrackerCustomCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    TrackerDetailModel *objTrackerDetailModel = [_trackersNameArray objectAtIndex:indexPath.row];
    objTrackerDetail.trackerIsRunning = cell.isRunning;
    objTrackerDetail.trackerName = objTrackerDetailModel.trackerName;
    objTrackerDetail._trackerCategory =objTrackerDetailModel.trackerCategory;
    objTrackerDetail._trackerTotalTime = [objTrackerDetailModel.trackerSetion intValue];
    objTrackerDetail._trackerID = [objTrackerDetailModel.trackerSessionID intValue];
    
    [self.navigationController pushViewController:objTrackerDetail animated:YES];
}


- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
        
    {
        TrackerDetailModel *objTrackerDetailModel = [_trackersNameArray objectAtIndex:indexPath.row];
        DataBaseController *obj = [DataBaseController DBControllerharedInstance];
        
        [obj deleteTracker:objTrackerDetailModel.trackerName];
        
        [obj deleteTrackerSessionRecords:objTrackerDetailModel.trackerName];
        
        
        [_trackersNameArray removeObjectAtIndex:indexPath.row];
        [_customCellObjArry removeObjectAtIndex:indexPath.row];
        [_trackersessionTableView reloadData];
    } 
}

- (void)updateTrackerTotalTime{
    
    _trackersNameArray = nil;
    DataBaseController *obj = [DataBaseController DBControllerharedInstance];
        _trackersNameArray = [obj trackerDetail];
        [_trackersessionTableView reloadData];  
}


@end
