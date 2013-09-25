//
//  LoginViewController.m
//  iLifeTracker
//
//  Created by Umesh on 24/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

#define LOGINVALIDATION             @"The username and password do not match. Please try again."

#define LOGINALERTTITLE             @"Login Validation"
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _pwdTextField.secureTextEntry = YES;
}

-(void) viewWillAppear:(BOOL)animated{
    _emailTextField.text = nil;
    _pwdTextField.text = nil;
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden = YES;
    
    [_pwdTextField resignFirstResponder];

}

-(IBAction)createNewAccount:(id)sender{
     CreateAccountViewController *objCrtAccountViewController;
    objCrtAccountViewController = [[CreateAccountViewController alloc] init];
    [self.navigationController pushViewController:objCrtAccountViewController animated:YES];
}

-(IBAction)userLogin:(id)sender{
//    DataBaseController *objDataBaseController = [DataBaseController DBControllerharedInstance];
//    //BOOL boolValue=[objDataBaseController validateLoginUser:_emailTextField.text password:_pwdTextField.text];
//    
//    if (boolValue) {
//        CommonTabbar *obj = [CommonTabbar CommonTabbarSharedInstance];
//        [obj addCustomTabbar];
//    }else{
//        CommonUtilClass *objCommonUtil = [CommonUtilClass CommonUtilSharedInstance];
//        [objCommonUtil showAlertView:LOGINVALIDATION title:LOGINALERTTITLE];
//    }
}


-(IBAction)forgetPassword:(id)sender{
    ForgetPwdViewController *objForgetPwd = [[ForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:objForgetPwd animated:YES];
}


-(IBAction)loginWithFacebook:(id)sender{
    LoginWithFacebook *obj = [LoginWithFacebook LoginWithFacebookSharedInstance];
    [obj loginWithFacebook];
}

-(void) openTabBarScreenForFacebookLogin{
    CommonTabbar *obj = [CommonTabbar CommonTabbarSharedInstance];
    [obj addCustomTabbar];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];   
    return YES;
}



@end
