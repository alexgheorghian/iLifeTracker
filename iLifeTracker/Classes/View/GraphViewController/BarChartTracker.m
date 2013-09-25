//
//  BarChartTracker.m
//  iLifeTracker
//
//  Created by Umesh on 28/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BarChartTracker.h"

@implementation BarChartTracker
@synthesize trackerBarchatArray , bartrackerName ,barHourIdentifier, monthIndentifier ;

+ (BarChartTracker *)sharedInstance
{
    static BarChartTracker *sharedInstance;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];      
    });
    
    return sharedInstance;
}

#pragma mark - API methods


//Line chart 
- (NSArray *)datesInWeek
{
    NSString *slaceBtwDay;
    int arrayCapacity;
    NSString  *month = @"0" ;
    NSString  *date =@"0";
    
    if (monthIndentifier) {
        slaceBtwDay = @"/";
        arrayCapacity = 30;
    }else{
        slaceBtwDay = @"/";
        arrayCapacity = 7;
    }
    
    NSDate *startDateTime = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM"];
    NSString  *monthDate = [outputFormatter stringFromDate:startDateTime];
    //NSLog(@"newDateString month %@", backgroundTime);
    [outputFormatter setDateFormat:@"dd"];
    NSString  *dayDate = [outputFormatter stringFromDate:startDateTime];
    //NSLog(@"newDateString day %@", monthDate);
    
     NSMutableArray *barcounterArray = nil;
     NSMutableArray *dayArray = [CommonUtilClass breakTime:trackerBarchatArray trackerName:bartrackerName];
    if (!barcounterArray){
        barcounterArray = [[NSMutableArray  alloc]  init];
        for (int i =0 ; i <= arrayCapacity; i++) {
            
        [barcounterArray addObject:[ NSString stringWithFormat:@"0"]];
        }
        int counter = 1;
        for (int i = [dayArray count] -1 ; i >= 0; i-- ) {
            
            TimeDividerModel * obj = [dayArray objectAtIndex:i];
            //NSLog(@"Line Graph Travker in session :-> %@",[obj trackerName]);
            if([bartrackerName isEqualToString:obj.trackerName] ){
                
                NSArray   *totalTimeArr;
              
               // NSString  *second ;
               // int  runningtolalTime = 0; 
                @try{
                    NSArray   *totalTimeArr1 = [obj.date componentsSeparatedByString:@" "];
                    
                    NSString *str = [totalTimeArr1 objectAtIndex:2];
                    
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd"];
                    NSDate *anyDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@",str] ];
                    NSString  *backgroundTime12 = [dateFormat stringFromDate:anyDate];
                    //NSLog(@" date of bar chart creation :-> %@",backgroundTime12);
                    
                    totalTimeArr = [backgroundTime12 componentsSeparatedByString:@"-"]; 
                    month = [totalTimeArr objectAtIndex:1];
                    date = [totalTimeArr objectAtIndex:2];
                    //second = [totalTimeArr objectAtIndex:2];
                    //  NSLog(@" Time :-> %@ hours :-> %i minute :-> %i  seconds :-> %i",str,[hours1 intValue],  [minute intValue],[second intValue]);
                }@catch (NSException *exception) {
                    
                }
                
                //[barcounterArray addObject:[ NSString stringWithFormat:@"%@%@%@",month,slaceBtwDay,date] ];
               [barcounterArray replaceObjectAtIndex:arrayCapacity withObject:[ NSString stringWithFormat:@"%@%@%@",date,slaceBtwDay,month] ];
                arrayCapacity-- ;
               // NSLog(@"traker month : %@ Tracker date : %@",month,date);
               // NSLog(@" date of bar chart creation :-> %@",obj.date);
                
                counter = counter +1;
            }
        }
        int preDate;
        int dateMonth;
        if( [month intValue] != 0){
         preDate = [date intValue] -1; 
         dateMonth = [month intValue];
          //  NSLog(@" moth is 0");
        }else{
            preDate = [dayDate intValue]; 
            dateMonth = [monthDate intValue];
             //NSLog(@"moth is not  0 ");
        }
        // NSLog(@"preDate :-> %i  preDate :-> %i",[date intValue],preDate);
        while ( arrayCapacity >= 0 ) {
            if((preDate > 0) && (arrayCapacity != 0)){
               // NSLog(@"preDate :-> %i",[date intValue]);
                
            [barcounterArray replaceObjectAtIndex:arrayCapacity withObject:[ NSString stringWithFormat:@"%i%@%i",preDate,slaceBtwDay,dateMonth] ];
                // NSLog(@"[barcounterArray count] ###### :-> %i if ",preDate);
                preDate-- ;
            }else if(arrayCapacity == 0){
                [barcounterArray replaceObjectAtIndex:arrayCapacity withObject:@"0"];
            }
            else{
               // if( dateMonth != 0){
                preDate = 30;
                if(dateMonth > 1){
                dateMonth = dateMonth - 1;
            }else{
              dateMonth = 12;  
            }
                 [barcounterArray replaceObjectAtIndex:arrayCapacity withObject:[ NSString stringWithFormat:@"%i%@%i",preDate,slaceBtwDay,dateMonth] ];
                //}else{
                //   [barcounterArray replaceObjectAtIndex:arrayCapacity withObject:[ NSString stringWithFormat:@"%i%@%i",preDate,slaceBtwDay,dateMonth] ]; 
                //}
                preDate-- ;
                
                //NSLog(@"[barcounterArray count] ###### :-> %i else ",preDate);
            }
            
            arrayCapacity--;
        }
    }
    
    if (monthIndentifier) {
        // NSLog(@"*************************monthIndentifier");
        for ( int i =0 ; i< [barcounterArray count] ; i++) {
          
            if (i % 3 != 0){
               [barcounterArray replaceObjectAtIndex:i withObject:@""]; 
                 //NSLog(@"[barcounterArray count] ###### :-> %i ",i);
            }
        }
    }
   // NSLog(@"********************************************************************************* :-> %@",bartrackerName);
    return barcounterArray;
}



- (NSArray *)weeklyPrices:(NSString *)tickerSymbol
{
    if ([@"AAPL" isEqualToString:[tickerSymbol uppercaseString]] == YES)
    {
        
        NSString *slaceBtwDay;
        int arrayCapacity;
        //NSString  *month ;
        //NSString  *date ;
        
        if (monthIndentifier) {
            slaceBtwDay = @"/";
            arrayCapacity = 30;
        }else{
            slaceBtwDay = @"/";
            arrayCapacity = 7;
        }
        
        
          NSMutableArray *dayArray = [CommonUtilClass breakTime:trackerBarchatArray trackerName:bartrackerName];
        NSMutableArray *barcounterArray = nil;
        if (!barcounterArray)
            if (!barcounterArray)
            {
                barcounterArray = [[NSMutableArray  alloc] init];
                for (int i =0 ; i <= arrayCapacity ; i++) {
                    
                     [barcounterArray addObject:[NSDecimalNumber numberWithInt:0.0]];
                }
               
                for (int i = [dayArray count] -1 ; i >= 0; i-- ) {
                    
                    GraphModel * obj = [dayArray objectAtIndex:i];
                    if([bartrackerName isEqualToString:obj.trackerName]){
                        float session = [obj.trackerSesion intValue];
                        float minute;
                        if(barHourIdentifier){
                         session = [obj.trackerSesion intValue];
                         minute   = session / 3600;
                        }else{
                            session = [obj.trackerSesion intValue];
                            minute   = session / 60;
                        }
                        //[barcounterArray replaceObjectAtIndex:arrayCapacity withObject:[NSDecimalNumber numberWithInt:minute]];
                        [barcounterArray replaceObjectAtIndex:arrayCapacity withObject:[NSDecimalNumber numberWithInt:minute]];
                        arrayCapacity--;
                    }
                } 
                
               // int preDate = [date intValue]; 
                while ( arrayCapacity >= 0 ) {
                    //if(preDate > 0){
                       // preDate-- ;
                        [barcounterArray replaceObjectAtIndex:arrayCapacity withObject:[NSDecimalNumber numberWithInt:0]];
                   // }else{
                        //preDate = 30;
                    //    [barcounterArray replaceObjectAtIndex:arrayCapacity withObject:[NSDecimalNumber numberWithInt:0]];
                   // }
                    arrayCapacity--;
                }
                
            }
        return barcounterArray;
        //return [self monthlyMsftPrices];
    
    }

    return [NSArray array];
}


@end
