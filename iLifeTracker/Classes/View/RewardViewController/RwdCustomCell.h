//
//  RwdCustomCell.h
//  iLifeTracker
//
//  Created by Umesh on 04/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RwdCustomCell : UITableViewCell {
    
    IBOutlet UITextView    *smsTextView;
    IBOutlet UIImageView   *categoryImageView;
    
    IBOutlet UIImageView   *rwdStar1;
    IBOutlet UIImageView   *rwdStar2;
    IBOutlet UIImageView   *rwdStar3;
    IBOutlet UIImageView   *rwdStar4;
    IBOutlet UIImageView   *rwdStar5;
    IBOutlet UILabel       *categoryName;
    
    IBOutlet UIImageView  *backGroundImage;
    //IBOutlet UIImageView *image;
}

@property(nonatomic, retain) IBOutlet UITextView    *smsTextView;
@property(nonatomic, retain) IBOutlet UIImageView   *categoryImageView;

@property(nonatomic, retain) IBOutlet UIImageView   *rwdStar1;
@property(nonatomic, retain) IBOutlet UIImageView   *rwdStar2;
@property(nonatomic, retain) IBOutlet UIImageView   *rwdStar3;
@property(nonatomic, retain) IBOutlet UIImageView   *rwdStar4;
@property(nonatomic, retain) IBOutlet UIImageView   *rwdStar5;
@property(nonatomic, retain)  IBOutlet UILabel       *categoryName;
@property(nonatomic, retain)  IBOutlet UIImageView  *backGroundImage;

@end
