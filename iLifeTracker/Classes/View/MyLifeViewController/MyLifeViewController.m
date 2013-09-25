//
//  MyLifeViewController.m
//  iLifeTracker
//
//  Created by Umesh on 26/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyLifeViewController.h"

@implementation MyLifeViewController


#pragma mark - View lifecycle
@synthesize bannerIsVisible;
//@synthesize toolbar = toolbar_;
//@synthesize themeButton = themeButton_;
@synthesize hostView = hostView_;
@synthesize selectedTheme = selectedTheme_;
@synthesize  _myLifeInfoArray,_categoryArray,recentActivityArr,trackerSessionArr;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"My Life";
        self.tabBarItem.image = [UIImage imageNamed:@"my life"];
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

-(void) viewDidLoad{
    //_categoryNameLabel.text = @"<span style='color: yellow;'>Hello</span> <span style='color: green'>World</span>";
   // NSString *str = @"bj";

//    [_CategoryLabel setFont:[UIFont fontWithName:FONTNAME size:24]];
    
    UIImage *image = [UIImage imageNamed:NAVIGATIONBARIMGNAME];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

    
    _myLifeTableView.backgroundColor = [UIColor clearColor];
    _myLifeTableView.scrollEnabled = NO;
     _myLifeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_boldTitleLabel1 setFont:[UIFont fontWithName:FONTNAME size:24]];
    [_boldTitleLabel2 setFont:[UIFont fontWithName:FONTNAME size:24]];
    [_boldTitleLabel3 setFont:[UIFont fontWithName:FONTNAME size:24]];
    [_boldTitleLabel4 setFont:[UIFont fontWithName:FONTNAME size:24]];
    [_boldTitleLabel5 setFont:[UIFont fontWithName:FONTNAME size:24]];
    [_boldTitleLabel6 setFont:[UIFont fontWithName:FONTNAME size:24]];
    
    
    CGRect parentRect = self.view.bounds;
	//CGSize toolbarSize = self.toolbar.bounds.size;
	parentRect = CGRectMake(0,0,320,250);
	// 2 - Create host view
    self.hostView = nil;
	self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:parentRect];
	self.hostView.allowPinchScaling = NO;
    
	[_myLifeScrollView addSubview:self.hostView];   
    pickerClossView.backgroundColor = [UIColor clearColor]; 
    
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
    [super viewDidAppear:animated];
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // The plot is initialized here, since the view bounds have not transformed for landscape till now
   // [UIApplication sharedApplication].statusBarHidden = NO;
    //[[UIApplication sharedApplication] setStatusBarHidden:NO];
    CommonUtilClass *commonObj = [[CommonUtilClass alloc] init];
    adView.backgroundColor = [UIColor clearColor];
   // adView.delegate = self;
    // adView.frame = CGRectMake(0,320,400,50);
    adView = [commonObj iADView];
    [self.view addSubview:adView];
    [self.view bringSubviewToFront:adView];

    [self initPlot];
    long trackerSession = 0; 
    NSString *categoryIdentifier;
    bool  boolValue = YES;
    long  TotalTimeCounter;
    TotalTimeCounter = 0;
    //Category detail.
    long  mostTracker;
    bool  ctgboolValue = YES;
    
    DataBaseController *obj = [DataBaseController DBControllerharedInstance];
    
    _myLifeInfoArray = [obj trackerDetail];
    
     _categoryArray = [obj myLifeDetailInfo];
    
    recentActivityArr = [obj myLifeRecentActivityTrackerName];
    
    for (TrackerDetailModel *objTrackerModel in _myLifeInfoArray) {
        //Tracker
        if (boolValue) {
            _mostUsedTrackerLebal.text = objTrackerModel.trackerName;
            trackerSession =  [[objTrackerModel  trackerSetion] intValue];
           
            if([_categoryArray count]>0){
            CategoryInfoModel *objCategoryModel = [_categoryArray objectAtIndex:0];
            categoryIdentifier = [objCategoryModel trackerCategory];
                _totalTrackerCtgLabel.text  = [objCategoryModel trackercount];
                _tolalTimeCtgLabel.text     = [CommonUtilClass convetIntoTimeFormatSecond:[[objCategoryModel  totalTime] intValue]];
                _categoryNameLabel.text  = [objCategoryModel trackerCategory];
            }
            
            boolValue = NO;
        } else{
            if (trackerSession < [[objTrackerModel  trackerSetion] intValue] ){
                trackerSession = [[objTrackerModel  trackerSetion] intValue];
                _mostUsedTrackerLebal.text = objTrackerModel.trackerName;
            }
        }
           
        //Category 
            if (ctgboolValue) {
            if ([[objTrackerModel trackerCategory] isEqualToString:categoryIdentifier]) {
                _mostUsedTrackerCtgLabel.text = objTrackerModel.trackerName;
                mostTracker =  [[objTrackerModel  trackerSetion] intValue];
                
              }
                ctgboolValue = NO;
            }else if (([[objTrackerModel trackerCategory] isEqualToString:categoryIdentifier]) && (mostTracker <[[objTrackerModel  trackerSetion] intValue])){
                _mostUsedTrackerCtgLabel.text = objTrackerModel.trackerName;
                mostTracker =  [[objTrackerModel  trackerSetion] intValue];
            }
         TotalTimeCounter = [[objTrackerModel  trackerSetion] intValue] + TotalTimeCounter;
    }
    
    //Set containt size of scrollview 
    if ([recentActivityArr count]>0) {
        int width = 570 + 75*[recentActivityArr count];
         _myLifeScrollView.contentSize = CGSizeMake(320,width);
    }else{
        _myLifeScrollView.contentSize = CGSizeMake(320, 570);
    }
        
   
    
    _tolalTimeLabel.text = [CommonUtilClass convetIntoTimeFormatSecond:TotalTimeCounter];
     _totalTrackersLabel.text = [NSString stringWithFormat:@"%d",[_myLifeInfoArray count]];
    
    [_myLifeTableView reloadData];
    [_categoryNamePickerView reloadAllComponents];
}



#pragma mark - UIViewController lifecycle methods
-(void)viewDidAppear:(BOOL)animated {
       
}

#pragma mark - Chart behavior
-(void)initPlot {
    [self configureGraph];
    [self configureChart];
    [self configureLegend];
}

-(void)configureHost {
	// 1 - Set up view frame
//	CGRect parentRect = self.view.bounds;
//	//CGSize toolbarSize = self.toolbar.bounds.size;
//	parentRect = CGRectMake(0,0,320,250);
//	// 2 - Create host view
//    self.hostView = nil;
//	self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:parentRect];
//	self.hostView.allowPinchScaling = NO;
//    
//	[_myLifeScrollView addSubview:self.hostView];    
}




// Set bachground of CPTGraphHostingView
-(void)configureGraph {
	// 1 - Create and initialise graph
	CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
	self.hostView.hostedGraph = graph;
	graph.paddingLeft = 0.0f;
	graph.paddingTop = 0.0f;
	graph.paddingRight = 0.0f;
	graph.paddingBottom = 0.0f;
	graph.axisSet = nil;
	// 2 - Set up text style
	CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
	textStyle.color = [CPTColor grayColor];
	textStyle.fontName = @"Helvetica-Bold";
	textStyle.fontSize = 1.0f;
	// 3 - Configure title
	NSString *title = @"Portfolio Prices: May 1, 2012";
	graph.title = title;    
	graph.titleTextStyle = textStyle;
	graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;    
	graph.titleDisplacement = CGPointMake(0.0f, 1.0f);         
	// 4 - Set theme
	self.selectedTheme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];    
	//[graph applyTheme:self.selectedTheme]; 
}


-(void)configureChart {    
	// 1 - Get reference to graph
	CPTGraph *graph = self.hostView.hostedGraph;    
	// 2 - Create chart
	CPTPieChart *pieChart = [[CPTPieChart alloc] init];
	pieChart.dataSource = self;
	pieChart.delegate = self;
	pieChart.pieRadius = 78;
    
    pieChart.centerAnchor = CGPointMake(0.27, 0.5);
	//pieChart.identifier = graph.title;
	pieChart.startAngle = M_PI_4;
	pieChart.sliceDirection = CPTPieDirectionClockwise;    
	// 3 - Create gradient
	CPTGradient *overlayGradient = [[CPTGradient alloc] init];
	overlayGradient.gradientType = CPTGradientTypeRadial;
	overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
	overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
	pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
	// 4 - Add chart to graph    
	[graph addPlot:pieChart];  
}

// Write the name as  Category and  background 
-(void)configureLegend {    
	// 1 - Get graph instance
    CPTGraph *graph = nil;
	graph = self.hostView.hostedGraph;
	// 2 - Create legend
    CPTLegend *theLegend = nil;
    theLegend = [CPTLegend legendWithGraph:graph];
	// 3 - Configure legen
	theLegend.numberOfColumns = 1;
	theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
	theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    //Set Category (table radius)
	theLegend.cornerRadius = 10.0;
	// 4 - Add legend to graph
	graph.legend = theLegend;     
	graph.legendAnchor = CPTRectAnchorRight;
    //Set Category frame (table x,y co-ordinte)
	CGFloat legendPadding = -(self.view.bounds.size.width / 25);
	graph.legendDisplacement = CGPointMake(legendPadding, 0.0);       
}

#pragma mark - CPTPlotDataSource methods
//circle divide in , How many parts  
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
	return [[[CustomGraph sharedInstance] categoryName] count];
    //return 1;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
	if (CPTPieChartFieldSliceWidth == fieldEnum) {
		return  [[[CustomGraph sharedInstance] categoryHourPortfolioPrices] objectAtIndex:index];
	}
	return [NSDecimalNumber zero];
}


// Give the name as  AAPL ,GOOG ,MSFT
-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    
	if (index < [[[CustomGraph sharedInstance] categoryName] count]) {
		return [[[CustomGraph sharedInstance] categoryName] objectAtIndex:index];
	}
	return @"N/A";
}









//-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
//	// 1 - Define label text style
//	static CPTMutableTextStyle *labelText = nil;
//	if (!labelText) {
//		labelText= [[CPTMutableTextStyle alloc] init];
//		labelText.color = [CPTColor whiteColor];
//	}
//	// 2 - Calculate portfolio total value
//	NSDecimalNumber *portfolioSum = [NSDecimalNumber zero];
//	for (NSDecimalNumber *price in [[CustomGraph sharedInstance] categoryHourPortfolioPrices]) {
//		portfolioSum = [portfolioSum decimalNumberByAdding:price];
//	}
//	// 3 - Calculate percentage value
//  
//    NSDecimalNumber *price;    
//    NSDecimalNumber *percent;
//  @try {
//	price = [[[CustomGraph sharedInstance] categoryHourPortfolioPrices] objectAtIndex:index];
//	percent = [price decimalNumberByDividingBy:portfolioSum];
//  }@catch (NSException *exception) {
//      
//  }
//	// 4 - Set up display label
//	NSString *labelValue = [NSString stringWithFormat:@"$%0.f(%0.f %%)", [price floatValue], ([percent floatValue] * 100.0f)];
//   
//    //
//    NSString *percantage;
//    @try
//    {
//    NSArray  *array = [labelValue componentsSeparatedByString:@"("];
//     NSString *percantage1 = [array objectAtIndex:1];
//    NSArray  *array1 = [percantage1 componentsSeparatedByString:@")"]; 
//      percantage = [array1 objectAtIndex:0];  
//    }@catch (NSException *exception) {
//        //if(LOGS_ON) NSLog(@"MyLife :  persantage :-> %@", labelValue);
//    }
//	// 5 - Create and return layer with label text
//	return [[CPTTextLayer alloc] initWithText:percantage style:labelText];
//}




#pragma mark :->
#pragma mark Tableview Datasource mathod .
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [recentActivityArr count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MyCellIdentifier";
    // Attempt to request the reusable cell.
    MyLifeCustomCell *cell = (MyLifeCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // No cell available - create one.
    if(cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyLifeCustomCell" owner:nil options:nil];
        
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    TrackerSessionModel *obj= [recentActivityArr objectAtIndex:indexPath.row];
    
    [[cell trackerNameLbl] setText:obj.trackerName];
    [[cell startTimeLbl] setText:obj.trackerStartTime];
    [[cell endTimeLbl]    setText:obj.trackerEndTime];
    [[cell durationLbl] setText: [CommonUtilClass convetIntoTimeFormatSecond:[obj.trackerSesion intValue]]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}


#pragma mark - PickerView method
/*
 @Description:Numer of components in pickerview
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

/*
 @Description:Numer of row in component 
 */
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return   [_categoryArray count];
    //return [arrayColors count];
}

/*
 @Description:Display data on pickerview
 */
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    CategoryInfoModel *objCategoryModel= [_categoryArray objectAtIndex:row];
        return [objCategoryModel trackerCategory] ;    
}

/*
 @Description:Select row of component 
 */
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    BOOL boolValue = YES;
    BOOL ctgboolValue = YES;
    NSString *categoryIdentifier;
    long mostTracker = 0;
    for (TrackerDetailModel *objTrackerModel in _myLifeInfoArray) {
        NSLog(@"MY Life : did select pickerview : category -> %@ ",objTrackerModel.trackerCategory);
        NSLog(@"MY Life : did select pickerview : TrackerName -> %@ ",objTrackerModel.trackerName);

    }
    
    for (TrackerDetailModel *objTrackerModel in _myLifeInfoArray) {
        if (boolValue) {
            //NSLog(@"MY Life : did select pickerview : category -> %@ ",objTrackerModel.trackerCategory);
            //NSLog(@"MY Life : did select pickerview : TrackerName -> %@ ",objTrackerModel.trackerName);
            //NSLog(@"MY Life : did select pickerview : _mostUsedTrackerCtgLabel -> %@ ",objTrackerModel.trackerName);
                CategoryInfoModel *objCategoryModel = [_categoryArray objectAtIndex:row];
                categoryIdentifier = [objCategoryModel trackerCategory];
                _totalTrackerCtgLabel.text  = [objCategoryModel trackercount];
                _tolalTimeCtgLabel.text     = [CommonUtilClass convetIntoTimeFormatSecond:[[objCategoryModel  totalTime] intValue]];
                _categoryNameLabel.text  = [objCategoryModel trackerCategory];
                // Most use tracker name.
                _mostUsedTrackerCtgLabel.text = objCategoryModel.trackerName;
            boolValue = NO;
        } 
            if (ctgboolValue) {
                if ([[objTrackerModel trackerCategory] isEqualToString:categoryIdentifier]) {
                    _mostUsedTrackerCtgLabel.text = objTrackerModel.trackerName;
                    mostTracker =  [[objTrackerModel  trackerSetion] intValue];
                    
                }
                ctgboolValue = NO;
            }else if (([[objTrackerModel trackerCategory] isEqualToString:categoryIdentifier]) && (mostTracker <[[objTrackerModel  trackerSetion] intValue])){
                _mostUsedTrackerCtgLabel.text = objTrackerModel.trackerName;
                mostTracker =  [[objTrackerModel  trackerSetion] intValue];
            }
    }

//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration :1]; 
//    _categoryNamePickerView.frame = CGRectMake(0, 500, 320, 216);
//    pickerClossView.frame     = CGRectMake(0, 500, 320, 400);
//    [UIView commitAnimations];
}


#pragma mark
-(IBAction)selectCategoryName:(id)sender{
    
    [_myLifeScrollView setContentOffset:CGPointMake(0,160) animated:YES];
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration : 1]; 
//     pickerClossView.frame        = CGRectMake(0, 200, 320, 400);
//    _categoryNamePickerView.frame = CGRectMake(0, 40, 320, 216);
//    [UIView commitAnimations];
    [self.view addSubview:pickerClossView];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration : 1]; 
    pickerClossView.frame = CGRectMake(0, 200, 320, 216);
    
    _categoryNamePickerView.frame     = CGRectMake(0, 40, 320, 216);  
    [UIView commitAnimations];
    
}



-(IBAction) closePickerView:(id)sender{
    
    [_myLifeScrollView setContentOffset:CGPointMake(0,130) animated:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration : 1]; 
      pickerClossView.frame     = CGRectMake(0, 500, 320, 400);
    _categoryNamePickerView.frame = CGRectMake(0, 500, 320, 216);
    [UIView commitAnimations];
    
}



@end
