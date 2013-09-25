//
//  CreateAccountViewController.h
//  iLifeTracker
//
//  Created by Umesh on 24/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
@interface CreateAccountViewController : UIViewController <UITextFieldDelegate>{
    
    IBOutlet UIScrollView *_registrationScrollView;
    IBOutlet UITextField *_userName;
    IBOutlet UITextField *_email;
    IBOutlet UITextField *_password;
    IBOutlet UITextField *_confirmPwd;
}

-(IBAction)cancelAccount:(id)sender;

-(IBAction) createNewAccount:(id)sender;
@end
