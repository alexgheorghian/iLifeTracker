
//
//  TrackerDetailCustomCell.h
//  iLifeTracker
//
//  Created by Umesh on 14/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackerDetailCustomCell : UITableViewCell {
    IBOutlet UILabel *startTimeLbl;
    IBOutlet UILabel *endTimeLbl;
    IBOutlet UILabel *durationTimeLbl;
    
    IBOutlet UILabel *boldTitleLabel1;
    IBOutlet UILabel *boldTitleLabel2;
    IBOutlet UILabel *boldTitleLabel3;
    
}
@property (nonatomic , retain)   IBOutlet UILabel *startTimeLbl;
@property (nonatomic , retain)  IBOutlet UILabel *endTimeLbl;
@property (nonatomic , retain)  IBOutlet UILabel *durationTimeLbl;

@property (nonatomic , retain) IBOutlet UILabel *boldTitleLabel1;
@property (nonatomic , retain) IBOutlet UILabel *boldTitleLabel2;
@property (nonatomic , retain) IBOutlet UILabel *boldTitleLabel3;
@end
