//
//  BarChartTracker.h
//  iLifeTracker
//
//  Created by Umesh on 28/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphModel.h"
#import "CommonUtilClass.h"
#import "TimeDividerModel.h"

@interface BarChartTracker : NSObject {
    //NSArray *dates;
    
    NSMutableArray      *trackerBarchatArray; 
    NSString            *bartrackerName;
    
   // NSMutableArray      *barcounterArray;
   // NSMutableArray      *barPonitArray;
    BOOL           barHourIdentifier; 
    
    BOOL           monthIndentifier;
}

//@property (nonatomic, retain) NSArray *dates;
+ (BarChartTracker *)sharedInstance;

//- (NSArray *)tickerSymbols;

//- (NSArray *)dailyPortfolioPrices;
@property (nonatomic , retain) NSMutableArray  *trackerBarchatArray; 
@property (nonatomic , retain) NSString        *bartrackerName;

@property (nonatomic ) BOOL           barHourIdentifier;

@property (nonatomic )  BOOL           monthIndentifier;
//@property (nonatomic , retain)  NSMutableArray *barcounterArray;
//@property (nonatomic , retain)  NSMutableArray *barPonitArray;

- (NSArray *)datesInWeek;
- (NSArray *)weeklyPrices:(NSString *)tickerSymbol;

//- (NSArray *)datesInMonth;
//- (NSArray *)monthlyPrices:(NSString *)tickerSymbol;

//- (NSArray *)weeklyAaplPrices;


@end
