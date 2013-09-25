//
//  SelectCategoryViewController.h
//  iLifeTracker
//
//  Created by Umesh on 31/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTabbar.h"
#import "AddTrackerViewController.h"

@interface SelectCategoryViewController : UIViewController<ADBannerViewDelegate> {
    NSMutableArray       *_categoryNameArray;
    IBOutlet UILabel     *_categoryNameLabel;
    id                   _addCategory;
    IBOutlet UILabel     *_categoryTitleLabel;
    NSString             *categoryName;
    IBOutlet UIPickerView *categoryPickerView;
    
    NSString *currentSelectedCategoryName;
    //
    ADBannerView *adView;
    BOOL bannerIsVisible;
}
@property (nonatomic,assign) BOOL bannerIsVisible;

@property (nonatomic, retain) id   _addCategory;

@property (nonatomic, retain)  NSString    *categoryName;
@end
