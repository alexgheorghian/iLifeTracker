//
//  PopupViewController.h
//  iLifeTracker
//
//  Created by Umesh on 04/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupViewController : UIViewController {
    
    IBOutlet UIButton *closeBut;
    IBOutlet UITextView *smsTextView;
    UIButton *btn;
}
@property (nonatomic, retain) IBOutlet UITextView *smsTextView;
-(IBAction)dismissModalViewController;
@end
