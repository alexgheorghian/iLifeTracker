//
//  ForgetPwdViewController.m
//  iLifeTracker
//
//  Created by Umesh on 26/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ForgetPwdViewController.h"

#define ALERTTITTLE @"Email successful"

#define FORGETPWDMESSEGE            @"Your password was emailed to you."

#define NAVIGATIONTITLE       @"    Reset Password"

#define NAVIGATIONFELTBTNNAME  @"Cancel"

@implementation ForgetPwdViewController


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
    
    
    // Do any additional setup after loading the view from its nib.
    
    //Add label with navigation tittleview bar
    self.navigationItem.titleView =[CommonUtilClass navigationTittle:NAVIGATIONTITLE];
    
    //set image on navigationbar.
    UIImage *image = [UIImage imageNamed:NAVIGATIONBARIMGNAME];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //set image on left navigationbar item.
    UIButton *leftNavigationbarButton = [CommonUtilClass setImage_OnNavigationbarButton:NAVIGATIONRIGHTBUTTONIMG buttonIdentifier:NAVIGATIONRIGHTBUTTON buttonName:NAVIGATIONFELTBTNNAME];
    UIBarButtonItem *leftNavigationbarItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavigationbarButton];
    [leftNavigationbarButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftNavigationbarItem;
    leftNavigationbarButton=nil;
   
}

-(void) goBack{
    [self.navigationController popViewControllerAnimated:YES]; 
}

-(void) viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

-(IBAction)sendPasswordOnGivenEmail:(id)sender{
   
    
   UIAlertView *sendMessage = [[UIAlertView alloc] initWithTitle:ALERTTITTLE message:FORGETPWDMESSEGE delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil ,nil];
    
    [sendMessage show];
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    //NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if(buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
  
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];   
    return YES;
}


@end
