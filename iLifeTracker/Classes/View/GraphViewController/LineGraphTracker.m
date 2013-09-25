//
//  LineGraphTracker.m
//  iLifeTracker
//
//  Created by Umesh on 28/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "LineGraphTracker.h"

@implementation LineGraphTracker
@synthesize  trackerTimeArray,trackerName , hourIdentifier;


+ (LineGraphTracker *)sharedInstance
{
    static LineGraphTracker *sharedInstance;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];      
    });
    
    return sharedInstance;
}

#pragma mark - API methods



- (NSArray *)datesInMonth
{
   NSMutableArray *dates = nil;
    NSMutableArray *dayArray =[CommonUtilClass breakTime:trackerTimeArray trackerName:trackerName];
  // NSMutableArray *dayArray1 = [CommonUtilClass breakTime:trackerTimeArray trackerName:trackerName];
    dates = nil;
   
    if (!dates){
        dates = [[NSMutableArray  alloc]  init];
        [dates addObject:[ NSString stringWithFormat:@"0"]];
        int counter = 1;
    for (int i = 0; i < [dayArray count]; i++ ) {
      
        TimeDividerModel * obj = [dayArray objectAtIndex:i];
        // NSLog(@"Line Graph Travker in session :-> %i",[[obj trackerSesion] intValue]);
        if([trackerName isEqualToString:obj.trackerName] ){
            NSArray   *totalTimeArr;
            NSString  *hours1 ;
            NSString  *minute ;
            //NSString  *second ;
            //int  runningtolalTime = 0; 
            @try{
                NSArray   *totalTimeArr1 = [obj.date componentsSeparatedByString:@" "];
                
                NSString *str = [totalTimeArr1 objectAtIndex:2];
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                NSDate *anyDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@",str] ];
                NSString  *backgroundTime12 = [dateFormat stringFromDate:anyDate];
                //NSLog(@" date of bar chart creation :-> %@",backgroundTime12);
                
                totalTimeArr = [backgroundTime12 componentsSeparatedByString:@"-"]; 
                hours1 = [totalTimeArr objectAtIndex:1];
                minute = [totalTimeArr objectAtIndex:2];
                //second = [totalTimeArr objectAtIndex:2];
                //  NSLog(@" Time :-> %@ hours :-> %i minute :-> %i  seconds :-> %i",str,[hours1 intValue],  [minute intValue],[second intValue]);
            }@catch (NSException *exception) {
                
            }
            
            [dates addObject:[ NSString stringWithFormat:@"%@/%@",minute,hours1]]; 
            
            
        //[dates addObject:[ NSString stringWithFormat:@"%i",counter]];
            counter = counter +1;
         
        }
    }
    }
    
    return dates;
}

//-(NSArray *) datesInMonthAAPL{
//    static NSArray *date = nil;
//    if (!date)
//    {
//        date = [NSArray arrayWithObjects:
//                 @"2", 
//                 @"3", 
//                 @"4",
//                 @"5",
//                 @"9", 
//                 @"10", 
//                 @"11",
//                 @"12", 
//                 @"13",
//                 @"16", 
//                 @"17", 
//                 @"18",
//                 @"19", 
//                 @"20", 
//                 @"23", 
//                 @"24", 
//                 @"25",
//                 @"26", 
//                 @"27",
//                 @"30",                   
//                 nil];
//    }
//    return date;
//
//}

// Bar chart

- (NSArray *)monthlyPrices:(NSString *)tickerSymbol
{
    if ([@"AAPL" isEqualToString:[tickerSymbol uppercaseString]] == YES)
    { 
        NSArray *arrAPPLE = nil;
        if (!arrAPPLE)
        {
            arrAPPLE = [NSArray arrayWithObjects:
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00],
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00],
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00],
                      [NSDecimalNumber numberWithFloat:5.08],                  
                      nil];
        }
        return arrAPPLE;
        // return [self monthlyAaplPrices];
    }
    else if ([@"GOOG" isEqualToString:[tickerSymbol uppercaseString]] == YES)
    {  
       NSArray *arrayGOOG = nil;
        if (!arrayGOOG)
        {
            arrayGOOG = [NSArray arrayWithObjects:
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.06], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.07], 
                      [NSDecimalNumber numberWithFloat:5.00], 
                      [NSDecimalNumber numberWithFloat:5.00],                  
                      nil];
        }
        return arrayGOOG;
        //return [self monthlyGoogPrices];
    }
    else if ([@"MSFT" isEqualToString:[tickerSymbol uppercaseString]] == YES)
    {  NSMutableArray *arrayMSFT = nil;
        // NSLog(@"  session  value  ******************* :-> %@", trackerName );
       // int i = 90;
        if (!arrayMSFT)
        {
            arrayMSFT = [[NSMutableArray  alloc] init];
            
            NSMutableArray *dayArray = [CommonUtilClass breakTime:trackerTimeArray trackerName:trackerName];
            
            [arrayMSFT addObject:[NSDecimalNumber numberWithInt:0.0]];
            
            for (int i = 0; i < [dayArray count]; i++ ) {
                
                 TimeDividerModel * obj = [dayArray objectAtIndex:i];
                if([trackerName isEqualToString:obj.trackerName]){
                    float session = [obj.trackerSesion intValue];
                    float minute ;
                    //NSLog(@"******************** :->  %f",session );
                    if (hourIdentifier) {
                        //convert in Hours.
                         minute   = session / 3600;
                    
                    //NSLog(@"******************** :->  %f",minute );
                    }else{
                        //convert in minutes .
                         minute   = session / 60;  
                         //NSLog(@"******************** :->  %f",minute );
                    }
                    
                [arrayMSFT addObject:[NSDecimalNumber numberWithFloat:minute]];
                }
            } 
            
        }
        return arrayMSFT;
        //return [self monthlyMsftPrices];
    }
    //NSLog(@"******************** ******************* ********************** :-> %i",hourIdentifier);
    return [NSArray array];
}

@end
