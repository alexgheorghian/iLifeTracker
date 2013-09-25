//
//  LineGraph.h
//  iLifeTracker
//
//  Created by Umesh on 28/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"
#import "LineGraphTracker.h"

@interface LineGraph : NSObject <CPTPlotDataSource> {
    IBOutlet CPTGraphHostingView *hostView;
    
   // IBOutlet UIView *portraitView;
	//IBOutlet UIView *landscapeView;
  //  CGRect frame;
    bool  minuteAndHourIdentify;
    
    bool rotaionIdentify;
}

@property (nonatomic, strong) IBOutlet CPTGraphHostingView *hostView;
@property (nonatomic)  bool  minuteAndHourIdentify;
@property (nonatomic)  bool rotaionIdentify;
//@property (nonatomic, retain) IBOutlet UIView *portraitView;
//@property (nonatomic, retain) IBOutlet UIView *landscapeView;

-(void)initPlot;

-(void)configureHost:(id) obj frameSize:(CGRect) frame;

-(void)configureGraph;

-(void)configurePlots;

-(void)configureAxes;



@end
