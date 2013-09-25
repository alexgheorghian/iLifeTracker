
//
//  MyLifeCustomCell.h
//  iLifeTracker
//
//  Created by Umesh on 09/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLifeCustomCell : UITableViewCell{
    
    IBOutlet UILabel *trackerNameLbl;
    IBOutlet UILabel *startTimeLbl;
    IBOutlet UILabel *endTimeLbl;
    IBOutlet UILabel *durationLbl;
}
@property (nonatomic, retain) IBOutlet UILabel *trackerNameLbl;
@property (nonatomic, retain) IBOutlet UILabel *startTimeLbl;
@property (nonatomic, retain) IBOutlet UILabel *endTimeLbl;
@property (nonatomic, retain) IBOutlet UILabel *durationLbl;

@end
