//
//  TrackerDetailModel.h
//  iLifeTracker
//
//  Created by Umesh on 09/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackerDetailModel : NSObject {
    
    NSString *trackerSessionID;
    NSString *trackerName;
    NSString *trackerCategory;
    NSString *trackerSetion;
    
    NSString *goal;
    NSString *alaram;
    NSString *autoStop;
}

@property (nonatomic ,retain)  NSString *trackerName;
@property (nonatomic ,retain)  NSString *trackerCategory;
@property (nonatomic ,retain)  NSString *trackerSetion;

@property (nonatomic ,retain)  NSString *trackerSessionID;


@property(nonatomic , retain)   NSString *goal;
@property(nonatomic , retain)   NSString *alaram;
@property(nonatomic , retain)   NSString *autoStop;

@end
