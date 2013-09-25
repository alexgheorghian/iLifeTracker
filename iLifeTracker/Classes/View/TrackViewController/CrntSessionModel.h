//
//  CrntSessionModel.h
//  iLifeTracker
//
//  Created by Umesh on 09/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrntSessionModel : NSObject {
    
    NSString    *trackerName;
    NSString    *timeCounter;
    NSString    *startDate;
    NSString    *storeDate;
    NSString    *pauseCounter;
    NSString    *indexNumber;
    NSString    *pauseIdentify;
    NSString    *runIdentify;
}

@property(nonatomic,retain) NSString    *trackerName;
@property(nonatomic,retain) NSString    *timeCounter;
@property(nonatomic,retain) NSString    *startDate;
@property(nonatomic,retain) NSString    *storeDate;
@property(nonatomic,retain) NSString    *pauseCounter;
@property(nonatomic,retain) NSString    *indexNumber;
@property(nonatomic,retain) NSString    *pauseIdentify;
@property(nonatomic,retain) NSString    *runIdentify;

@end
