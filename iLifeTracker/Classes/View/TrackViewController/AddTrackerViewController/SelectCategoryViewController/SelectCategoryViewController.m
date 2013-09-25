//
//  SelectCategoryViewController.m
//  iLifeTracker
//
//  Created by Umesh on 31/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectCategoryViewController.h"
#define NAVIGATIONRIGHTBTNNAME @"Select"
#define NAVIGATIONFELTBTNNAME  @"Cancel"
#define NAVIGATIONTITLE        @"         Category"

@implementation SelectCategoryViewController
@synthesize _addCategory,categoryName;
@synthesize bannerIsVisible;
#pragma mark - View lifecycle
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
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    //Set image on right navigationbar item.
    UIButton *rightNavigationbarButton= [CommonUtilClass setImage_OnNavigationbarButton:NAVIGATIONRIGHTBUTTONIMG buttonIdentifier:NAVIGATIONLEFTBUTTON buttonName:NAVIGATIONRIGHTBTNNAME];
    UIBarButtonItem *rightNavigationbarItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavigationbarButton];
    [rightNavigationbarButton addTarget:self action:@selector(selectedCategoryName) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightNavigationbarItem;
    rightNavigationbarButton=nil;
    
    _categoryNameArray = [[NSMutableArray alloc] initWithObjects:@"General",@"Sports" ,@"Work",@"Travel",@"Lifestyle",@"Internet",@"Shopping", nil];
    
    [_categoryTitleLabel     setFont:[UIFont fontWithName:FONTNAME size:24]];
    //categoryPickerView.backgroundColor = [UIColor clearColor];
   // [categoryPickerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"black_bg.png"]]];
    
//    CALayer* mask = [[CALayer alloc] init];
//    [mask setBackgroundColor: [UIColor blackColor].CGColor];
//    [mask setFrame: CGRectMake(30.0f, 10.0f, 260.0f, 160.0f)];
//    [mask setCornerRadius: 5.0f];
//    [categoryPickerView.layer setMask: mask];
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        banner.frame = CGRectOffset(banner.frame, 0, 50);
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // banner is visible and we move it out of the screen, due to connection issue
        banner.frame = CGRectOffset(banner.frame, 0, -50);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    // NSLog(@"Banner view is beginning an ad action");
    BOOL shouldExecuteAction = YES;
    if (!willLeave && shouldExecuteAction)
    {
        // stop all interactive processes in the app
        // [video pause];
        // [audio pause];
    }
    return shouldExecuteAction;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    // resume everything you've stopped
    // [video resume];
    // [audio resume];
}

-(void) viewWillAppear:(BOOL)animated{
    //NSLog(@" category name :-> %@ ",categoryName );
    CommonUtilClass *commonObj = [CommonUtilClass CommonUtilSharedInstance];
    adView.backgroundColor = [UIColor clearColor];
    adView = [commonObj iADView];
   // adView.delegate = self;
    [self.view addSubview:adView];
    [self.view bringSubviewToFront:adView];
    
    if (![categoryName isEqualToString:@"Category"]) {
         _categoryNameLabel.text = categoryName; 
        
        for (int i =0; i< [_categoryNameArray count];i++ ) {
            if([[_categoryNameArray objectAtIndex:i] isEqualToString:categoryName]){
                
                [categoryPickerView selectRow:i inComponent:0 animated:NO];
            }
        }
    }
    if ([categoryName isEqualToString:@"Category"]) {
         currentSelectedCategoryName = @"General";
    }else{
         currentSelectedCategoryName = categoryName;
    }
   
}
-(void) goBack {
   // AddTrackerViewController *obj = _addCategory;
  //  obj._selectedCategoryName     =@"Category";
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) selectedCategoryName{
  
    AddTrackerViewController *obj = _addCategory;
    obj._selectedCategoryName     = currentSelectedCategoryName;
     [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - PickerView method
/*
 @Description:Numer of components in pickerview
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

/*
 @Description:Numer of row in component 
 */
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
  return   [_categoryNameArray count];
    //return [arrayColors count];
}

/*
 @Description:Display data on pickerview
 */
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
        return [_categoryNameArray objectAtIndex:row];
    //return [arrayColors objectAtIndex:row];
}

/*
 @Description:Select row of component 
 */
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
   // _categoryNameLabel.text = [_categoryNameArray objectAtIndex:row];
    
    currentSelectedCategoryName = [_categoryNameArray objectAtIndex:row];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    label.text = [_categoryNameArray objectAtIndex:row];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor blackColor];
    
    return label;
}



@end
