//
//  RwdCustomCell.m
//  iLifeTracker
//
//  Created by Umesh on 04/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "RwdCustomCell.h"

@implementation RwdCustomCell
@synthesize rwdStar1,rwdStar2,rwdStar3,rwdStar4,rwdStar5,categoryImageView,smsTextView,categoryName,backGroundImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
