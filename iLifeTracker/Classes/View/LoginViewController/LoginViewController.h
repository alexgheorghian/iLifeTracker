//
//  LoginViewController.h
//  iLifeTracker
//
//  Created by Umesh on 24/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateAccountViewController.h"
#import "CommonTabbar.h"
#import "ForgetPwdViewController.h"
#import "LoginWithFacebook.h"
#import "DataBaseController.h"

@interface LoginViewController : UIViewController {
    IBOutlet UITextField *_emailTextField;
    IBOutlet UITextField *_pwdTextField;
 
}

-(IBAction)createNewAccount:(id)sender;

-(IBAction)userLogin:(id)sender;

-(IBAction)forgetPassword:(id)sender;

-(IBAction)loginWithFacebook:(id)sender;

-(void) openTabBarScreenForFacebookLogin;

@end
