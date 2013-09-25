
//  Created by Adrian
//  Copyright (c) 2013 3rd Floor Software Solutions Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeDividerModel : NSObject {
    
    NSString *trackerName;
    NSString *trackerSesion;
    
    NSString *date;
}

@property (nonatomic , retain)  NSString *trackerName;
@property (nonatomic , retain)  NSString *trackerSesion;

@property (nonatomic , retain)  NSString *date;
@end
