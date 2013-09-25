//
//  NotificationModel.h
//  iLifeTracker
//
//  Created by Umesh on 26/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationModel : NSObject{
    NSString *goal;
    NSString *alaram;
    NSString *autoStop;
}

@property(nonatomic , retain)   NSString *goal;
@property(nonatomic , retain)   NSString *alaram;
@property(nonatomic , retain)   NSString *autoStop;
@end
