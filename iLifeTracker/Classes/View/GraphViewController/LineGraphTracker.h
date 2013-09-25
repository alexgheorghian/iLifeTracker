//
//  LineGraphTracker.h
//  iLifeTracker
//
//  Created by Umesh on 28/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphModel.h"
#import "CommonUtilClass.h"

#import "TimeDividerModel.h"
@interface LineGraphTracker : NSObject{
//    NSMutableArray *dates;
//    NSMutableArray *arrAPPLE;
//    NSMutableArray *arrayGOOG;
//    NSMutableArray *arrayMSFT;
    
    NSMutableArray *trackerTimeArray;
    NSString       *trackerName;
    BOOL           hourIdentifier; 
}


@property (nonatomic, retain) NSMutableArray *trackerTimeArray;
@property (nonatomic, retain) NSString       *trackerName;
@property (nonatomic) BOOL          hourIdentifier; 

+ (LineGraphTracker *)sharedInstance;


- (NSArray *)datesInMonth;
- (NSArray *)monthlyPrices:(NSString *)tickerSymbol;

//-(NSArray *) datesInMonthAAPL;
@end
