//
//  AddTrackerViewController.m
//  iLifeTracker
//
//  Created by Umesh on 28/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddTrackerViewController.h"
#define NAVIGATIONRIGHTBTNNAME @"Done"
#define NAVIGATIONFELTBTNNAME  @"Cancel"

#define CATEGORYNAME           @"Category"

#define EMPTYFIELDIMGNAME      @"name_red.png"
#define CATEGORYREDIMG         @"category_red.png"

#define FILLFIELDIMAGENAME     @"name.png"
#define CATEGORYBLACKIMG       @"category.png"

#define DEFAULTVALUE           @"0"

#define TRACKERNAMEALREADYEXIST @"A tracker with this name already exists."
#define  ADDTRACKERTITLE        @"Add Tracker"
#define  ADDTRACKERALERTSMS     @"Tracker added successfully."

@implementation AddTrackerViewController
@synthesize bannerIsVisible;
@synthesize _selectedCategoryName,editTracker,_TrackerID,title;

#pragma mark - View lifecycle

static NSString *goalHours         = DEFAULTVALUE;
static NSString *alarmPersentage   = DEFAULTVALUE;
static NSString *autoStopIntervel  = DEFAULTVALUE;
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
    self.navigationItem.titleView =[CommonUtilClass navigationTittle:title ];
    
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
     [rightNavigationbarButton addTarget:self action:@selector(newTrackerAdd) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightNavigationbarItem;
    rightNavigationbarButton=nil;
    //set content size of scrollview 
[_addTrackerScrollView setContentSize:CGSizeMake(320, 520)];
    //initial show 
    _selectedCategoryName = CATEGORYNAME;

    [_trackerNameTitleLabel     setFont:[UIFont fontWithName:FONTNAME size:24]];
    [_categoryNameTitleLabel    setFont:[UIFont fontWithName:FONTNAME size:24]];
    [_autoStopTtlLabel          setFont:[UIFont fontWithName:FONTNAME size:24]];
    [_autoStopNextTtlLabel      setFont:[UIFont fontWithName:FONTNAME size:24]];
    
//    _alarmSlider.enabled = NO;
//    _notificationSlider.enabled = NO;
//     _goalHourStepper.enabled = NO;
    
   
    //bigImage.userInteractionEnabled = YES;
    //_addTrackerScrollView.userInteractionEnabled = YES;
    touchView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [touchView addGestureRecognizer:tap];
    //
    
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
-(void)dismissKeyboard {
    [_nameTextField resignFirstResponder];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if([[UIScreen mainScreen] bounds].size.height == 568.0f || [[UIScreen mainScreen] bounds].size.width == 568.0f){
        adView.frame = CGRectMake(0,405,320,50);
    }
    else{
        adView.frame = CGRectMake(0,315,320,50);
    }
}

-(void) viewWillAppear:(BOOL)animated{
//    if(_goalSwich.on){
//    _alarmSwitch.enabled = YES;
//        NSLog(@" enable alarm if");
//    }else{
//        _alarmSwitch.enabled = NO;
//         NSLog(@" enable alarm else");
//    }
    
    CommonUtilClass *commonObj = [CommonUtilClass CommonUtilSharedInstance];
    adView.backgroundColor = [UIColor clearColor];
    adView = [commonObj iADView];
    //adView.delegate = self;
    [self.view addSubview:adView];
    [self.view bringSubviewToFront:adView];
    if([[UIScreen mainScreen] bounds].size.height == 568.0f || [[UIScreen mainScreen] bounds].size.width == 568.0f){
        adView.frame = CGRectMake(0,455,320,50);
    }
    else{
        adView.frame = CGRectMake(0,365,320,50);
    }
    if (!editTracker) {
   // if(LOGS_ON) NSLog(@"_selectedCategoryName :-> %@",_selectedCategoryName);
    _categoryNameLabel.text = _selectedCategoryName;
        //
        _alarmSwitch.enabled = NO;
    //
    [_categoryNameButton setBackgroundImage:[UIImage imageNamed:CATEGORYBLACKIMG] forState:normal];
     _nameTextField.background = [UIImage imageNamed:FILLFIELDIMAGENAME];
        
        _alarmSlider.enabled = NO;
        _notificationSlider.enabled = NO;
        _goalHourStepper.enabled = NO;
        //
        
 
        
    } else{
        DataBaseController *obj = [DataBaseController DBControllerharedInstance];
        _trackerRecordArray = [obj selectTrackerOneRecordTrackerID:_TrackerID];
        if ([_trackerRecordArray count]>0) {
            UpdateTrackerModel *objUpateTracker =  [_trackerRecordArray objectAtIndex:0];
            _nameTextField.text         = objUpateTracker.trackerName;
            _categoryNameLabel.text     = objUpateTracker.trackerCategory;
        
          
            
            if ([objUpateTracker.trackerGoal intValue] == 0   ) {
                _goalHourStepper.enabled = NO;
               // NSLog(@"trackerGoal if :-> %@ ",objUpateTracker.trackerGoal);
                _goalHourLabel.text = @"1";
                 _alarmSwitch.enabled = NO;
            }else{
               //  NSLog(@"trackerGoal else :-> %@ ",objUpateTracker.trackerGoal);
                _goalHourLabel.text         = objUpateTracker.trackerGoal;
                _goalSwich.on= YES;
                 _alarmSwitch.enabled = YES;
            }
            if ([objUpateTracker.trackerAlarm intValue] == 0  ) {
                _alarmSlider.enabled = NO;
                 _alarmLablel.text           = @"0";
            }
            else{
                _alarmLablel.text           = objUpateTracker.trackerAlarm;
                _alarmSwitch.on = YES;
            }
                                
            if ( [objUpateTracker.trackerNtf intValue] == 0) {
                _notificationSlider.enabled = NO;
                _autoStopLabel.text = @"10";
            }else{
              _autoStopLabel.text         = objUpateTracker.trackerNtf;  
              _autoStopSwitch.on = YES;
            }
            //
           // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ALARM"]; 
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"ALARM"]) {
                
               // NSLog(@"ALARM set true ******************** ");
               //  _alarmSwitch.enabled  = NO;
                _alarmSwitch.on        = NO;
               _alarmSlider.enabled    = NO;
                _alarmSlider.value     = 0;
                _alarmLablel.text      = @"0";
            }
            
            _alarmSlider.value          = [objUpateTracker.trackerAlarm intValue];
            _notificationSlider.value   = [objUpateTracker.trackerNtf intValue];
            _goalHourStepper.value      = [objUpateTracker.trackerGoal intValue];
            
                       
        }
    }
}

-(void) goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) newTrackerAdd{
    
    
        if (_goalSwich.on) {
            goalHours = _goalHourLabel.text;
        }else{
            goalHours = DEFAULTVALUE;
        }
        if (_alarmSwitch.on) {
            alarmPersentage = _alarmLablel.text;
        }
        else{
            alarmPersentage  = DEFAULTVALUE;
        }
        if (_autoStopSwitch.on) {
            autoStopIntervel = _autoStopLabel.text;
        } else {
            autoStopIntervel = DEFAULTVALUE;
        }

    
    if ([_categoryNameLabel.text isEqualToString:CATEGORYNAME] ||[_nameTextField.text length]==0) {
        
    if([_categoryNameLabel.text isEqualToString:CATEGORYNAME]){
        [_categoryNameButton  setBackgroundImage:[UIImage imageNamed:CATEGORYREDIMG] forState:UIControlStateNormal];
    }
    if ([_nameTextField.text length]==0) {
        _nameTextField.background = [UIImage imageNamed:EMPTYFIELDIMGNAME]; 
    }
    }else {
        if (!editTracker){
        DataBaseController *objDataBaseController = [DataBaseController DBControllerharedInstance]; 
        BOOL boolValue =[objDataBaseController InsertDataIntoTrackerTableTrackerName:_nameTextField.text category:_categoryNameLabel.text goalHours:goalHours alarm:alarmPersentage autoStopIntervel:autoStopIntervel];
        
            CommonUtilClass *objCommonUtilClass = [CommonUtilClass CommonUtilSharedInstance];
            if (!boolValue) {
                _nameTextField.background = [UIImage imageNamed:EMPTYFIELDIMGNAME]; 
                [objCommonUtilClass showAlertView:TRACKERNAMEALREADYEXIST title:ADDTRACKERTITLE];
            }else{
                [objCommonUtilClass showAlertView:ADDTRACKERALERTSMS title:ADDTRACKERTITLE];
                 [self.navigationController popViewControllerAnimated:YES];
            }
            
            goalHours               = DEFAULTVALUE;
            alarmPersentage         = DEFAULTVALUE;
            autoStopIntervel        = DEFAULTVALUE;
            _nameTextField.text     = nil;
            _categoryNameLabel.text = CATEGORYNAME;
            
            [_autoStopSwitch setOn:NO];
            [_alarmSwitch    setOn:NO];
            [_goalSwich     setOn:NO];
            
            //
            _goalHourStepper.enabled = NO;
            
            _alarmSlider.enabled = NO;
            _notificationSlider.enabled = NO;
             
            _goalHourStepper.value = 1;
            _alarmSlider.value = 0;
            _notificationSlider.value = 10;
            
            _goalHourLabel.text = @"1";
            
            _autoStopLabel.text = @"10";
            
            _alarmLablel.text   = @"0";
      }
        else{
            
            DataBaseController *objDataBaseController = [DataBaseController DBControllerharedInstance]; 
            [objDataBaseController updateTrackerRecordTrakerID:_TrackerID trackerName:_nameTextField.text category:_categoryNameLabel.text goalHours:goalHours alarm:alarmPersentage autoStopIntervel:autoStopIntervel];
            
//            TrackViewController  * objTrack= [TrackViewController TrackSharedInstance]; 
//            
//            [objTrack._customCellObjArry removeAllObjects];
           // NSLog(@" edit tracker Detail");
            
            //[[NSUserDefaults standardUserDefaults] integerForKey:@"edit"];
           
             //[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"edit"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ALARM"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EDIT"];
              [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}



-(IBAction) alarmSliderChangeState:(id) sender{
	UISlider *slider  = (UISlider *) sender;
	int progressAsInt = (int)(slider.value + 0.5f);
	NSString *newText = [[NSString alloc] initWithFormat:@"%d",progressAsInt];
	_alarmLablel.text = newText;
}

-(IBAction)selectCategoryName:(id)sender{
    [_nameTextField resignFirstResponder];
    if (!editTracker) {
    [_categoryNameButton setBackgroundImage:[UIImage imageNamed:CATEGORYBLACKIMG] forState:normal];
    SelectCategoryViewController *objSelectCategory = [[SelectCategoryViewController alloc] init];
    objSelectCategory._addCategory = self;
    objSelectCategory.categoryName= _categoryNameLabel.text;
     
    [self.navigationController pushViewController:objSelectCategory animated:YES];
    }
}


-(IBAction)selectGoalHour:(id)sender{
    double stepperValue = _goalHourStepper.value;
    _goalHourLabel.text = [NSString stringWithFormat:@"%.f", stepperValue];
}


-(IBAction)selectNotificationTime:(id)sender{
    UISlider *slider    =   (UISlider *) sender;
	int progressAsInt   =   (int)(slider.value + 0.5f);
	NSString *newText   =   [[NSString alloc] initWithFormat:@"%d",progressAsInt];
	_autoStopLabel.text =   newText;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];   
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _nameTextField.background = [UIImage imageNamed:FILLFIELDIMAGENAME]; 
}



-(IBAction)SwichButtonOnAndOff:(id)sender{
    UISwitch *button = sender;
    if (button == _goalSwich) {
      if (button.on) {
          _goalHourStepper.enabled = YES;
          _alarmSwitch.enabled = YES;
          // NSLog(@" _goalSwich ON ");
          if(_alarmSwitch.on){
           _alarmSlider.enabled = YES;   
          }
      }else{
          _goalHourStepper.enabled = NO;
          _alarmSwitch.enabled = NO;
          _alarmSlider.enabled = NO;
          //_alarmSwitch.enabled = NO;
        //  NSLog(@" _goalSwich OFF ");
      }
    }
    else if (button == _alarmSwitch) {
        if (button.on) {
            if(_goalSwich.on){
            _alarmSlider.enabled = YES;
            
            }
        }else{
            _alarmSlider.enabled = NO;
            
        }
    }
    else if (button == _autoStopSwitch) {
        if (button.on) {
            _notificationSlider.enabled = YES;
        } else {
            _notificationSlider.enabled = NO;
        }
    }
}



//-(void)touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {   
////    NSArray *subviews = [self.view subviews];
////    for (id objects in subviews) {
////        if ([objects isKindOfClass:[UITextField class]]) {
////            UITextField *theTextField = objects;
////            if ([objects isFirstResponder]) {
////                [theTextField resignFirstResponder];
////            }
////        } 
////    }
//    NSLog(@" touchesEnded ");
//}


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//     NSLog(@" touchesBegan ");
//}
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@" touchesMoved ");
//}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//  NSLog(@" touchesEnded ");  
//}

@end
