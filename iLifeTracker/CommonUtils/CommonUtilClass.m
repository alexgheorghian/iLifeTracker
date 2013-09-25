//
//  CommonUtilClass.m
//  iLifeTracker
//
//  Created by Umesh on 26/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommonUtilClass.h"

@implementation CommonUtilClass
@synthesize day ,bannerIsVisible;//,timeArray;


static  CommonUtilClass *_objCommonUtilClass;
+(CommonUtilClass *) CommonUtilSharedInstance {
    
    if (_objCommonUtilClass == nil) {
        _objCommonUtilClass = [[CommonUtilClass alloc] init];
    }
    
    return _objCommonUtilClass;
}

-(void) showAlertView:(NSString *) alertMessage title:(NSString *) title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert addButtonWithTitle:@"Ok"];

    [alert show];    //message.delegate = YES;
}

#pragma Mark:->
#pragma Mark Custom NavigationBar

+(UIButton *) setImage_OnNavigationbarButton : (NSString *) imageName buttonIdentifier:(NSString *)button buttonName:(NSString *) buttonName{
    
    UIImage *normalImage = [UIImage imageNamed:imageName];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (button== NAVIGATIONRIGHTBUTTON) {
        [doneButton setFrame:CGRectMake(2, 5, 61, 30)];
        [doneButton setTitle:buttonName forState:UIControlStateNormal];
        doneButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    }else if(button == NAVIGATIONPLUSTBUTTON){
       [doneButton setFrame:CGRectMake(2, 5, 32, 31)]; 
    }
    else  if (button == NAVIGATIONLEFTBUTTON) {
        [doneButton setFrame:CGRectMake(2, 5, 50, 30)];
        [doneButton setTitle:buttonName forState:UIControlStateNormal];
        doneButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    }
    [doneButton setBackgroundImage:normalImage forState:UIControlStateNormal];
   
    return doneButton;
}



+(UILabel *) navigationTittle:(NSString  *) tittleName{
    UILabel *navigatinTittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 280, 40)];
    navigatinTittleLabel.textColor = [UIColor whiteColor];
    navigatinTittleLabel.text = tittleName;

    navigatinTittleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
    navigatinTittleLabel.backgroundColor =[UIColor clearColor];
    return navigatinTittleLabel;
}


+(NSString *) convetIntoTimeFormatSecond:(long) second{
    
    long trkHour    = 0;
    long trkMinute  = 0;
    
    if (second >= 60) {
        int flag;
        flag = second/60;
        second = second % 60;
        trkMinute = trkMinute + flag;
    }
    
    if (trkMinute >= 60) {
        int flag;
        flag = trkMinute/60;
        trkMinute = trkMinute % 60;
        trkHour   = trkHour + flag;
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d",trkHour,trkMinute,second];
}



//+(NSMutableArray *) manageAllDayTime:(NSMutableArray *) recordArray  trackerName:(NSString *) trackerName{
//    NSArray  *startDateArray;
//    NSArray  *endDateArray;
//    
//    NSArray  *timeArray;
//    //NSArray  *hourArray;
//    // NSArray  *minutesArray;
//    
//    NSMutableArray *timeDeviderArray = nil;
//    timeDeviderArray = [[NSMutableArray alloc] init ];
//    
//    NSString *currentTraker = trackerName;
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
//       // NSLog(@" ******************************************************************** : manageAllDayTime");
//        
//        if([currentTraker isEqualToString:obj.trackerName] ){
//            
//            TimeDividerModel *objTimeDivider = [TimeDividerModel new];
//            startTime = [obj trackerStartTime];
//            endTime   = [obj trackerEndTime];
//            
//           // [self breakTimeAccordingtoDateStartDate:startTime endDate:endTime];
//            
//            startDateArray = [startTime componentsSeparatedByString:@" "];
//            endDateArray   = [endTime componentsSeparatedByString:@" "];
//            
//            NSString *str1 = [startDateArray objectAtIndex:2];
//            NSString *str2 = [endDateArray  objectAtIndex:2];
//            //Time
//            NSString *str3 = [endDateArray  objectAtIndex:1];
//            
//            if ( [str1 isEqualToString:str2]) {
//                
//                objTimeDivider.trackerName = obj.trackerName;
//                long sessionTotal = [obj.trackerSesion intValue] + time;
//                objTimeDivider.trackerSesion = [NSString stringWithFormat:@"%i",sessionTotal];
//                
//                [timeDeviderArray addObject:objTimeDivider];
//                deviderIdentifier = NO;
//            }else{
//                timeArray = [str3 componentsSeparatedByString:@":"];
//                //
//                NSString *hours =  [endDateArray  objectAtIndex:0];
//                NSString *minute = [endDateArray  objectAtIndex:1];
//                
//                long timeCounter = (24*60) - ([hours intValue]*60 + [minute intValue]);
//                
//                if ((timeCounter*60) >= [[obj currentSession] intValue]) {
//                    
//                    objTimeDivider.trackerName = obj.trackerName;
//                    long sessionTotal = [obj.trackerSesion intValue] + time;
//                    objTimeDivider.trackerSesion = [NSString stringWithFormat:@"%i",sessionTotal];
//                    
//                    [timeDeviderArray addObject:objTimeDivider];
//                    deviderIdentifier = NO;
//                }else{
//                    time = [[obj currentSession] intValue] - (timeCounter*60) ;
//                    long CurrentTime    = [[obj trackerSesion] intValue] - time;
//                    objTimeDivider.trackerName = obj.trackerName;
//                    objTimeDivider.trackerSesion = [NSString stringWithFormat:@"%i",CurrentTime];
//                    
//                    [timeDeviderArray addObject:objTimeDivider];
//                    
//                    deviderIdentifier = YES;
//                    //[obj trackerSesion] = [NSString stringWithFormat:@"%i",time]; 
//                    //[[obj trackerSesion] intValue] - time;   
//                }
//            }
//        }
//        
//    }
//    
//    if (deviderIdentifier) {
//        TimeDividerModel *objTimeDivider = [TimeDividerModel new];
//        objTimeDivider.trackerName = trackerName;
//        objTimeDivider.trackerSesion = [NSString stringWithFormat:@"%i",time];
//    }
//   // NSLog(@" ******************************************************************** ");
//    return timeDeviderArray;  
//    
//   
//}




+(NSMutableArray *) breakTime:(NSMutableArray *) recordArray  trackerName:(NSString *) trackerName{
    
    NSMutableArray *timeDeviderArray = nil;
    timeDeviderArray = [[NSMutableArray alloc]  init ];
    
    NSString *currentTraker = trackerName;
    
    bool dateBreakValues = NO;
    
    long breakTime = 0;
    
    long partTime = 0;
    
    bool breakBool = NO;
    NSString *trackerEndDate;
    //int i =1 ;
     for (GraphModel *obj in  recordArray) {
         
         if([currentTraker isEqualToString:obj.trackerName] ){
            // NSLog(@" counter :-> %i",i);
             //i++;
             TimeDividerModel *objTimeDivider = [TimeDividerModel new];
             
            //NSString  *startDateStr = [obj trackerStartTime];
           // NSString  *lastDateStr   = [obj trackerEndTime];
             trackerEndDate = [obj trackerEndTime];
             NSArray *strtarray ; 
             NSString *strttime ;
             NSString *strtamPm ;
             NSString *strtdate ;
             NSDate *startDate;
             
             NSArray *endarray1; 
             NSString *enddate1;
             NSDate *endDate;
            breakBool = NO;
             @try {
    NSString *startDateStr = [obj trackerStartTime];
             
             strtarray = [startDateStr componentsSeparatedByString:@" "]; 
              strttime = [strtarray objectAtIndex:0];
              strtamPm = [strtarray objectAtIndex:1];
              strtdate = [strtarray objectAtIndex:2];
             
             NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
             [dateFormat setDateFormat:@"yyyy-MM-dd"];
             startDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@",strtdate] ];    
             
             
             
    NSString *lastDateStr = [obj trackerEndTime];
    
             endarray1 = [lastDateStr componentsSeparatedByString:@" "]; 
            // NSString *time1 = [array1 objectAtIndex:0];
             //NSString *amPm1 = [array1 objectAtIndex:1];
             enddate1 = [endarray1 objectAtIndex:2];
             
             NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
             [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
             endDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@",enddate1] ]; 
             }@catch (NSException *exception) {
                 
             }
             
        
    
    
    NSComparisonResult result = [startDate compare:endDate];
    
       switch (result)
    
        {
        case NSOrderedAscending: dateBreakValues = YES; // NSLog(@"endDate %@ is greater than %@", endDate, startDate); 
                break;
            
        case NSOrderedDescending: //NSLog(@"endDate %@ is less %@", endDate, startDate);
                break;
            
        case NSOrderedSame: dateBreakValues = NO; // NSLog(@"endDate %@ is equal to %@", endDate, startDate);
                break;
            
        default: //NSLog(@"erorr dates %@, %@", endDate, startDate);
                break;
         }
             if (dateBreakValues) {
                 //NSLog(@"endDate %@ is greater than %@", endDate, startDate);
                // NSLog(@" session %@", obj.trackerSesion);
                
                 
                 @try {
                     NSArray *array = [strttime componentsSeparatedByString:@":"]; 
                     NSString *hour = [array objectAtIndex:0];
                     NSString *minute = [array objectAtIndex:1];
                     NSString *second = [array objectAtIndex:2];
                     
                     if ([strtamPm isEqualToString:@"PM"]) {
                        
                         if([hour intValue]< 12){
                             breakTime = 12*3600 -[hour intValue]*3600 -[minute intValue]*60 -[second intValue];
                              //NSLog(@"less from 12 %@", hour);
                         }else{
                              breakTime = 24*3600 -[hour intValue]*3600 -[minute intValue]*60 -[second intValue];
                           // NSLog(@"big from 12 :->  %ld ", breakTime);
                         }
                         
                    
                     }else{
                           breakTime = 24*360 -[hour intValue]*360 -[minute intValue]*60 -[second intValue];
                     }
                    //startDate = 
                   //  NSLog(@" session %ld", breakTime);
                     
                 }
                 @catch (NSException *exception) {
                     
                 }
                 
                 if ([obj.trackerSesion intValue] > breakTime) {
                     
                     breakBool = YES;
                     int currTime = [obj.trackerSesion intValue] - breakTime;
                     objTimeDivider.trackerName = obj.trackerName;
                     long sessionTotal = [obj.trackerSesion intValue] - currTime + partTime;
                     partTime = currTime ;
                     objTimeDivider.trackerSesion = [NSString stringWithFormat:@"%i",sessionTotal];
                     //
                     objTimeDivider.date = obj.trackerStartTime;
                    // NSLog(@" time break in tow part :-> %ld ", partTime);
                     
                     [timeDeviderArray addObject:objTimeDivider];
                 } else{
                     
                     objTimeDivider.trackerName = obj.trackerName;
                     long sessionTotal = [obj.trackerSesion intValue] + partTime;
                     objTimeDivider.trackerSesion = [NSString stringWithFormat:@"%i",sessionTotal];
                     //
                      objTimeDivider.date = obj.trackerStartTime;
                     
                     [timeDeviderArray addObject:objTimeDivider];  
                     partTime = 0;
                     
                   //  NSLog(@" time not break  :-> %ld ", partTime);
                 }
                
                 
             }else{
                 objTimeDivider.trackerName = obj.trackerName;
                 long sessionTotal = [obj.trackerSesion intValue] + partTime;
                 objTimeDivider.trackerSesion = [NSString stringWithFormat:@"%i",sessionTotal];
                 objTimeDivider.date = obj.trackerEndTime;
                 [timeDeviderArray addObject:objTimeDivider];   
                 
                  
               //   NSLog(@" time according to one day :-> %ld",partTime);
                 partTime = 0;
             }
     }
         
         

}
    
    
    if (breakBool) {
         TimeDividerModel *objTimeDivider = [TimeDividerModel new];
        objTimeDivider.trackerName = currentTraker;
        long sessionTotal =  partTime;
        objTimeDivider.trackerSesion = [NSString stringWithFormat:@"%i",sessionTotal];
        objTimeDivider.date  = trackerEndDate;
        [timeDeviderArray addObject:objTimeDivider];   
       // NSLog(@" time  other day dai is nil :-> %ld",partTime);
        partTime = 0;
    }
    
   // NSLog(@" ******************************************************************** %i",[timeDeviderArray count]);
    
    return timeDeviderArray;
}





- (ADBannerView *)iADView {
    static ADBannerView *adView;
    
    if(!adView){
        if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
           
            adView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        } else {
            adView = [[ADBannerView alloc] init];
        }
        NSLog(@"[[ADBannerView alloc] initWithAdType:ADAdTypeBanner]");
    adView.backgroundColor = [UIColor clearColor];
        if([[UIScreen mainScreen] bounds].size.height == 568.0f || [[UIScreen mainScreen] bounds].size.width == 568.0f){
    adView.frame = CGRectMake(0,405,320,50);
        }
        else{
              adView.frame = CGRectMake(0,315,320,50);
        }
        //adView.backgroundColor = [UIColor redColor];
   // adView.frame = CGRectOffset(adView.frame, 0, 50);
    adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    
    adView.delegate=self;
    self.bannerIsVisible=NO;
    }
    return adView;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
//    if (!self.bannerIsVisible)
//    {
//        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
//        // banner is invisible now and moved out of the screen on 50 px
//        
//        banner.frame = CGRectOffset(banner.frame, 0, 50);
//        [UIView commitAnimations];
//        self.bannerIsVisible = YES;
//    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
//    if (self.bannerIsVisible)
//    {
//        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
//        // banner is visible and we move it out of the screen, due to connection issue
//        banner.frame = CGRectOffset(banner.frame, 0, -50);
//        [UIView commitAnimations];
//        self.bannerIsVisible = NO;
//    }
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



@end
