//
//  CommonUtilClass.h
//  iLifeTracker
//
//  Created by Umesh on 26/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseController.h"
#import "GraphModel.h"
#import "TimeDividerModel.h"

@interface CommonUtilClass : NSObject <UIAlertViewDelegate,ADBannerViewDelegate>{
    UIAlertView *message;
    NSString *grphTrackerName;
    
    
    //NSMutableArray *timeArray;
    NSInteger day;
    
    // ADBannerView *adView;
    BOOL bannerIsVisible;
}
@property (nonatomic,assign) BOOL bannerIsVisible;
- (ADBannerView *)iADView;

//@property (nonatomic , retain)  NSMutableArray *timeArray;
@property (nonatomic)  NSInteger day;

+(CommonUtilClass *) CommonUtilSharedInstance;



-(void) showAlertView:(NSString *) alertMessage title:(NSString *) title;


+(UIButton *) setImage_OnNavigationbarButton : (NSString *) imageName buttonIdentifier:(NSString *) button buttonName:(NSString *) buttonName;

+(UILabel *) navigationTittle:(NSString  *) tittleName;


+(NSString *) convetIntoTimeFormatSecond:(long) second;


//+(NSMutableArray *) manageAllDayTime:(NSMutableArray *) recordArray  trackerName:(NSString *) trackerName;



//+(NSDate *) convertIntoDateString:(NSString *) dateString;

+(NSMutableArray *) breakTime:(NSMutableArray *) recordArray  trackerName:(NSString *) trackerName;

////Graph
//-(void) setTrackerName:(NSString *) trackerName;
//
//-(void) trackerSessionDayTrackerName:(NSString *) trackerName;
//
//-(NSMutableArray *) everyDayTotalTimeOfTracker;
//
//-(NSInteger) numberOfdayForConnentTracker;
@end
