//
//  RewardModel.h
//  iLifeTracker
//
//  Created by Umesh on 05/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardModel : NSObject {
    
    NSString *categoryName;
    NSString *tolatTime;
}

@property(nonatomic, retain) NSString *categoryName;
@property(nonatomic, retain) NSString *tolatTime;
@end
