//
//  CreateAccountViewController.m
//  iLifeTracker
//
//  Created by Umesh on 24/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "DataBaseController.h"
@implementation CreateAccountViewController

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
}

-(void) viewWillAppear:(BOOL)animated{
    
    _userName.text      = nil;
    _email.text         = nil ;
    _password.text      = nil ;
    _confirmPwd.text    = nil;
}


-(IBAction)cancelAccount:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) createNewAccount:(id)sender{

    //DataBaseController * obj = [DataBaseController DBControllerharedInstance];

   // [obj insertDataInRegistrationTable:_userName.text email:_email.text password:_password.text confirmPwd:_confirmPwd.text];
    
    _userName.text      = nil;
    _email.text         = nil ;
    _password.text      = nil ;
    _confirmPwd.text    = nil;
   
}




#pragma mark:- TextField Delegate
/**
 @Description :Editing TextField will be show in center of scrollView
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == _confirmPwd){
        [_registrationScrollView setContentOffset:CGPointMake(0,textField.center.y-220) animated:YES];
    }
    
    
    
}
///////////////////////////////////////////////////////////////////////////////

/**
 @Description :Return keyboard when press  return key
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_registrationScrollView setContentOffset:CGPointMake(0,0) animated:YES];
    [textField resignFirstResponder];   
    return YES;
}




@end
