//
//  CustomGraph.m
//  iLifeTracker
//
//  Created by Umesh on 04/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CustomGraph.h"

@implementation CustomGraph


#pragma mark - Class methods

+ (CustomGraph *)sharedInstance
{
    static CustomGraph *sharedInstance;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];      
    });
    
    return sharedInstance;
}

-(void) categoryTimePieChart{
    
}

#pragma mark - API methods

- (NSArray *) categoryName;
{
     static NSMutableArray *symbols ;
    symbols = [NSMutableArray new];
    
    DataBaseController *obj = [DataBaseController DBControllerharedInstance];

    
    
    NSMutableArray *categoryArray ;
    categoryArray = [obj myLifeDetailInfo];
    
    
    
//    for (CategoryInfoModel *objCategoryModel in categoryArray) {
//        [symbols addObject:[objCategoryModel trackerCategory]];
//        
//      // NSLog(@" my categoryName :-> %@",[objCategoryModel trackerCategory] );
//    }
//    //NSLog(@" my categoryName :->");
    
    
    
    static NSArray *symbols1 = nil;
    if (!symbols1)
    {
        symbols1 = [NSArray arrayWithObjects:
                   @"General", 
                    @"Internet",
                  @"Lifestyle", 
                    @"Shopping",
                    @"Sports",
                   @"Travel", 
                    @"Work",
                   nil];
    }
    
    for (int i = 0; i < [symbols1 count]; i++) {
        NSString *categoryName = [symbols1 objectAtIndex:i];
        bool boolValue = YES;
        for (int j = 0; j< [categoryArray count] ; j++) {
            
            CategoryInfoModel *objCategoryModel = [categoryArray objectAtIndex:j];
            if ([categoryName isEqualToString:[objCategoryModel trackerCategory]]) {
//                float peresantage = ([[objCategoryModel totalTime] intValue]*7)/100;
//                NSString *categoryPrtg = [NSString stringWithFormat:@"(%0.f)",peresantage];
//                NSString *categoryName = [categoryPrtg stringByAppendingString:[objCategoryModel trackerCategory]];
//                [symbols addObject:categoryName];
                
                // 2 - Calculate portfolio total value
                NSDecimalNumber *portfolioSum = [NSDecimalNumber zero];
                for (NSDecimalNumber *price in [[CustomGraph sharedInstance] categoryHourPortfolioPrices]) {
                    portfolioSum = [portfolioSum decimalNumberByAdding:price];
                }
                
                NSDecimalNumber *price;    
                NSDecimalNumber *percent;
                @try {
                    price = [[[CustomGraph sharedInstance] categoryHourPortfolioPrices] objectAtIndex:i];
                    percent = [price decimalNumberByDividingBy:portfolioSum];
                }@catch (NSException *exception) {
                    
                }
                // 4 - Set up display label
                NSString *labelValue = [NSString stringWithFormat:@"%0.f  (%0.1f %%) ", [price floatValue], ([percent floatValue] * 100.0f)];
               // NSLog(@" category percentage :-> %@", labelValue);
                //
                NSString *percantage;
                @try
                {
                    NSArray  *array = [labelValue componentsSeparatedByString:@"  "];
                    percantage = [array objectAtIndex:1];
                     //percantage = [percantage1 stringByAppendingString:@") "]; 
                    //percantage = [array1 objectAtIndex:0];  
                }@catch (NSException *exception) {
                    //if(LOGS_ON) NSLog(@"MyLife :  persantage :-> %@", labelValue);
                }

                
                 NSString *categoryName1 = [percantage stringByAppendingString:categoryName];
                [symbols addObject:categoryName1];
                
                boolValue = NO;
            }
            
        }
        if (boolValue) {
            
            NSString *categoryName1 = [@"(0.0 %) " stringByAppendingString:categoryName];
            [symbols addObject:categoryName1];
        }
    }
    
    
    //NSLog(@"");
    
    
   return symbols;
}

- (NSArray *)categoryHourPortfolioPrices
{
    
    static NSMutableArray *symbols = nil;
    symbols = [NSMutableArray new];
    
    DataBaseController *obj = [DataBaseController DBControllerharedInstance];
    
    NSMutableArray *categoryArray = [obj myLifeDetailInfo];
    
    
    
    
    
    static NSArray *symbols1 = nil;
    if (!symbols1)
    {
        symbols1 = [NSArray arrayWithObjects:
                    @"General", 
                    @"Internet",
                    @"Lifestyle", 
                    @"Shopping",
                    @"Sports",
                    @"Travel", 
                    @"Work",
                    nil];
    }
    
    for (int i = 0; i < [symbols1 count]; i++) {
        NSString *categoryName = [symbols1 objectAtIndex:i];
        bool boolValue = YES;
        for (int j = 0; j< [categoryArray count] ; j++) {
            
            CategoryInfoModel *objCategoryModel = [categoryArray objectAtIndex:j];
            if ([categoryName isEqualToString:[objCategoryModel trackerCategory]]) {
        [symbols addObject:[NSDecimalNumber numberWithFloat:[[objCategoryModel totalTime] intValue]]];
         boolValue = NO;  
            }
        }
        if (boolValue) {
            [symbols addObject:[NSDecimalNumber numberWithFloat:00.00]];
        }
    }
    
    
//    for (CategoryInfoModel *objCategoryModel in categoryArray) {
//        
//        [symbols addObject:[NSDecimalNumber numberWithFloat:[[objCategoryModel totalTime] intValue]]];
//        
//       // NSLog(@" my categoryHourPortfolioPrices ");
//    }
    
    
    return symbols;
}

@end
