//
//  PopupViewController.m
//  iLifeTracker
//
//  Created by Umesh on 04/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "PopupViewController.h"
#import "CQMFloatingController.h"

@implementation PopupViewController
@synthesize smsTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
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
    //self.view.backgroundColor = [UIColor clearColor];
    smsTextView.editable = NO;
    smsTextView.scrollEnabled = NO;
    smsTextView.backgroundColor = [UIColor clearColor];
    
    [closeBut addTarget:self 
                 action:@selector(myAction) 
       forControlEvents:UIControlEventTouchUpInside];
    
   // CQMFloatingController *obj = [CQMFloatingController sharedFloatingController];
    
   // btn = obj.f
    //smsTextView.text = @"kkhh";
}




-(IBAction)dismissModalViewController{
    
//    CQMFloatingController *obj = [CQMFloatingController sharedFloatingController];
//    
//    //CQMFloatingController *bj1 = obj.objCQMFloatingController;
//    
//    [obj dismissAnimated:YES];
//    [obj removeFromParentViewController];
    
  //  NSLog(@" hello dismiss");
}


@end
