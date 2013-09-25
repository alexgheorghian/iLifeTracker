//
//  GraphModel.h
//  iLifeTracker
//
//  Created by Umesh on 25/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphModel : NSObject{
    
    NSString *trackerId;
    NSString *trackerName;
    NSString *trackerSesion;
    NSString *trackerStartTime;
    NSString *trackerEndTime;
    NSString *currentSession;
}

@property(nonatomic , retain) NSString *trackerId;
@property(nonatomic , retain) NSString *trackerName;
@property(nonatomic , retain) NSString *trackerSesion;
@property(nonatomic , retain) NSString *trackerStartTime;
@property(nonatomic , retain) NSString *trackerEndTime;

@property(nonatomic , retain) NSString *currentSession;


@end
