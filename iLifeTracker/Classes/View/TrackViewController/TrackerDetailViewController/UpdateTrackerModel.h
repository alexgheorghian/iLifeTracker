//
//  UpdateTrackerModel.h
//  iLifeTracker
//
//  Created by Umesh on 16/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateTrackerModel : NSObject{
    
    NSString   *trackerName;
    NSString   *trackerCategory;
    NSString   *trackerGoal;
    NSString   *trackerAlarm;
    NSString   *trackerNtf;
}
@property (nonatomic , retain)  NSString   *trackerName;
@property (nonatomic , retain)  NSString   *trackerCategory;
@property (nonatomic , retain)  NSString   *trackerGoal;
@property (nonatomic , retain)  NSString   *trackerAlarm;
@property (nonatomic , retain)  NSString   *trackerNtf;
@end
