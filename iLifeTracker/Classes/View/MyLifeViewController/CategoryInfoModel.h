//
//  CategoryInfoModel.h
//  iLifeTracker
//
//  Created by Umesh on 17/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryInfoModel : NSObject {
    NSString *trackerName;
    NSString *trackerCategory;
    NSString *totalTime;
    NSString *maxTime;
    NSString *trackercount;
}

@property (nonatomic , retain) NSString *trackerName;
@property (nonatomic , retain) NSString *trackerCategory;
@property (nonatomic , retain) NSString *totalTime;
@property (nonatomic , retain) NSString *maxTime;
@property (nonatomic , retain) NSString *trackercount;
@end
