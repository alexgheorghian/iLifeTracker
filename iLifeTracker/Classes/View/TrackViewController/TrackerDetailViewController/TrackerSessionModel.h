//
//  TrackerSessionModel.h
//  iLifeTracker
//
//  Created by Umesh on 14/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackerSessionModel : NSObject {
    
    NSString *trackerId;
    NSString *trackerName;
    NSString *trackerCategory;
    NSString *trackerSesion;
    NSString *trackerStartTime;
    NSString *trackerEndTime;
    NSString *trackerTotalTime;
}

@property(nonatomic , retain) NSString *trackerId;
@property(nonatomic , retain) NSString *trackerName;
@property(nonatomic , retain) NSString *trackerCategory;
@property(nonatomic , retain) NSString *trackerSesion;
@property(nonatomic , retain) NSString *trackerStartTime;
@property(nonatomic , retain) NSString *trackerEndTime;
@property(nonatomic , retain) NSString *trackerTotalTime;
@end
