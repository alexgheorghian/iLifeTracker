//
//  CustomGraph.h
//  iLifeTracker
//
//  Created by Umesh on 04/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseController.h"
#import "CategoryInfoModel.h"
@interface CustomGraph : NSObject

+ (CustomGraph *)sharedInstance;

- (NSArray *) categoryName;

- (NSArray *)categoryHourPortfolioPrices;

-(void) categoryTimePieChart;
@end
