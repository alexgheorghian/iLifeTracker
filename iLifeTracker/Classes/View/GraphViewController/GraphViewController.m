
//  Created by Adrian
//  Copyright (c) 2013 3rd Floor Software Solutions Inc. All rights reserved.
//

#import "GraphViewController.h"
#import "iLifeTrackerTabbar.h"
#import "iLifeTrackerTabbar.h"
#define GRAPHSMSMINUTE @" Tracker Time(in minutes)"
#define GRAPHSMSHOURS @" Tracker Time(in hours)"

//#define WEEKBTNNORMALIMG  @"white_left_rounded_button.png"
//#define MONTHBTNNORMALIMG @"white_center_gradient_button.png"
//#define ALLBTNNORMALIMG   @"white_right_rounded_button.png"

//#define WEEKBTNSELECTEDIMG  @"black_left_rounded_button.png"
//#define MONTHBTNSELECTEDIMG @"black_center_gradient_button.png"
//#define ALLBTNSELECTEDIMG   @"black_right_rounded_button.png"


@implementation GraphViewController

@synthesize bannerIsVisible;
static int lineGraphWidth = 320 , LineGraphHieght = 350;

static bool portraitIdentify = YES;

CGFloat const CPDBarWidth = .40f;
CGFloat const CPDBarInitialX1 = 0.10f;

@synthesize hostView    = hostView_;
@synthesize aaplPlot    = aaplPlot_;
//@synthesize googPlot    = googPlot_;
//@synthesize msftPlot    = msftPlot_;
static NSArray  *dayIdentifierArray;

@synthesize priceAnnotation = priceAnnotation_,_trackerdayRecordArray;

static bool portraitIdentifier = YES;

static bool minuteHoursIdentify ;

static bool landscapeIdentify = NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(LOGS_ON)     MESSAGE_START;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Graphs";
        self.tabBarItem.image = [UIImage imageNamed:@"graph"];
    }
    return self;
}

-(id)initCustom
{
    if(LOGS_ON)     MESSAGE_START;
   // NSLog(@"initCustom");
    self = [super init];
    if (self) {
        self.title = @"Graphs";
        self.tabBarItem.image = [UIImage imageNamed:@"graph"];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    CommonUtilClass *commonObj = [CommonUtilClass CommonUtilSharedInstance];
    adView.backgroundColor = [UIColor clearColor];
    adView = [commonObj iADView];
   // adView.delegate = self;
    [self.view addSubview:adView];
    [self.view bringSubviewToFront:adView];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    _landscapeModeTrackerNameView.frame = CGRectMake(181, 3, 109, 31);
    if ([_trackerNameArray count] > 0) {
        [_trackerNameArray removeAllObjects];
    }
    
    // _dayIdentifierLabel.text = @"Last Week";
     //Get data from database.
    DataBaseController *obj = [DataBaseController DBControllerharedInstance];
    _trackerdayRecordArray  = [obj selectTrackerSessionInfo];
    
    
    //Week day Array .
   // if( [_trackerNameArray count] > 7){
        if ([_monthDayRecordArray count] > 0) {
            [_monthDayRecordArray removeAllObjects];
        }
    int monthDayCounter = 0;
        for (GraphModel *obj in _trackerdayRecordArray ){
             if(monthDayCounter < 30){
            [_monthDayRecordArray addObject:obj];
        }else{
            break;
        }
            monthDayCounter++;
        }
    //}
    //Month day Array. 
    //if( [_trackerNameArray count] <= 7){
        if ([_weekDayRecordArray count] > 0) {
            [_weekDayRecordArray removeAllObjects];
        }
    int weekDayounter = 0;
    //for (int i = [_trackerdayRecordArray count] -1 ;i >=0; i-- ){
     //   GraphModel *obj = [_trackerdayRecordArray objectAtIndex:i];
        for (GraphModel *obj in _trackerdayRecordArray ){
            
            if(weekDayounter <7){
            [_weekDayRecordArray addObject:obj];
            }else{
                break;
            }
            weekDayounter++; 
        }
    //}
    //Set Graph.
    [LineGraphTracker sharedInstance].trackerTimeArray   =   _trackerdayRecordArray;
    
    [BarChartTracker sharedInstance].trackerBarchatArray =   _weekDayRecordArray;
    
    for (GraphModel *obj in _trackerdayRecordArray) {
        // _trackerNameLabel.text = [_trackerNameArray objectAtIndex:row];
        _trackerNameLabel.text = obj.trackerName ; 
        [LineGraphTracker sharedInstance].trackerName     =  obj.trackerName;
        [BarChartTracker sharedInstance].bartrackerName   =  obj.trackerName;
        break;
        //NSLog(@" Tracker name ");
    }
    // Graph so according to hours or minute
    for (GraphModel *obj in _trackerdayRecordArray ){
        
        if ([_trackerNameLabel.text isEqualToString:obj.trackerName]) {
                  if ([[obj trackerSesion] intValue] > 3600) {
            [LineGraphTracker sharedInstance].hourIdentifier   = YES;
            [BarChartTracker sharedInstance].barHourIdentifier = YES;
            [BarChartTracker sharedInstance].monthIndentifier  = NO;          
            minuteHoursIdentify = NO;
             
            break;
        }else{
            [LineGraphTracker sharedInstance].hourIdentifier   = NO;
            [BarChartTracker sharedInstance].barHourIdentifier = NO; 
            [BarChartTracker sharedInstance].monthIndentifier  = NO; 
            minuteHoursIdentify = YES;
        }
        }
    }
    
    //bar 
//    if (self.hostView != nil) {
//        self.hostView = nil;  
//    }
//    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:CGRectMake(0,0,480,156)];
	//self.hostView.allowPinchScaling = YES;    
	[landscapeView addSubview:self.hostView]; 
    [self initPlot];
    //line
    if (!objLineChart) {
        objLineChart = [LineGraph new];
    }
    objLineChart.minuteAndHourIdentify = minuteHoursIdentify;
    objLineChart.rotaionIdentify= NO;
    [objLineChart   configureHost:lineChartView frameSize:CGRectMake(0, 0,lineGraphWidth,LineGraphHieght-135)];
    
    //[objLineChart   configureHost:AllRecordView frameSize:CGRectMake(0, 0,lineGraphWidth+180,LineGraphHieght-150)];
    
    // Set Pickerview array. 
    for (GraphModel *obj in _trackerdayRecordArray ) {
        [_trackerNameArray addObject:obj.trackerName];
       // NSLog(@" Tracker Name  :->  %@",obj.trackerName);
    }
    
    for(int j = 0; j < [_trackerNameArray count]; j++){
        for(int k = j+1;k < [_trackerNameArray count];k++){
            NSString *str1 = [_trackerNameArray objectAtIndex:j];
            NSString *str2 = [_trackerNameArray objectAtIndex:k];
            if([str1 isEqualToString:str2])
                [_trackerNameArray removeObjectAtIndex:k];
        }
    }
    
   // NSLog(@" tracker Counter :-> %i", [_trackerNameArray count]);
    
    //pickerview 
    [self.view addSubview:_trackeNamePickerView];
    [_trackeNamePickerView reloadAllComponents];
     //Set graph view   
    if(portraitIdentifier){
    lineChartView.hidden  = NO;
    landscapeView.hidden   = YES;
    AllRecordView.hidden  = YES;
    }else{
        lineChartView.hidden  = YES;
        landscapeView.hidden   = NO;
        AllRecordView.hidden  = YES;
    }
    //PickerView reload component.
     _trackeTitleLbl.hidden = YES;
    //
    landscapeIdentify = YES;
    //
    _weekDayButton.hidden  = YES;
    _monthDayButton.hidden = YES;
    _allDayButton.hidden   = YES;
    
    weekGraphDisappear  = YES;
    monthGraphDisappear = YES;
    AllGraphDisappear   = YES;
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
    landscapeIdentify = NO ;
}


#pragma mark - UIViewController lifecycle methods
-(void)viewDidLoad {
    
    [super viewDidLoad];
   AllRecordView.backgroundColor = [UIColor clearColor];
   // self.view.backgroundColor = [UIColor clearColor];
    //[landscapeView setContentSize:CGSizeMake(0, 500)];
    //];
    //Add label with navigation tittleview bar
    //self.navigationItem.titleView =[CommonUtilClass navigationTittle:NAVIGATIONTITLE];
//    dayTitleLbl = [[UILabel alloc] init];
//    dayTitleLbl.text = @"Day";
//    dayTitleLbl.textColor = [UIColor whiteColor];
    dayTitleLbl.backgroundColor = [UIColor clearColor];
    
    //_tabBarView = [[UIView alloc] init ];
   // [_tabBarView addSubview:dayTitleLbl];
    
    //set image on navigationbar.
    UIImage *image = [UIImage imageNamed:NAVIGATIONBARIMGNAME];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //
    //landscapeView.frame = [];
    
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:CGRectMake(0,0,480,200)];
    self.hostView.allowPinchScaling = YES; 
    //_dayIdentifierPickerView.frame = CGRectMake(0, 500, 480, 216);
    
    _trackerNameArray    = [[NSMutableArray alloc] init];
    _weekDayRecordArray  = [[NSMutableArray alloc] initWithCapacity:7];
    _monthDayRecordArray = [[NSMutableArray alloc] initWithCapacity:30];
    
    dayIdentifierArray  = [[NSArray alloc] initWithObjects:@"Last Week",@"Last Month",@"All", nil];
    
    _tabbarHideView.backgroundColor = [UIColor clearColor];
    if(LOGS_ON)     MESSAGE_START;
       
   // [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    //
    _messageTextView.backgroundColor = [UIColor clearColor];
    _pickerClossView.backgroundColor = [UIColor clearColor];
    
    _messageTextView.editable =NO;
    _messageTextView.scrollEnabled = NO;
    
    [_trackeTitleLbl  setFont:[UIFont fontWithName:FONTNAME size:13]];
    [TrackerNameIndecatorLbl setFont:[UIFont fontWithName:FONTNAME size:24]];
    
   
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
- (void) orientationChanged:(id)object
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
//    AllRecordView.hidden  = YES; 
//    landscapeView.hidden = NO;
//    lineChartView.hidden = YES;
    
    // if(weekGraphDisappear){
//    [BarChartTracker sharedInstance].monthIndentifier = NO; 
//    [BarChartTracker sharedInstance].bartrackerName      =   _trackerNameLabel.text;
//    [BarChartTracker sharedInstance].trackerBarchatArray =   _weekDayRecordArray;
//    
//    // NSLog(@"***************** Week Day ");
//    weekGraphDisappear  = NO;
//    // } //bar 
//    [landscapeView addSubview:self.hostView]; 
//    [self initPlot];
//    
//    
//    [_monthDayButton setSelected:NO];
//    [_weekDayButton setSelected:YES];
//    [_allDayButton setSelected:NO];
//    
//    _weekDayButton.titleLabel.textColor  = [UIColor blackColor];
//    _monthDayButton.titleLabel.textColor = [UIColor whiteColor];
//    _allDayButton.titleLabel.textColor   = [UIColor whiteColor];
    
    
   // [_allDayButton setBackgroundImage:[UIImage imageNamed:ALLBTNNORMALIMG] forState:UIControlStateSelected];  
    //[_weekDayButton setBackgroundImage:[UIImage imageNamed:WEEKBTNSELECTEDIMG] forState:UIControlStateNormal]; 
    //[_monthDayButton setBackgroundImage:[UIImage imageNamed:MONTHBTNNORMALIMG] forState:UIControlStateNormal];
    
    if(LOGS_ON)     MESSAGE_START;
	UIInterfaceOrientation interfaceOrientation =   [[object object] orientation];
    
  //  iLifeTrackerTabbar *objTabBar = [iLifeTrackerTabbar tabBarShareInstance];
	// UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
   //  _dayIdentifierPickerView.frame = CGRectMake(0, 600, 480, 216); 
     _pickerClossView.frame     = CGRectMake(0, 600, 480, 216); 
    _trackeNamePickerView.frame = CGRectMake(0, 600, 480, 216); 
	if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortrait) 
	{
		//self.view = portraitView;
        
        NSLog(@" Pratrit mode ");
        adView.hidden = NO;
        if([[UIScreen mainScreen] bounds].size.height == 568.0f || [[UIScreen mainScreen] bounds].size.width == 568.0f){
            adView.frame = CGRectMake(0,405,320,50);
        }
        else{
            adView.frame = CGRectMake(0,315,320,50);
        }
        lineChartView.hidden = NO;
        AllRecordView.hidden = YES;
        landscapeView.hidden = YES;
        //
        _weekDayButton.hidden  = YES;
        _monthDayButton.hidden = YES;
        _allDayButton.hidden   = YES;
        //
         _pickerCloseBttn.frame = CGRectMake(250, 2, 57, 29);
        
         _landscapeModeTrackerNameView.frame = CGRectMake(181, 3, 109, 31);
         TrackerNameIndecatorLbl.frame        = CGRectMake(30, 13, 79, 15);
        
        portraitIdentifier = YES;
        objLineChart.rotaionIdentify = NO;
        [objLineChart   configureHost:lineChartView frameSize:CGRectMake(0, 0,lineGraphWidth,LineGraphHieght-135)];
       self.tabBarController.tabBar.userInteractionEnabled = YES;
        _messageTextView.hidden = NO;
          
       // [self.view addSubview:_messageTextView];
        portraitIdentify = YES;
        //
        //[window addSubview:objTabBar.view];
        self.navigationController.navigationBarHidden = NO;
        //Set label to identify minutes and hours.
        _trackeTitleLbl.hidden = YES;
        
       //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);
        //[_tabBarView removeFromSuperview];
        //Semove bar graph on window
      //  [self.view removeFromSuperview];
      //  [objTabBar.view addSubview:self.view];
       	} 
	else if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        adView.hidden = YES;
//        CGRect frame1 = adView.frame;
//        frame1.origin.y = frame1.origin.y - 200;
//        adView.frame = frame1;
        NSLog(@" Landscape  mode ");
        lineChartView.hidden    = YES;
        AllRecordView.hidden    = YES;
        landscapeView.hidden    = NO;
        portraitIdentifier      = NO;
        //
        _weekDayButton.hidden  = NO;
        _monthDayButton.hidden = NO;
        _allDayButton.hidden   = NO;
        
        _pickerCloseBttn.frame = CGRectMake(420, 2, 57, 29);
        
        _landscapeModeTrackerNameView.frame = CGRectMake(230, 3, 109, 31);
        TrackerNameIndecatorLbl.frame        = CGRectMake(130, 13, 79, 15);
        
        self.tabBarController.tabBar.userInteractionEnabled = NO;
        
        _messageTextView.hidden = YES;
        portraitIdentify = NO;
        //
        //[window addSubview:self.view];
        //[objTabBar.view removeFromSuperview];
        self.navigationController.navigationBarHidden = YES;
        
        //Set label to identify minutes and hours.
        _trackeTitleLbl.hidden = NO;
        
         //[window addSubview:_tabbarHideView]; 
        //_tabBarView.frame = CGRectMake(270, 0, 500, 500);
       // dayTitleLbl.frame = CGRectMake(50, 0, 10, 60);
        //_tabBarView.backgroundColor = [UIColor blackColor];
        //[_tabBarView addSubview:dayTitleLbl];
        if(landscapeIdentify){
       // [window addSubview:_tabBarView];
        }
       // _dayIdentifierLabel.text = @"Last Week";
        //
        //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        //Add bar graph on window
       // [window addSubview:self.view];
        
        
        
        
        
        [BarChartTracker sharedInstance].monthIndentifier = NO; 
        [BarChartTracker sharedInstance].bartrackerName      =   _trackerNameLabel.text;
        [BarChartTracker sharedInstance].trackerBarchatArray =   _weekDayRecordArray;
        
        // NSLog(@"***************** Week Day ");
        weekGraphDisappear  = NO;
        // } //bar 
        [landscapeView addSubview:self.hostView]; 
        [self initPlot];
        
        
        [_monthDayButton setSelected:NO];
        [_weekDayButton setSelected:YES];
        [_allDayButton setSelected:NO];
        
        _weekDayButton.titleLabel.textColor  = [UIColor blackColor];
        _monthDayButton.titleLabel.textColor = [UIColor whiteColor];
        _allDayButton.titleLabel.textColor   = [UIColor whiteColor];
        
        
        
        
    }else if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
       // NSLog(@" Landscape  mode ");
        adView.hidden = YES;
//        CGRect frame1 = adView.frame;
//        frame1.origin.y = frame1.origin.y - 200;
//        adView.frame = frame1;
       lineChartView.hidden     = YES;
        AllRecordView.hidden    = YES;
        landscapeView.hidden    = NO;
		//self.view = landscapeView;
        portraitIdentifier = NO;
        //
          _pickerCloseBttn.frame = CGRectMake(420, 2, 57, 29);
        
        _landscapeModeTrackerNameView.frame = CGRectMake(230, 3, 109, 31);
        TrackerNameIndecatorLbl.frame        = CGRectMake(130, 13, 79, 15);
        
        _weekDayButton.hidden  = NO;
        _monthDayButton.hidden = NO;
        _allDayButton.hidden   = NO;
       
       

        self.tabBarController.tabBar.userInteractionEnabled = NO;
        _messageTextView.hidden = YES;
        portraitIdentify = NO;
        //
        //[window addSubview:self.view];
         //[objTabBar.view removeFromSuperview];
        //objTabBar.hidesBottomBarWhenPushed = YES;
        self.navigationController.navigationBarHidden = YES;
        
        //Set label to identify minutes and hours.
        _trackeTitleLbl.hidden = NO;
        
       // _tabBarView.frame = CGRectMake(0, 0, 50, 500);
       // _tabBarView.backgroundColor = [UIColor blackColor];
        
        if(landscapeIdentify){
       // [window addSubview:_tabBarView];
        }
       // _dayIdentifierLabel.text = @"Last Week";
      //  [[UIApplication sharedApplication] setStatusBarHidden:YES];
        //Add bar graph on window
        //[window addSubview:self.view];
        //self.hidesBottomBarWhenPushed = YES;
        //self.view.backgroundColor = [UIColor whiteColor] ;
        //[self.view setNeedsDisplayInRect:CGRectMake(0, 0, 480, 320)];
       // [self setWantsFullScreenLayout:YES];
        //self.view.frame = CGRectMake(0, 0, 500, 500);
        
        
        [BarChartTracker sharedInstance].monthIndentifier = NO; 
        [BarChartTracker sharedInstance].bartrackerName      =   _trackerNameLabel.text;
        [BarChartTracker sharedInstance].trackerBarchatArray =   _weekDayRecordArray;
        
        // NSLog(@"***************** Week Day ");
        weekGraphDisappear  = NO;
        // } //bar 
        [landscapeView addSubview:self.hostView]; 
        [self initPlot];
        
        
        [_monthDayButton setSelected:NO];
        [_weekDayButton setSelected:YES];
        [_allDayButton setSelected:NO];
        
        _weekDayButton.titleLabel.textColor  = [UIColor blackColor];
        _monthDayButton.titleLabel.textColor = [UIColor whiteColor];
        _allDayButton.titleLabel.textColor   = [UIColor whiteColor];
        
        
        
        
        
       	}
    else if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        adView.hidden = NO;
        if([[UIScreen mainScreen] bounds].size.height == 568.0f || [[UIScreen mainScreen] bounds].size.width == 568.0f){
            adView.frame = CGRectMake(0,405,320,50);
        }
        else{
            adView.frame = CGRectMake(0,315,320,50);
        }
        portraitIdentifier      =   YES;
        
        lineChartView.hidden    =   NO;
        AllRecordView.hidden    =   YES;
        landscapeView.hidden    =   YES;
        //Button hide 
         _pickerCloseBttn.frame = CGRectMake(250, 2, 57, 29);
        
        _landscapeModeTrackerNameView.frame = CGRectMake(181, 3, 109, 31);
        TrackerNameIndecatorLbl.frame        = CGRectMake(30, 13, 79, 15);
        
        _weekDayButton.hidden   =   YES;
        _monthDayButton.hidden  =   YES;
        _allDayButton.hidden    =   YES;
        objLineChart.rotaionIdentify = NO;
        [objLineChart   configureHost:lineChartView frameSize:CGRectMake(0, 0,lineGraphWidth,LineGraphHieght-135
                                                                         )];
        
      self.tabBarController.tabBar.userInteractionEnabled = YES;
        _messageTextView.hidden = NO;
        portraitIdentify = YES;
        //
        //[window addSubview:objTabBar.view];
        self.navigationController.navigationBarHidden = NO;
        //
        _trackeTitleLbl.hidden = YES;
        //
        //[_tabBarView removeFromSuperview];
       // [[UIApplication sharedApplication] setStatusBarHidden:YES];
         self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 44);
        //Semove bar graph on window
        //[self.view removeFromSuperview];
        
    }

}



#pragma mark - IBActions
#pragma mark - Chart behavior
-(void)initPlot {
    self.hostView.allowPinchScaling = NO;
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];    
}

-(void)configureGraph {
	// 1 - Create the graph
	CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
	graph.plotAreaFrame.masksToBorder = NO;
	self.hostView.hostedGraph = graph;    
	// 2 - Configure the graph    
	[graph applyTheme:[CPTTheme themeNamed:kCPTPlainBlackTheme]];    
	graph.paddingBottom = 30.0f;      
	graph.paddingLeft  = 30.0f;
	graph.paddingTop    = -1.0f;
	graph.paddingRight  = -5.0f;
	// 3 - Set up styles
	CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
	titleStyle.color = [CPTColor whiteColor];
	titleStyle.fontName = @"Helvetica-Bold";
	titleStyle.fontSize = 16.0f;
	// 4 - Set up title
    NSString *title;
    if (minuteHoursIdentify) {
        _trackeTitleLbl.text =  GRAPHSMSMINUTE;
    }else{
        _trackeTitleLbl.text =  GRAPHSMSHOURS;
    }
	
	graph.title = title;  
	graph.titleTextStyle = titleStyle;
	graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
	graph.titleDisplacement = CGPointMake(0.0f, -16.0f);

	// 5 - Set up plot space`
	CGFloat xMin = 0.0f;
	CGFloat xMax = [[[BarChartTracker sharedInstance] datesInWeek] count];
	CGFloat yMin = 0.0f;
    CGFloat yMax;
    if( minuteHoursIdentify){
	 yMax = 62.0f; 
   }else{
    yMax = 25.0f;
   }
      // should determine dynamically based on max price
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
    
    plotSpace.allowsUserInteraction = NO;    
}

-(void)configurePlots {
	// 1 - Set up the three plots
	self.aaplPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO];
	self.aaplPlot.identifier = @"AAPL";
	//self.googPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor greenColor] horizontalBars:NO];
	//self.googPlot.identifier = @"GOOG";
	//self.msftPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
	//self.msftPlot.identifier = @"MSFT";
	// 2 - Set up line style
	CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
	barLineStyle.lineColor = [CPTColor lightGrayColor];
	barLineStyle.lineWidth = 2;
	// 3 - Add plots to graph
	CPTGraph *graph = self.hostView.hostedGraph;
	CGFloat barX = CPDBarInitialX1;
	NSArray *plots = [NSArray arrayWithObjects:self.aaplPlot, nil];
	for (CPTBarPlot *plot in plots) {
		plot.dataSource = self;
		plot.delegate = self;
		plot.barWidth = CPTDecimalFromDouble(CPDBarWidth);
		plot.barOffset = CPTDecimalFromDouble(barX);
        // bar width
        //plot.barWidthScale = 2;
        
        //cornar rotation
       // plot.barCornerRadius = 50;
        
		plot.lineStyle = barLineStyle;
		[graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
		barX += CPDBarWidth;
	} 
}

-(void)configureAxes {
	CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
	axisTitleStyle.color = [CPTColor whiteColor];
	axisTitleStyle.fontName = @"Helvetica-Bold";
	axisTitleStyle.fontSize = 12.0f;
	CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    //[axisLineStyle setLineStyleInContext:];
	axisLineStyle.lineWidth = 2.0f;
	axisLineStyle.lineColor = [CPTColor whiteColor];
	CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
	axisTextStyle.color = [CPTColor whiteColor];
	axisTextStyle.fontName = @"Helvetica-Bold";    
	axisTextStyle.fontSize = 9.0f;
	CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
	tickLineStyle.lineColor = [CPTColor whiteColor];
	tickLineStyle.lineWidth = 2.0f;
	CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
	tickLineStyle.lineColor = [CPTColor blackColor];
	tickLineStyle.lineWidth = 5.0f;       
	// 2 - Get axis set
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
	// 3 - Configure x-axis
	CPTAxis *x = axisSet.xAxis;
	x.title = @"Day"; 
	x.titleTextStyle = axisTitleStyle;    
	x.titleOffset = 15.0f;
	x.axisLineStyle = axisLineStyle;
	x.labelingPolicy = CPTAxisLabelingPolicyNone;
	x.labelTextStyle = axisTextStyle;    
	x.majorTickLineStyle = axisLineStyle;
	x.majorTickLength = 4.0f;
	x.tickDirection = CPTSignNegative;
   // x.coordinate = CGRectMake(10, 6, 100,200);
	CGFloat dateCount = [[[BarChartTracker sharedInstance] datesInWeek] count];
	NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
	NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount]; 
	NSInteger i = 0;
	for (NSString *date in [[BarChartTracker sharedInstance] datesInWeek]) {
		CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:date  textStyle:x.labelTextStyle];
		CGFloat location = i++;
		label.tickLocation = CPTDecimalFromCGFloat(location);
		label.offset = x.majorTickLength;
		if (label) {
			[xLabels addObject:label];
			[xLocations addObject:[NSNumber numberWithFloat:location]];                        
		}
	}
	x.axisLabels = xLabels;    
	x.majorTickLocations = xLocations;
	// 4 - Configure y-axis
	CPTAxis *y = axisSet.yAxis;    
	//y.title = @"Time";
	y.titleTextStyle = axisTitleStyle;
	y.titleOffset = -40.0f;       
	y.axisLineStyle = axisLineStyle;
	y.majorGridLineStyle = gridLineStyle;
	y.labelingPolicy = CPTAxisLabelingPolicyNone;
	y.labelTextStyle = axisTextStyle;    
	y.labelOffset = 16.0f;
	y.majorTickLineStyle = axisLineStyle;
	y.majorTickLength = 4.0f;
	y.minorTickLength = 2.0f;    
	y.tickDirection = CPTSignPositive;
	NSInteger majorIncrement = 10;
	NSInteger minorIncrement = 10;    
	CGFloat yMax = 700.0f;  // should determine dynamically based on max price    
	NSMutableSet *yLabels = [NSMutableSet set];
	NSMutableSet *yMajorLocations = [NSMutableSet set];
	NSMutableSet *yMinorLocations = [NSMutableSet set];
	for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
		NSUInteger mod = j % majorIncrement;
		if (mod == 0) {
			CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", j] textStyle:y.labelTextStyle];
			NSDecimal location = CPTDecimalFromInteger(j); 
			label.tickLocation = location;
			label.offset = -y.majorTickLength - y.labelOffset;
			if (label) {
				[yLabels addObject:label];
			}
			[yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
		} else {
			[yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
		}
	}
	y.axisLabels = yLabels;    
	y.majorTickLocations = yMajorLocations;
	y.minorTickLocations = yMinorLocations;        
}

-(void)hideAnnotation:(CPTGraph *)graph {
	if ((graph.plotAreaFrame.plotArea) && (self.priceAnnotation)) {
		[graph.plotAreaFrame.plotArea removeAnnotation:self.priceAnnotation];
		self.priceAnnotation = nil;
	}
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
	return [[[BarChartTracker sharedInstance] datesInWeek] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
	if ((fieldEnum == CPTBarPlotFieldBarTip) && (index < [[[BarChartTracker sharedInstance] datesInWeek] count])) {
		if ([plot.identifier isEqual:@"AAPL"]) {
			return [[[BarChartTracker sharedInstance] weeklyPrices:@"AAPL"] objectAtIndex:index];
        }
//		} else if ([plot.identifier isEqual:@"GOOG"]) {
//			return [[[BarChartTracker sharedInstance] weeklyPrices:@"GOOG"] objectAtIndex:index];            
//		} else if ([plot.identifier isEqual:@"MSFT"]) {
//			return [[[BarChartTracker sharedInstance] weeklyPrices:@"MSFT"] objectAtIndex:index];            
//		}
	}
	return [NSDecimalNumber numberWithUnsignedInteger:index]; 
}

//#pragma mark - CPTBarPlotDelegate methods
//-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
//	// 1 - Is the plot hidden?
//	if (plot.isHidden == YES) {
//		return;
//	}
//	// 2 - Create style, if necessary
//	static CPTMutableTextStyle *style = nil;
//	if (!style) {
//		style = [CPTMutableTextStyle textStyle];    
//		style.color= [CPTColor yellowColor];
//		style.fontSize = 16.0f;
//		style.fontName = @"Helvetica-Bold";        
//	}
//	// 3 - Create annotation, if necessary
//	NSNumber *price = [self numberForPlot:plot field:CPTBarPlotFieldBarTip recordIndex:index];
//	if (!self.priceAnnotation) {
//		NSNumber *x = [NSNumber numberWithInt:0];
//		NSNumber *y = [NSNumber numberWithInt:0];
//		NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
//		self.priceAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:anchorPoint];        
//	}
//	// 4 - Create number formatter, if needed
//	static NSNumberFormatter *formatter = nil;
//	if (!formatter) {
//		formatter = [[NSNumberFormatter alloc] init];
//		[formatter setMaximumFractionDigits:2];        
//	}
//	// 5 - Create text layer for annotation
//	NSString *priceValue = [formatter stringFromNumber:price];
//	CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:priceValue style:style];
//	self.priceAnnotation.contentLayer = textLayer;
//	// 6 - Get plot index based on identifier
//	NSInteger plotIndex = 0;
//	if ([plot.identifier isEqual:@"AAPL"] == YES) {
//		plotIndex = 0;
//    }
////	} else if ([plot.identifier isEqual:@"GOOG"] == YES) {
////		plotIndex = 1;
////	} else if ([plot.identifier isEqual:@"MSFT"] == YES) {
////		plotIndex = 2;
////	}    
//	// 7 - Get the anchor point for annotation
//	CGFloat x = index + CPDBarInitialX1 + (plotIndex * CPDBarWidth); 
//	NSNumber *anchorX = [NSNumber numberWithFloat:x];    
//	CGFloat y = [price floatValue] + 2.0f;
//	NSNumber *anchorY = [NSNumber numberWithFloat:y];    
//	self.priceAnnotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil]; 
//	// 8 - Add the annotation 
//	[plot.graph.plotAreaFrame.plotArea addAnnotation:self.priceAnnotation]; 
//}





#pragma mark - PickerView method
/*
 @Description:Numer of components in pickerview/Users/Umesh_chrome/Desktop/OrientationTutorial
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}


/*
 @Description:Numer of row in component 
 */
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
//    if (thePickerView == _dayIdentifierPickerView) {
//       return   [dayIdentifierArray count]; 
//    }else{
    return   [_trackerNameArray count];
   // }
}



/*
 @Description:Display data on pickerview
 */
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
   
//    if (thePickerView == _dayIdentifierPickerView) {
//        return   [dayIdentifierArray objectAtIndex:row]; 
//    }else{
    NSString *trackerName= [_trackerNameArray objectAtIndex:row];
    return trackerName ;  
   // }
}


/*
 @Description:Select row of component 
 */
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
   
//    if (thePickerView == _dayIdentifierPickerView) {
//        _dayIdentifierLabel.text = [dayIdentifierArray objectAtIndex:row];
//        //NSLog(@"_dayIdentifierPickerView  row :-> %i", row);
//        if (row == 0) {
//        
//                AllRecordView.hidden = YES;
//                landscapeView.hidden = NO;
//                lineChartView.hidden = YES;
//                
//                if( [_trackerNameArray count] > 7){
//                    
//                    [BarChartTracker sharedInstance].bartrackerName      =  _trackerNameLabel.text;
//                    [BarChartTracker sharedInstance].trackerBarchatArray =   _monthDayRecordArray;
//                    //bar 
//                    [landscapeView addSubview:self.hostView]; 
//                    [self initPlot];
//                }
//            } if( row == 1){
//                
//                AllRecordView.hidden  = YES; 
//                landscapeView.hidden = NO;
//                lineChartView.hidden = YES;
//                
//                if( [_trackerNameArray count] <= 7 ){
//                    [BarChartTracker sharedInstance].bartrackerName      =   _trackerNameLabel.text;
//                    [BarChartTracker sharedInstance].trackerBarchatArray =   _weekDayRecordArray;
//                    //bar 
//                    [landscapeView addSubview:self.hostView]; 
//                    [self initPlot];
//                }
//            } if(row == 2) {
//    
//                landscapeView.hidden = YES;
//                AllRecordView.hidden = NO;
//                lineChartView.hidden  = YES;
//                objLineChart.rotaionIdentify = YES;
//                [objLineChart   configureHost:AllRecordView frameSize:CGRectMake(0, 0,lineGraphWidth+170,LineGraphHieght-100)];
//        } 
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration : 1]; 
//        //_dayIdentifierPickerView.frame = CGRectMake(0, 500, 480, 216);
//        //_pickerClossView.frame         =  CGRectMake(0, 500, 480, 216);
//        [UIView commitAnimations];
//       // [self.view addSubview:_dayIdentifierPickerView];
//        
//    }else
    {
        
    _trackerNameLabel.text = [_trackerNameArray objectAtIndex:row];
    [LineGraphTracker sharedInstance].trackerName     =   [_trackerNameArray objectAtIndex:row];
    [BarChartTracker sharedInstance].bartrackerName   =   [_trackerNameArray objectAtIndex:row];
        
        for (GraphModel *obj in _trackerdayRecordArray ){
            
            if ([_trackerNameLabel.text isEqualToString:obj.trackerName]) {
                if ([[obj trackerSesion] intValue] > 3600) {
                    [LineGraphTracker sharedInstance].hourIdentifier = YES;
                    [BarChartTracker sharedInstance].barHourIdentifier = YES;
                    minuteHoursIdentify = NO;
                    
                    break;
                }else{
                    [LineGraphTracker sharedInstance].hourIdentifier = NO;
                    [BarChartTracker sharedInstance].barHourIdentifier = NO; 
                    minuteHoursIdentify = YES;
                }
            }
        }
        
     //bar 
	[landscapeView addSubview:self.hostView]; 
    [self initPlot];
    
    if(portraitIdentifier){
    lineChartView.hidden  = NO;
    landscapeView.hidden   = YES;
    AllRecordView.hidden  = YES;
        
        objLineChart.minuteAndHourIdentify = minuteHoursIdentify;
        objLineChart.rotaionIdentify = NO;
      [objLineChart   configureHost:lineChartView frameSize:CGRectMake(0, 0,lineGraphWidth,LineGraphHieght-135)];  
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1]; 
        //_trackeNamePickerView.frame = CGRectMake(40, 480, 320, 216);
       // _pickerClossView.frame     = CGRectMake(0, 500, 600, 400);  
        [UIView commitAnimations];
    } else{
        objLineChart.rotaionIdentify = YES;
        [objLineChart   configureHost:AllRecordView frameSize:CGRectMake(0, 10,lineGraphWidth+180,LineGraphHieght-130)]; 
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1]; 
       // _trackeNamePickerView.frame = CGRectMake(40, 480, 480, 216);
        //_pickerClossView.frame     = CGRectMake(0, 480, 600, 400); 
        [UIView commitAnimations];
    }
  }
}

-(IBAction)selectTrackerName:(id)sender{
   // NSLog(@" selectTrackerName ");
    if ([_trackerNameArray count] > 0) {
    if(portraitIdentifier){
        //  NSLog(@"%s portraitIdentifier",__FUNCTION__);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration : 1]; 
    _trackeNamePickerView.frame = CGRectMake(0, 240, 320, 216);
        
     _pickerClossView.frame     = CGRectMake(0, 200, 320, 216);  
    [UIView commitAnimations];
    [self.view addSubview:_trackeNamePickerView];
    }else{
         //NSLog(@"%s portraitIdentifier not",__FUNCTION__);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration : 1]; 
        _trackeNamePickerView.frame = CGRectMake(0, 100, 480, 216);
        _pickerClossView.frame     = CGRectMake(0, 65, 480, 216);  
        [UIView commitAnimations];
        [self.view addSubview:_trackeNamePickerView];
    }
    }
}

//-(IBAction)dayIdentifer:(id)sender{
//   // NSLog(@"%s ",__FUNCTION__);
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration : 1]; 
//     _pickerClossView.frame     = CGRectMake(0, 65, 600, 216);
//    
//   // _dayIdentifierPickerView.frame = CGRectMake(0, 100, 480, 216);
//   
//    [UIView commitAnimations];
//   // [self.view addSubview:_dayIdentifierPickerView];
//    
//    ///NSLog(@" dayIdentifer  :-> %i", [dayIdentifierArray count]);
//}


-(IBAction) pickerViewClosButton:(id)sender{
    
   
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration : 1]; 
    if (portraitIdentify) {
        _trackeNamePickerView.frame = CGRectMake(0, 540, 320 , 216);
        _pickerClossView.frame     = CGRectMake(0, 500, 600, 216);
        
       // _dayIdentifierPickerView.frame = CGRectMake(0, 549, 480, 216);
        NSLog(@" portrait ");
    }else{
        _trackeNamePickerView.frame = CGRectMake(0, 540, 480 , 216);
        _pickerClossView.frame     = CGRectMake(0, 500, 600, 216);
        
       // _dayIdentifierPickerView.frame = CGRectMake(0, 549, 480, 216);
        NSLog(@" land scape");
    }
   
    [UIView commitAnimations];
    
}



-(IBAction) weekRecords:(id)sender{
    NSLog(@"weekRecords");
    AllRecordView.hidden  = YES; 
    landscapeView.hidden = NO;
    lineChartView.hidden = YES;
    
   

    
   // if(weekGraphDisappear){
    [BarChartTracker sharedInstance].monthIndentifier = NO; 
        [BarChartTracker sharedInstance].bartrackerName      =   _trackerNameLabel.text;
        [BarChartTracker sharedInstance].trackerBarchatArray =   _weekDayRecordArray;
        
       // NSLog(@"***************** Week Day ");
         weekGraphDisappear  = NO;
       // } //bar 
        [landscapeView addSubview:self.hostView]; 
        [self initPlot];
      
      
    [_monthDayButton setSelected:NO];
    [_weekDayButton setSelected:YES];
    [_allDayButton setSelected:NO];
    _weekDayButton.titleLabel.textColor  = [UIColor blackColor];
    _monthDayButton.titleLabel.textColor = [UIColor whiteColor];
    _allDayButton.titleLabel.textColor   = [UIColor whiteColor];
    //[_allDayButton setBackgroundImage:[UIImage imageNamed:ALLBTNNORMALIMG] forState:UIControlStateSelected];  
    //[_weekDayButton setBackgroundImage:[UIImage imageNamed:WEEKBTNSELECTEDIMG] forState:UIControlStateNormal]; 
    //[_monthDayButton setBackgroundImage:[UIImage imageNamed:MONTHBTNNORMALIMG] forState:UIControlStateNormal];
}

-(IBAction) monthRecords:(id)sender{
     NSLog(@"monthRecords");
    
    AllRecordView.hidden = YES;
    landscapeView.hidden = NO;
    lineChartView.hidden = YES;
    
   
    
   //if(monthGraphDisappear){
        [BarChartTracker sharedInstance].monthIndentifier = YES; 
        [BarChartTracker sharedInstance].bartrackerName      =  _trackerNameLabel.text;
        [BarChartTracker sharedInstance].trackerBarchatArray =   _monthDayRecordArray;
    
      //  NSLog(@"***************** monthRecords ");
        monthGraphDisappear = NO;
     // }
        //bar 
        [landscapeView addSubview:self.hostView]; 
        [self initPlot];
   // }
    
    [_monthDayButton setSelected:YES];
    [_weekDayButton setSelected:NO];
    [_allDayButton setSelected:NO];
    _weekDayButton.titleLabel.textColor  = [UIColor whiteColor];
    _monthDayButton.titleLabel.textColor = [UIColor blackColor];
    _allDayButton.titleLabel.textColor   = [UIColor whiteColor];
    //[_allDayButton setBackgroundImage:[UIImage imageNamed:ALLBTNNORMALIMG] forState:UIControlStateSelected];  
   // [_weekDayButton setBackgroundImage:[UIImage imageNamed:WEEKBTNNORMALIMG] forState:UIControlStateNormal]; 
   // [_monthDayButton setBackgroundImage:[UIImage imageNamed:MONTHBTNSELECTEDIMG] forState:UIControlStateNormal]; 
}

-(IBAction) allRecords:(id)sender{
    //UIButton *button = sender;
    //button.titleLabel.textColor = [UIColor whiteColor];
   // _weekDayButton.titleLabel.textColor  = [UIColor whiteColor];
    //_monthDayButton.titleLabel.textColor = [UIColor whiteColor];
    //_allDayButton.titleLabel.textColor   = [UIColor whiteColor];
    
    landscapeView.hidden = YES;
    AllRecordView.hidden = NO;
    lineChartView.hidden  = YES;
    objLineChart.rotaionIdentify = YES;
    
   
    NSLog(@"allRecords");
    
    [objLineChart   configureHost:AllRecordView frameSize:CGRectMake(0, 10,lineGraphWidth+170,LineGraphHieght-130)];
    
    [_monthDayButton setSelected:NO];
    [_weekDayButton setSelected:NO];
    [_allDayButton setSelected:YES];
    _weekDayButton.titleLabel.textColor  = [UIColor whiteColor];
    _monthDayButton.titleLabel.textColor = [UIColor whiteColor];
    _allDayButton.titleLabel.textColor   = [UIColor blackColor];
  //  [_allDayButton setBackgroundImage:[UIImage imageNamed:ALLBTNSELECTEDIMG] forState:UIControlStateSelected];  
    //[_weekDayButton setBackgroundImage:[UIImage imageNamed:WEEKBTNNORMALIMG] forState:UIControlStateNormal]; 
   // [_monthDayButton setBackgroundImage:[UIImage imageNamed:MONTHBTNNORMALIMG] forState:UIControlStateNormal]; 
}

- (BOOL)shouldAutorotate
{
    UIInterfaceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
    _pickerClossView.frame     = CGRectMake(0, 600, 480, 216);
    _trackeNamePickerView.frame = CGRectMake(0, 600, 480, 216);
	if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortrait)
	{
		//self.view = portraitView;
        
        //NSLog(@" Pratrit mode Raja");
        adView.hidden = NO;
        if([[UIScreen mainScreen] bounds].size.height == 568.0f || [[UIScreen mainScreen] bounds].size.width == 568.0f){
            adView.frame = CGRectMake(0,405,320,50);
        }
        else{
            adView.frame = CGRectMake(0,315,320,50);
        }
        lineChartView.hidden = NO;
        AllRecordView.hidden = YES;
        landscapeView.hidden = YES;
        //
        _weekDayButton.hidden  = YES;
        _monthDayButton.hidden = YES;
        _allDayButton.hidden   = YES;
        //
        _pickerCloseBttn.frame = CGRectMake(250, 2, 57, 29);
        
        _landscapeModeTrackerNameView.frame = CGRectMake(181, 3, 109, 31);
        TrackerNameIndecatorLbl.frame        = CGRectMake(30, 13, 79, 15);
        
        portraitIdentifier = YES;
        objLineChart.rotaionIdentify = NO;
        [objLineChart   configureHost:lineChartView frameSize:CGRectMake(0, 0,lineGraphWidth,LineGraphHieght-135)];
        self.tabBarController.tabBar.userInteractionEnabled = YES;
        _messageTextView.hidden = NO;
        
        // [self.view addSubview:_messageTextView];
        portraitIdentify = YES;
        //
        //[window addSubview:objTabBar.view];
        self.navigationController.navigationBarHidden = NO;
        //Set label to identify minutes and hours.
        _trackeTitleLbl.hidden = YES;
        
        //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);
        //[_tabBarView removeFromSuperview];
        //Semove bar graph on window
        //  [self.view removeFromSuperview];
        //  [objTabBar.view addSubview:self.view];
    }
	else if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        adView.hidden = YES;
//        CGRect frame1 = adView.frame;
//        frame1.origin.y = frame1.origin.y - 200;
//        adView.frame = frame1;
        NSLog(@" Landscape  mode ");
        lineChartView.hidden    = YES;
        AllRecordView.hidden    = YES;
        landscapeView.hidden    = NO;
        portraitIdentifier      = NO;
        //
        _weekDayButton.hidden  = NO;
        _monthDayButton.hidden = NO;
        _allDayButton.hidden   = NO;
        
        _pickerCloseBttn.frame = CGRectMake(420, 2, 57, 29);
        
        _landscapeModeTrackerNameView.frame = CGRectMake(230, 3, 109, 31);
        TrackerNameIndecatorLbl.frame        = CGRectMake(130, 13, 79, 15);
        
        self.tabBarController.tabBar.userInteractionEnabled = NO;
        
        _messageTextView.hidden = YES;
        portraitIdentify = NO;
        //
        //[window addSubview:self.view];
        //[objTabBar.view removeFromSuperview];
        self.navigationController.navigationBarHidden = YES;
        
        //Set label to identify minutes and hours.
        _trackeTitleLbl.hidden = NO;
        
        //[window addSubview:_tabbarHideView];
        //_tabBarView.frame = CGRectMake(270, 0, 500, 500);
        // dayTitleLbl.frame = CGRectMake(50, 0, 10, 60);
        //_tabBarView.backgroundColor = [UIColor blackColor];
        //[_tabBarView addSubview:dayTitleLbl];
        if(landscapeIdentify){
            // [window addSubview:_tabBarView];
        }
        // _dayIdentifierLabel.text = @"Last Week";
        //
        //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        //Add bar graph on window
        // [window addSubview:self.view];
        
        
        
        
        
        [BarChartTracker sharedInstance].monthIndentifier = NO;
        [BarChartTracker sharedInstance].bartrackerName      =   _trackerNameLabel.text;
        [BarChartTracker sharedInstance].trackerBarchatArray =   _weekDayRecordArray;
        
        // NSLog(@"***************** Week Day ");
        weekGraphDisappear  = NO;
        // } //bar
        [landscapeView addSubview:self.hostView];
        [self initPlot];
        
        
        [_monthDayButton setSelected:NO];
        [_weekDayButton setSelected:YES];
        [_allDayButton setSelected:NO];
        
        _weekDayButton.titleLabel.textColor  = [UIColor blackColor];
        _monthDayButton.titleLabel.textColor = [UIColor whiteColor];
        _allDayButton.titleLabel.textColor   = [UIColor whiteColor];
        
        
        
        
    }else if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        // NSLog(@" Landscape  mode ");
        adView.hidden = YES;
//        CGRect frame1 = adView.frame;
//        frame1.origin.y = frame1.origin.y - 200;
//        adView.frame = frame1;
        lineChartView.hidden     = YES;
        AllRecordView.hidden    = YES;
        landscapeView.hidden    = NO;
		//self.view = landscapeView;
        portraitIdentifier = NO;
        //
        _pickerCloseBttn.frame = CGRectMake(420, 2, 57, 29);
        
        _landscapeModeTrackerNameView.frame = CGRectMake(230, 3, 109, 31);
        TrackerNameIndecatorLbl.frame        = CGRectMake(130, 13, 79, 15);
        
        _weekDayButton.hidden  = NO;
        _monthDayButton.hidden = NO;
        _allDayButton.hidden   = NO;
        
        
        
        self.tabBarController.tabBar.userInteractionEnabled = NO;
        _messageTextView.hidden = YES;
        portraitIdentify = NO;
        //
        //[window addSubview:self.view];
        //[objTabBar.view removeFromSuperview];
        //objTabBar.hidesBottomBarWhenPushed = YES;
        self.navigationController.navigationBarHidden = YES;
        
        //Set label to identify minutes and hours.
        _trackeTitleLbl.hidden = NO;
        
        // _tabBarView.frame = CGRectMake(0, 0, 50, 500);
        // _tabBarView.backgroundColor = [UIColor blackColor];
        
        if(landscapeIdentify){
            // [window addSubview:_tabBarView];
        }
        // _dayIdentifierLabel.text = @"Last Week";
        //  [[UIApplication sharedApplication] setStatusBarHidden:YES];
        //Add bar graph on window
        //[window addSubview:self.view];
        //self.hidesBottomBarWhenPushed = YES;
        //self.view.backgroundColor = [UIColor whiteColor] ;
        //[self.view setNeedsDisplayInRect:CGRectMake(0, 0, 480, 320)];
        // [self setWantsFullScreenLayout:YES];
        //self.view.frame = CGRectMake(0, 0, 500, 500);
        
        
        [BarChartTracker sharedInstance].monthIndentifier = NO;
        [BarChartTracker sharedInstance].bartrackerName      =   _trackerNameLabel.text;
        [BarChartTracker sharedInstance].trackerBarchatArray =   _weekDayRecordArray;
        
        // NSLog(@"***************** Week Day ");
        weekGraphDisappear  = NO;
        // } //bar
        [landscapeView addSubview:self.hostView];
        [self initPlot];
        
        
        [_monthDayButton setSelected:NO];
        [_weekDayButton setSelected:YES];
        [_allDayButton setSelected:NO];
        
        _weekDayButton.titleLabel.textColor  = [UIColor blackColor];
        _monthDayButton.titleLabel.textColor = [UIColor whiteColor];
        _allDayButton.titleLabel.textColor   = [UIColor whiteColor];
        
        
        
        
        
    }
    else if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        adView.hidden = NO;
        if([[UIScreen mainScreen] bounds].size.height == 568.0f || [[UIScreen mainScreen] bounds].size.width == 568.0f){
            adView.frame = CGRectMake(0,405,320,50);
        }
        else{
            adView.frame = CGRectMake(0,315,320,50);
        }
        portraitIdentifier      =   YES;
        
        lineChartView.hidden    =   NO;
        AllRecordView.hidden    =   YES;
        landscapeView.hidden    =   YES;
        //Button hide
        _pickerCloseBttn.frame = CGRectMake(250, 2, 57, 29);
        
        _landscapeModeTrackerNameView.frame = CGRectMake(181, 3, 109, 31);
        TrackerNameIndecatorLbl.frame        = CGRectMake(30, 13, 79, 15);
        
        _weekDayButton.hidden   =   YES;
        _monthDayButton.hidden  =   YES;
        _allDayButton.hidden    =   YES;
        objLineChart.rotaionIdentify = NO;
        [objLineChart   configureHost:lineChartView frameSize:CGRectMake(0, 0,lineGraphWidth,LineGraphHieght-135
                                                                         )];
        
        self.tabBarController.tabBar.userInteractionEnabled = YES;
        _messageTextView.hidden = NO;
        portraitIdentify = YES;
        //
        //[window addSubview:objTabBar.view];
        self.navigationController.navigationBarHidden = NO;
        //
        _trackeTitleLbl.hidden = YES;
        //
        //[_tabBarView removeFromSuperview];
        // [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);
        //Semove bar graph on window
        //[self.view removeFromSuperview];
        
    }
    return YES;
}

- (NSInteger)supportedInterfaceOrientations
{
    UIInterfaceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
    _pickerClossView.frame     = CGRectMake(0, 600, 480, 216);
    _trackeNamePickerView.frame = CGRectMake(0, 600, 480, 216);
	if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortrait)
	{
		//self.view = portraitView;
        
        //NSLog(@" Pratrit mode Raja");
        adView.hidden = NO;
        if([[UIScreen mainScreen] bounds].size.height == 568.0f || [[UIScreen mainScreen] bounds].size.width == 568.0f){
            adView.frame = CGRectMake(0,405,320,50);
        }
        else{
            adView.frame = CGRectMake(0,315,320,50);
        }
        lineChartView.hidden = NO;
        AllRecordView.hidden = YES;
        landscapeView.hidden = YES;
        //
        _weekDayButton.hidden  = YES;
        _monthDayButton.hidden = YES;
        _allDayButton.hidden   = YES;
        //
        _pickerCloseBttn.frame = CGRectMake(250, 2, 57, 29);
        
        _landscapeModeTrackerNameView.frame = CGRectMake(181, 3, 109, 31);
        TrackerNameIndecatorLbl.frame        = CGRectMake(30, 13, 79, 15);
        
        portraitIdentifier = YES;
        objLineChart.rotaionIdentify = NO;
        [objLineChart   configureHost:lineChartView frameSize:CGRectMake(0, 0,lineGraphWidth,LineGraphHieght-135)];
        self.tabBarController.tabBar.userInteractionEnabled = YES;
        _messageTextView.hidden = NO;
        
        // [self.view addSubview:_messageTextView];
        portraitIdentify = YES;
        //
        //[window addSubview:objTabBar.view];
        self.navigationController.navigationBarHidden = NO;
        //Set label to identify minutes and hours.
        _trackeTitleLbl.hidden = YES;
        
        //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);
        //[_tabBarView removeFromSuperview];
        //Semove bar graph on window
        //  [self.view removeFromSuperview];
        //  [objTabBar.view addSubview:self.view];
    }
	else if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        adView.hidden = YES;
//        CGRect frame1 = adView.frame;
//        frame1.origin.y = frame1.origin.y - 200;
//        adView.frame = frame1;
        NSLog(@" Landscape  mode ");
        lineChartView.hidden    = YES;
        AllRecordView.hidden    = YES;
        landscapeView.hidden    = NO;
        portraitIdentifier      = NO;
        //
        _weekDayButton.hidden  = NO;
        _monthDayButton.hidden = NO;
        _allDayButton.hidden   = NO;
        
        _pickerCloseBttn.frame = CGRectMake(420, 2, 57, 29);
        
        _landscapeModeTrackerNameView.frame = CGRectMake(230, 3, 109, 31);
        TrackerNameIndecatorLbl.frame        = CGRectMake(130, 13, 79, 15);
        
        self.tabBarController.tabBar.userInteractionEnabled = NO;
        
        _messageTextView.hidden = YES;
        portraitIdentify = NO;
        //
        //[window addSubview:self.view];
        //[objTabBar.view removeFromSuperview];
        self.navigationController.navigationBarHidden = YES;
        
        //Set label to identify minutes and hours.
        _trackeTitleLbl.hidden = NO;
        
        //[window addSubview:_tabbarHideView];
        //_tabBarView.frame = CGRectMake(270, 0, 500, 500);
        // dayTitleLbl.frame = CGRectMake(50, 0, 10, 60);
        //_tabBarView.backgroundColor = [UIColor blackColor];
        //[_tabBarView addSubview:dayTitleLbl];
        if(landscapeIdentify){
            // [window addSubview:_tabBarView];
        }
        // _dayIdentifierLabel.text = @"Last Week";
        //
        //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        //Add bar graph on window
        // [window addSubview:self.view];
        
        
        
        
        
        [BarChartTracker sharedInstance].monthIndentifier = NO;
        [BarChartTracker sharedInstance].bartrackerName      =   _trackerNameLabel.text;
        [BarChartTracker sharedInstance].trackerBarchatArray =   _weekDayRecordArray;
        
        // NSLog(@"***************** Week Day ");
        weekGraphDisappear  = NO;
        // } //bar
        [landscapeView addSubview:self.hostView];
        [self initPlot];
        
        
        [_monthDayButton setSelected:NO];
        [_weekDayButton setSelected:YES];
        [_allDayButton setSelected:NO];
        
        _weekDayButton.titleLabel.textColor  = [UIColor blackColor];
        _monthDayButton.titleLabel.textColor = [UIColor whiteColor];
        _allDayButton.titleLabel.textColor   = [UIColor whiteColor];
        
        
        
        
    }else if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        // NSLog(@" Landscape  mode ");
        adView.hidden = YES;
//        CGRect frame1 = adView.frame;
//        frame1.origin.y = frame1.origin.y - 200;
//        adView.frame = frame1;
        lineChartView.hidden     = YES;
        AllRecordView.hidden    = YES;
        landscapeView.hidden    = NO;
		//self.view = landscapeView;
        portraitIdentifier = NO;
        //
        _pickerCloseBttn.frame = CGRectMake(420, 2, 57, 29);
        
        _landscapeModeTrackerNameView.frame = CGRectMake(230, 3, 109, 31);
        TrackerNameIndecatorLbl.frame        = CGRectMake(130, 13, 79, 15);
        
        _weekDayButton.hidden  = NO;
        _monthDayButton.hidden = NO;
        _allDayButton.hidden   = NO;
        
        
        
        self.tabBarController.tabBar.userInteractionEnabled = NO;
        _messageTextView.hidden = YES;
        portraitIdentify = NO;
        //
        //[window addSubview:self.view];
        //[objTabBar.view removeFromSuperview];
        //objTabBar.hidesBottomBarWhenPushed = YES;
        self.navigationController.navigationBarHidden = YES;
        
        //Set label to identify minutes and hours.
        _trackeTitleLbl.hidden = NO;
        
        // _tabBarView.frame = CGRectMake(0, 0, 50, 500);
        // _tabBarView.backgroundColor = [UIColor blackColor];
        
        if(landscapeIdentify){
            // [window addSubview:_tabBarView];
        }
        // _dayIdentifierLabel.text = @"Last Week";
        //  [[UIApplication sharedApplication] setStatusBarHidden:YES];
        //Add bar graph on window
        //[window addSubview:self.view];
        //self.hidesBottomBarWhenPushed = YES;
        //self.view.backgroundColor = [UIColor whiteColor] ;
        //[self.view setNeedsDisplayInRect:CGRectMake(0, 0, 480, 320)];
        // [self setWantsFullScreenLayout:YES];
        //self.view.frame = CGRectMake(0, 0, 500, 500);
        
        
        [BarChartTracker sharedInstance].monthIndentifier = NO;
        [BarChartTracker sharedInstance].bartrackerName      =   _trackerNameLabel.text;
        [BarChartTracker sharedInstance].trackerBarchatArray =   _weekDayRecordArray;
        
        // NSLog(@"***************** Week Day ");
        weekGraphDisappear  = NO;
        // } //bar
        [landscapeView addSubview:self.hostView];
        [self initPlot];
        
        
        [_monthDayButton setSelected:NO];
        [_weekDayButton setSelected:YES];
        [_allDayButton setSelected:NO];
        
        _weekDayButton.titleLabel.textColor  = [UIColor blackColor];
        _monthDayButton.titleLabel.textColor = [UIColor whiteColor];
        _allDayButton.titleLabel.textColor   = [UIColor whiteColor];
        
        
        
        
        
    }
    else if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        adView.hidden = NO;
        if([[UIScreen mainScreen] bounds].size.height == 568.0f || [[UIScreen mainScreen] bounds].size.width == 568.0f){
            adView.frame = CGRectMake(0,405,320,50);
        }
        else{
            adView.frame = CGRectMake(0,315,320,50);
        }
        portraitIdentifier      =   YES;
        
        lineChartView.hidden    =   NO;
        AllRecordView.hidden    =   YES;
        landscapeView.hidden    =   YES;
        //Button hide
        _pickerCloseBttn.frame = CGRectMake(250, 2, 57, 29);
        
        _landscapeModeTrackerNameView.frame = CGRectMake(181, 3, 109, 31);
        TrackerNameIndecatorLbl.frame        = CGRectMake(30, 13, 79, 15);
        
        _weekDayButton.hidden   =   YES;
        _monthDayButton.hidden  =   YES;
        _allDayButton.hidden    =   YES;
        objLineChart.rotaionIdentify = NO;
        [objLineChart   configureHost:lineChartView frameSize:CGRectMake(0, 0,lineGraphWidth,LineGraphHieght-135
                                                                         )];
        
        self.tabBarController.tabBar.userInteractionEnabled = YES;
        _messageTextView.hidden = NO;
        portraitIdentify = YES;
        //
        //[window addSubview:objTabBar.view];
        self.navigationController.navigationBarHidden = NO;
        //
        _trackeTitleLbl.hidden = YES;
        //
        //[_tabBarView removeFromSuperview];
        // [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);
        //Semove bar graph on window
        //[self.view removeFromSuperview];
        
    }
    return UIInterfaceOrientationMaskAll;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    _pickerClossView.frame     = CGRectMake(0, 600, 480, 216);
    _trackeNamePickerView.frame = CGRectMake(0, 600, 480, 216);
	if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortrait)
	{
		//self.view = portraitView;
        
        NSLog(@" Pratrit mode ");
        adView.hidden = NO;
        if([[UIScreen mainScreen] bounds].size.height == 568.0f || [[UIScreen mainScreen] bounds].size.width == 568.0f){
            adView.frame = CGRectMake(0,405,320,50);
        }
        else{
            adView.frame = CGRectMake(0,315,320,50);
        }
        lineChartView.hidden = NO;
        AllRecordView.hidden = YES;
        landscapeView.hidden = YES;
        //
        _weekDayButton.hidden  = YES;
        _monthDayButton.hidden = YES;
        _allDayButton.hidden   = YES;
        //
        _pickerCloseBttn.frame = CGRectMake(250, 2, 57, 29);
        
        _landscapeModeTrackerNameView.frame = CGRectMake(181, 3, 109, 31);
        TrackerNameIndecatorLbl.frame        = CGRectMake(30, 13, 79, 15);
        
        portraitIdentifier = YES;
        objLineChart.rotaionIdentify = NO;
        [objLineChart   configureHost:lineChartView frameSize:CGRectMake(0, 0,lineGraphWidth,LineGraphHieght-135)];
        self.tabBarController.tabBar.userInteractionEnabled = YES;
        _messageTextView.hidden = NO;
        
        // [self.view addSubview:_messageTextView];
        portraitIdentify = YES;
        //
        //[window addSubview:objTabBar.view];
        self.navigationController.navigationBarHidden = NO;
        //Set label to identify minutes and hours.
        _trackeTitleLbl.hidden = YES;
        
        //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);
        //[_tabBarView removeFromSuperview];
        //Semove bar graph on window
        //  [self.view removeFromSuperview];
        //  [objTabBar.view addSubview:self.view];
    }
	else if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        adView.hidden = YES;
//        CGRect frame1 = adView.frame;
//        frame1.origin.y = frame1.origin.y - 200;
//        adView.frame = frame1;
        NSLog(@" Landscape  mode ");
        lineChartView.hidden    = YES;
        AllRecordView.hidden    = YES;
        landscapeView.hidden    = NO;
        portraitIdentifier      = NO;
        //
        _weekDayButton.hidden  = NO;
        _monthDayButton.hidden = NO;
        _allDayButton.hidden   = NO;
        
        _pickerCloseBttn.frame = CGRectMake(420, 2, 57, 29);
        
        _landscapeModeTrackerNameView.frame = CGRectMake(230, 3, 109, 31);
        TrackerNameIndecatorLbl.frame        = CGRectMake(130, 13, 79, 15);
        
        self.tabBarController.tabBar.userInteractionEnabled = NO;
        
        _messageTextView.hidden = YES;
        portraitIdentify = NO;
        //
        //[window addSubview:self.view];
        //[objTabBar.view removeFromSuperview];
        self.navigationController.navigationBarHidden = YES;
        
        //Set label to identify minutes and hours.
        _trackeTitleLbl.hidden = NO;
        
        //[window addSubview:_tabbarHideView];
        //_tabBarView.frame = CGRectMake(270, 0, 500, 500);
        // dayTitleLbl.frame = CGRectMake(50, 0, 10, 60);
        //_tabBarView.backgroundColor = [UIColor blackColor];
        //[_tabBarView addSubview:dayTitleLbl];
        if(landscapeIdentify){
            // [window addSubview:_tabBarView];
        }
        // _dayIdentifierLabel.text = @"Last Week";
        //
        //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        //Add bar graph on window
        // [window addSubview:self.view];
        
        
        
        
        
        [BarChartTracker sharedInstance].monthIndentifier = NO;
        [BarChartTracker sharedInstance].bartrackerName      =   _trackerNameLabel.text;
        [BarChartTracker sharedInstance].trackerBarchatArray =   _weekDayRecordArray;
        
        // NSLog(@"***************** Week Day ");
        weekGraphDisappear  = NO;
        // } //bar
        [landscapeView addSubview:self.hostView];
        [self initPlot];
        
        
        [_monthDayButton setSelected:NO];
        [_weekDayButton setSelected:YES];
        [_allDayButton setSelected:NO];
        
        _weekDayButton.titleLabel.textColor  = [UIColor blackColor];
        _monthDayButton.titleLabel.textColor = [UIColor whiteColor];
        _allDayButton.titleLabel.textColor   = [UIColor whiteColor];
        
        
        
        
    }else if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        // NSLog(@" Landscape  mode ");
        adView.hidden = YES;
//        CGRect frame1 = adView.frame;
//        frame1.origin.y = frame1.origin.y - 200;
//        adView.frame = frame1;
        lineChartView.hidden     = YES;
        AllRecordView.hidden    = YES;
        landscapeView.hidden    = NO;
		//self.view = landscapeView;
        portraitIdentifier = NO;
        //
        _pickerCloseBttn.frame = CGRectMake(420, 2, 57, 29);
        
        _landscapeModeTrackerNameView.frame = CGRectMake(230, 3, 109, 31);
        TrackerNameIndecatorLbl.frame        = CGRectMake(130, 13, 79, 15);
        
        _weekDayButton.hidden  = NO;
        _monthDayButton.hidden = NO;
        _allDayButton.hidden   = NO;
        
        
        
        self.tabBarController.tabBar.userInteractionEnabled = NO;
        _messageTextView.hidden = YES;
        portraitIdentify = NO;
        //
        //[window addSubview:self.view];
        //[objTabBar.view removeFromSuperview];
        //objTabBar.hidesBottomBarWhenPushed = YES;
        self.navigationController.navigationBarHidden = YES;
        
        //Set label to identify minutes and hours.
        _trackeTitleLbl.hidden = NO;
        
        // _tabBarView.frame = CGRectMake(0, 0, 50, 500);
        // _tabBarView.backgroundColor = [UIColor blackColor];
        
        if(landscapeIdentify){
            // [window addSubview:_tabBarView];
        }
        // _dayIdentifierLabel.text = @"Last Week";
        //  [[UIApplication sharedApplication] setStatusBarHidden:YES];
        //Add bar graph on window
        //[window addSubview:self.view];
        //self.hidesBottomBarWhenPushed = YES;
        //self.view.backgroundColor = [UIColor whiteColor] ;
        //[self.view setNeedsDisplayInRect:CGRectMake(0, 0, 480, 320)];
        // [self setWantsFullScreenLayout:YES];
        //self.view.frame = CGRectMake(0, 0, 500, 500);
        
        
        [BarChartTracker sharedInstance].monthIndentifier = NO;
        [BarChartTracker sharedInstance].bartrackerName      =   _trackerNameLabel.text;
        [BarChartTracker sharedInstance].trackerBarchatArray =   _weekDayRecordArray;
        
        // NSLog(@"***************** Week Day ");
        weekGraphDisappear  = NO;
        // } //bar
        [landscapeView addSubview:self.hostView];
        [self initPlot];
        
        
        [_monthDayButton setSelected:NO];
        [_weekDayButton setSelected:YES];
        [_allDayButton setSelected:NO];
        
        _weekDayButton.titleLabel.textColor  = [UIColor blackColor];
        _monthDayButton.titleLabel.textColor = [UIColor whiteColor];
        _allDayButton.titleLabel.textColor   = [UIColor whiteColor];
        
        
        
        
        
    }
    else if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        adView.hidden = NO;
        if([[UIScreen mainScreen] bounds].size.height == 568.0f || [[UIScreen mainScreen] bounds].size.width == 568.0f){
            adView.frame = CGRectMake(0,405,320,50);
        }
        else{
            adView.frame = CGRectMake(0,315,320,50);
        }
        portraitIdentifier      =   YES;
        
        lineChartView.hidden    =   NO;
        AllRecordView.hidden    =   YES;
        landscapeView.hidden    =   YES;
        //Button hide
        _pickerCloseBttn.frame = CGRectMake(250, 2, 57, 29);
        
        _landscapeModeTrackerNameView.frame = CGRectMake(181, 3, 109, 31);
        TrackerNameIndecatorLbl.frame        = CGRectMake(30, 13, 79, 15);
        
        _weekDayButton.hidden   =   YES;
        _monthDayButton.hidden  =   YES;
        _allDayButton.hidden    =   YES;
        objLineChart.rotaionIdentify = NO;
        [objLineChart   configureHost:lineChartView frameSize:CGRectMake(0, 0,lineGraphWidth,LineGraphHieght-135
                                                                         )];
        
        self.tabBarController.tabBar.userInteractionEnabled = YES;
        _messageTextView.hidden = NO;
        portraitIdentify = YES;
        //
        //[window addSubview:objTabBar.view];
        self.navigationController.navigationBarHidden = NO;
        //
        _trackeTitleLbl.hidden = YES;
        //
        //[_tabBarView removeFromSuperview];
        // [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);
        //Semove bar graph on window
        //[self.view removeFromSuperview];
        
    }
    return YES;
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);;
}

//-(NSMutableArray *) manageAllDayTime:(NSMutableArray *) recordArray{
//    NSArray  *startDateArray;
//    NSArray  *endDateArray;
//    
//    NSArray  *timeArray;
//    //NSArray  *hourArray;
//   // NSArray  *minutesArray;
//    
//    NSMutableArray *timeDeviderArray = nil;
//    timeDeviderArray = [[NSMutableArray alloc] init ];
//    
//    NSString *currentTraker = _trackerNameLabel.text;
//    
//    NSString *startTime;
//    NSString *endTime;
//    //
//    long time = 0;
//    //
//    BOOL deviderIdentifier = NO;
//    
//    for (GraphModel *obj in  recordArray) {
//        
//       
//        
//      if([currentTraker isEqualToString:obj.trackerName] ){
//          
//           TimeDividerModel *objTimeDivider = [TimeDividerModel new];
//    startTime = [obj trackerStartTime];
//    endTime   = [obj trackerEndTime];
//    startDateArray = [startTime componentsSeparatedByString:@" "];
//    endDateArray   = [endTime componentsSeparatedByString:@" "];
//          
//          NSString *str1 = [startDateArray objectAtIndex:2];
//          NSString *str2 = [endDateArray  objectAtIndex:2];
//          //Time
//          NSString *str3 = [endDateArray  objectAtIndex:1];
//          
//     if ( [str1 isEqualToString:str2]) {
//         
//         objTimeDivider.trackerName = obj.trackerName;
//         long sessionTotal = [obj.trackerSesion intValue] + time;
//         objTimeDivider.trackerSesion = [NSString stringWithFormat:@"%i",sessionTotal];
//         
//         [timeDeviderArray addObject:objTimeDivider];
//         deviderIdentifier = NO;
//     }else{
//         timeArray = [str3 componentsSeparatedByString:@":"];
//        //
//         NSString *hours =  [endDateArray  objectAtIndex:0];
//         NSString *minute = [endDateArray  objectAtIndex:1];
//         
//         long timeCounter = (24*60) - ([hours intValue]*60 + [minute intValue]);
//         
//         if ((timeCounter*60) >= [[obj currentSession] intValue]) {
//             
//             objTimeDivider.trackerName = obj.trackerName;
//             long sessionTotal = [obj.trackerSesion intValue] + time;
//             objTimeDivider.trackerSesion = [NSString stringWithFormat:@"%i",sessionTotal];
//             
//             [timeDeviderArray addObject:objTimeDivider];
//             deviderIdentifier = NO;
//         }else{
//             time = [[obj currentSession] intValue] - (timeCounter*60) ;
//             long CurrentTime    = [[obj trackerSesion] intValue] - time;
//             objTimeDivider.trackerName = obj.trackerName;
//             objTimeDivider.trackerSesion = [NSString stringWithFormat:@"%i",CurrentTime];
//             
//             [timeDeviderArray addObject:objTimeDivider];
//             
//             deviderIdentifier = YES;
//             //[obj trackerSesion] = [NSString stringWithFormat:@"%i",time]; 
//             //[[obj trackerSesion] intValue] - time;   
//         }
//     }
//    }
//        
//    }
//    
//    if (deviderIdentifier) {
//        TimeDividerModel *objTimeDivider = [TimeDividerModel new];
//         objTimeDivider.trackerName = _trackerNameLabel.text;
//        objTimeDivider.trackerSesion = [NSString stringWithFormat:@"%i",time];
//    }
//    return timeDeviderArray;  
//}
//    
//        barcounterArray = [[NSMutableArray  alloc]  init];
//        [barcounterArray addObject:[ NSString stringWithFormat:@"0"]];
//        int counter = 1;
//        for (int i = 0; i < [recordArray count]; i++ ) {
//            
//            GraphModel * obj = [trackerBarchatArray objectAtIndex:i];
//            //NSLog(@"Line Graph Travker in session :-> %@",[obj trackerName]);
//            
//            if([bartrackerName isEqualToString:obj.trackerName] ){
//                
//                //                NSLog(@"Line Graph Travker in Start time :-> %@",[obj trackerStartTime]);
//                //                NSLog(@"Line Graph Travker in end Time  :-> %@",[obj trackerEndTime]);
//                //                NSLog(@"Line Graph Travker in session  :-> %@",[obj currentSession]);
//                                
//                //NSLog(@"start :->  %@",[startDateArray objectAtIndex:2]);
//                // NSLog(@"End :->  %@",[endDateArray objectAtIndex:2]);
//               
//                    [barcounterArray addObject:[ NSString stringWithFormat:@"%i",counter]];
//                    //NSLog(@"traker Day : %i Tracker Name : %@",counter,bartrackerName);
//                    counter = counter +1;
//                } else{
//                    
//                }
//                [barcounterArray addObject:[ NSString stringWithFormat:@"%i",counter]];
//                //NSLog(@"traker Day : %i Tracker Name : %@",counter,bartrackerName);
//                counter = counter +1;
//            }
//        }
//    
//
//}

@end
