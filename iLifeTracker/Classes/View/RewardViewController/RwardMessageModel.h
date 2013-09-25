//
//  RwardMessageModel.h
//  iLifeTracker
//
//  Created by Umesh on 05/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RwardMessageModel : NSObject {
    NSString *categoryName;
    NSString *rewardInterval;
    NSString *rewardImage;
    NSString *rewardMessage1;
    NSString *rewardMessage2;
    NSString *rewardMessage3;
    NSString *rewardMessage4;
    NSString *rewardMessage5;
    NSString *starCount;
    
}

@property(nonatomic, retain) NSString *categoryName;
@property(nonatomic, retain) NSString *rewardInterval;
@property(nonatomic, retain) NSString *rewardImage;
@property(nonatomic, retain) NSString *rewardMessage1;
@property(nonatomic, retain) NSString *rewardMessage2;
@property(nonatomic, retain) NSString *rewardMessage3;
@property(nonatomic, retain) NSString *rewardMessage4;
@property(nonatomic, retain) NSString *rewardMessage5;
@property(nonatomic, retain) NSString *starCount;

@end
