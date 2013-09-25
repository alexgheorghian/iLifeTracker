//
//  LineGraph.m
//  iLifeTracker
//
//  Created by Umesh on 28/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "LineGraph.h"

#define GRAPHSMSMINUTE @"Tracker Time(in minutes)"
#define GRAPHSMSHOURS @"Tracker Time(in hours)"

#define PortraitMSM @"For more details, turn your phone in landscape mode"
@implementation LineGraph

@synthesize hostView = hostView_,minuteAndHourIdentify;

@synthesize rotaionIdentify;
static bool boolValue = YES;
//@synthesize portraitView, landscapeView;




//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
//{
//    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)){
//        frame = CGRectMake(0,100, 320, 300);
//    }else{
//        
//    }
//    
//    return YES;
//
//}




#pragma mark - Chart behavior
-(void)initPlot {
    //[self configureHost];
    if(boolValue){
        self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] init];
    }
    
   // [self configureGraph];
   // [self configurePlots];
    //[self configureAxes];    
    boolValue = NO;
}


-(void)configureHost:(id) obj frameSize:(CGRect) frame{  
    
  //if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
	//self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:frame];
  //}else{
   //   self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:CGRectMake(0,100, 600, 200)];
  //}
    [self initPlot];
    self.hostView.frame = frame;

	self.hostView.allowPinchScaling = YES;  
    UIView *view = obj;
    [view addSubview:self.hostView]; 
    
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];    
    
	//[obj.portraitView addSubview:self.hostView];   
    //return hostView ;
}

-(void)configureGraph {
	// 1 - Create the graph
	CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
	[graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
	self.hostView.hostedGraph = graph;
	// 2 - Set graph title
	NSString *title ;//= @"iLifeTracker all Day (Line Graph)";
    if (!rotaionIdentify) {
        
    if (!minuteAndHourIdentify) {
       title = GRAPHSMSHOURS;
    }else{
       title = GRAPHSMSMINUTE;
    }
    }else{
       // title =  PortraitMSM;
    }
        
    
    
	graph.title = title;  
	// 3 - Create and set text style
	CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
	titleStyle.color = [CPTColor whiteColor];
	titleStyle.fontName = @"Helvetica-Bold";
	titleStyle.fontSize = 16.0f;
	graph.titleTextStyle = titleStyle;
	graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
	graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
	// 4 - Set padding for plot area
	[graph.plotAreaFrame setPaddingLeft:30.0f];    
	[graph.plotAreaFrame setPaddingBottom:30.0f];
	// 5 - Enable user interactions for plot space
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
	plotSpace.allowsUserInteraction = NO; 
}

-(void)configurePlots { 
	// 1 - Get graph and plot space
	CPTGraph *graph = self.hostView.hostedGraph;
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
	// 2 - Create the three plots
	CPTScatterPlot *aaplPlot = [[CPTScatterPlot alloc] init];
	aaplPlot.dataSource = self;
	aaplPlot.identifier = @"AAPL";
	CPTColor *aaplColor = [CPTColor clearColor];
	[graph addPlot:aaplPlot toPlotSpace:plotSpace];    
	CPTScatterPlot *googPlot = [[CPTScatterPlot alloc] init];
	googPlot.dataSource = self;
	googPlot.identifier = @"GOOG";
	CPTColor *googColor = [CPTColor clearColor];
	[graph addPlot:googPlot toPlotSpace:plotSpace];    
	CPTScatterPlot *msftPlot = [[CPTScatterPlot alloc] init];
	msftPlot.dataSource = self;
	msftPlot.identifier = @"MSFT";
	CPTColor *msftColor = [CPTColor redColor];
	[graph addPlot:msftPlot toPlotSpace:plotSpace];  
	// 3 - Set up plot space
	[plotSpace scaleToFitPlots:[NSArray arrayWithObjects:aaplPlot, googPlot, msftPlot, nil]];
    	CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    	[xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];        
    	plotSpace.xRange = xRange;
    	CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    	[yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];        
    	plotSpace.yRange = yRange;  
    
	// 4 - Create styles and symbols
	CPTMutableLineStyle *aaplLineStyle = [aaplPlot.dataLineStyle mutableCopy];
	aaplLineStyle.lineWidth = 2.5;
	aaplLineStyle.lineColor = aaplColor;
	aaplPlot.dataLineStyle = aaplLineStyle;
	CPTMutableLineStyle *aaplSymbolLineStyle = [CPTMutableLineStyle lineStyle];
	aaplSymbolLineStyle.lineColor = aaplColor;
	CPTPlotSymbol *aaplSymbol = [CPTPlotSymbol ellipsePlotSymbol];
	aaplSymbol.fill = [CPTFill fillWithColor:aaplColor];
	aaplSymbol.lineStyle = aaplSymbolLineStyle;
	aaplSymbol.size = CGSizeMake(6.0f, 6.0f);
	aaplPlot.plotSymbol = aaplSymbol;   
	CPTMutableLineStyle *googLineStyle = [googPlot.dataLineStyle mutableCopy];
	googLineStyle.lineWidth = 1.0;
	googLineStyle.lineColor = googColor;
	googPlot.dataLineStyle = googLineStyle;
	CPTMutableLineStyle *googSymbolLineStyle = [CPTMutableLineStyle lineStyle];
	googSymbolLineStyle.lineColor = googColor;
	CPTPlotSymbol *googSymbol = [CPTPlotSymbol starPlotSymbol];
	googSymbol.fill = [CPTFill fillWithColor:googColor];
	googSymbol.lineStyle = googSymbolLineStyle;
	googSymbol.size = CGSizeMake(6.0f, 6.0f);
	googPlot.plotSymbol = googSymbol;       
	CPTMutableLineStyle *msftLineStyle = [msftPlot.dataLineStyle mutableCopy];
	msftLineStyle.lineWidth = 2.0;
	msftLineStyle.lineColor = msftColor;
	msftPlot.dataLineStyle = msftLineStyle;  
	CPTMutableLineStyle *msftSymbolLineStyle = [CPTMutableLineStyle lineStyle];
	msftSymbolLineStyle.lineColor = msftColor;
	CPTPlotSymbol *msftSymbol = [CPTPlotSymbol diamondPlotSymbol];
	msftSymbol.fill = [CPTFill fillWithColor:msftColor];
	msftSymbol.lineStyle = msftSymbolLineStyle;
	msftSymbol.size = CGSizeMake(6.0f, 6.0f);
	msftPlot.plotSymbol = msftSymbol;      
}

-(void)configureAxes {
	// 1 - Create styles
	CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
	axisTitleStyle.color = [CPTColor whiteColor];
	axisTitleStyle.fontName = @"Helvetica-Bold";
	axisTitleStyle.fontSize = 12.0f;
	CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
	axisLineStyle.lineWidth = 2.0f;
	axisLineStyle.lineColor = [CPTColor whiteColor];
	CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
	axisTextStyle.color = [CPTColor whiteColor];
	axisTextStyle.fontName = @"Helvetica-Bold"; 
    if (rotaionIdentify) {
        axisTextStyle.fontSize = 10.0f;
    }else{
	axisTextStyle.fontSize = 8.0f;
    }
    
	CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
	tickLineStyle.lineColor = [CPTColor whiteColor];
	tickLineStyle.lineWidth = 2.0f;
	CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
	tickLineStyle.lineColor = [CPTColor blackColor];
	tickLineStyle.lineWidth = 1.0f;       
	// 2 - Get axis set
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
	// 3 - Configure x-axis
	CPTAxis *x = axisSet.xAxis;
    //x.coordinate = CPDecimalFromString(@"0.5");
    x.minorTicksPerInterval = 2;
	//x.title = @"Day"; 
	//x.titleTextStyle = axisTitleStyle;    
	//x.titleOffset = 15.0f;
	x.axisLineStyle = axisLineStyle;
	x.labelingPolicy = CPTAxisLabelingPolicyNone;
	x.labelTextStyle = axisTextStyle;    
	x.majorTickLineStyle = axisLineStyle;
	x.majorTickLength = 4.0f;
	x.tickDirection = CPTSignNegative;
	CGFloat dateCount = [[[LineGraphTracker sharedInstance] datesInMonth] count];
	NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
	NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount]; 
	NSInteger i = 0;
	for (NSString *date in [[LineGraphTracker sharedInstance] datesInMonth]) {
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
	NSInteger majorIncrement = 5;
    NSInteger minorIncrement = 1;    
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



#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {

	return [[[LineGraphTracker sharedInstance] datesInMonth] count];
    
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
	NSInteger valueCount = [[[LineGraphTracker sharedInstance] datesInMonth] count];
	switch (fieldEnum) {
		case CPTScatterPlotFieldX:
			if (index < valueCount) {
				return [NSNumber numberWithUnsignedInteger:index];
			}
			break;
			
		case CPTScatterPlotFieldY:
			if ([plot.identifier isEqual:@"AAPL"] == YES) {
				return [[[LineGraphTracker sharedInstance] monthlyPrices:@"AAPL"] objectAtIndex:index];
			} else if ([plot.identifier isEqual:@"GOOG"] == YES) {
				return [[[LineGraphTracker sharedInstance] monthlyPrices:@"GOOG"] objectAtIndex:index];               
			} else if ([plot.identifier isEqual:@"MSFT"] == YES) {
				return [[[LineGraphTracker sharedInstance] monthlyPrices:@"MSFT"] objectAtIndex:index];               
			}
			break;
	}
	return [NSDecimalNumber zero];
}


@end
