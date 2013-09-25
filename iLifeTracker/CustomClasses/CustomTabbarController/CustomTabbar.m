//
//  CustomTabbar.m
//  iLifeTracker
//
//  Created by Umesh on 24/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTabbar.h"

#define MYLIFETAB       @"MyLIfe"
#define GRAPHTAB        @"Graphs"
#define TRACKTAB        @"Track"
#define REWARDSTAB      @"Rewards"
#define SETTINGSTAB     @"Settings"

@implementation CustomTabbar

@synthesize _trackBtn,_graphsBtn,_myLifeBtn,_rewardsBtn,_settingsBtn;

static NSInteger btnHeight = 50 ;
/*
 @Description:  Do any additional setup when view show . 
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat width = CGRectGetWidth(screen);
    
    CGFloat height = CGRectGetHeight(screen);
    _height        = height - btnHeight;
    _width         = width/5;
    
	[self hideTabBar];
	[self addCustomElements];
}
/////////////////////////////////////////////////////////////

/*
 @Description:  Hide UITabbar . 
 */
- (void)hideTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}
//////////////////////////////////////////////////////////////////

/*
 @Description: Add custbutton on custom tabbar. 
 */
-(void)addCustomElements
{
	// Initialise our two images
	UIImage *btnImage = [UIImage imageNamed:TABBARBUTTONIMGNAME];
	UIImage *btnImageSelected = [UIImage imageNamed:TABBARBUTTONSELECTEDIMG];
	self._myLifeBtn = [UIButton buttonWithType:UIButtonTypeCustom]; //Setup the button
	_myLifeBtn.frame = CGRectMake(0, _height , _width, btnHeight); // Set the frame (size and position) of the button)
	[_myLifeBtn setBackgroundImage:btnImage forState:UIControlStateNormal]; // Set the image for the normal state of the button
	[_myLifeBtn setBackgroundImage:btnImageSelected forState:UIControlStateSelected]; // Set the image for the selected state of the button
    [_myLifeBtn setTitle:MYLIFETAB forState:UIControlStateNormal];
    _myLifeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_myLifeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_myLifeBtn setTag:0]; // Assign the button a "tag" so when our "click" event is called we know which button was pressed.
	[_myLifeBtn setSelected:true]; // Set this button as selected (we will select the others to false as we only want Tab 1 to be selected initially
	// Now we repeat the process for the other buttons
	btnImage = [UIImage imageNamed:TABBARBUTTONIMGNAME];
	btnImageSelected = [UIImage imageNamed:TABBARBUTTONSELECTEDIMG];
	self._graphsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	_graphsBtn.frame = CGRectMake(_width, _height, _width, btnHeight);
	[_graphsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    _graphsBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
	[_graphsBtn setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    
    [_graphsBtn setTitle:GRAPHTAB forState:UIControlStateNormal];
    [_graphsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_graphsBtn setTag:1];
	
	btnImage = [UIImage imageNamed:TABBARBUTTONIMGNAME];
	btnImageSelected = [UIImage imageNamed:TABBARBUTTONSELECTEDIMG];
	self._trackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	_trackBtn.frame = CGRectMake(_width + _width, _height, _width, btnHeight);
	[_trackBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
	[_trackBtn setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [_trackBtn setTitle:TRACKTAB forState:UIControlStateNormal];
    _trackBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_trackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_trackBtn setTag:2];
	
	btnImage = [UIImage imageNamed:TABBARBUTTONIMGNAME];
	btnImageSelected = [UIImage imageNamed:TABBARBUTTONSELECTEDIMG];
	self._rewardsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	_rewardsBtn.frame = CGRectMake(_width+ _width + _width, _height, _width, btnHeight);
	[_rewardsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
	[_rewardsBtn setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [_rewardsBtn setTitle:REWARDSTAB forState:UIControlStateNormal];
    _rewardsBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_rewardsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_rewardsBtn setTag:3];
	
    
    
    btnImage = [UIImage imageNamed:TABBARBUTTONIMGNAME];
	btnImageSelected = [UIImage imageNamed:TABBARBUTTONSELECTEDIMG];
	self._settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	_settingsBtn.frame = CGRectMake(_width+ _width + _width + _width, _height, _width, btnHeight);
	[_settingsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
	[_settingsBtn setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    
    [_settingsBtn setTitle:SETTINGSTAB forState:UIControlStateNormal];
    _settingsBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_settingsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_settingsBtn setTag:4];
    
	// Add my new buttons to the view
	[self.view addSubview:_myLifeBtn];
	[self.view addSubview:_graphsBtn];
	[self.view addSubview:_trackBtn];
	[self.view addSubview:_rewardsBtn];
	[self.view addSubview:_settingsBtn];
    

    
	// Setup event handlers so that the buttonClicked method will respond to the touch up inside event.
	[_myLifeBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[_graphsBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[_trackBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[_rewardsBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_settingsBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
///////////////////////////////////////////////////////////////////

/*
 @Description:  Set selected button tag. 
 */
- (void)buttonClicked:(id)sender
{
	int tagNum = [sender tag];
    //NSLog(@" %i",[sender tag]);
	[self selectTab:tagNum];
}
/////////////////////////////////////////////////////////////////


/*
 @Description:  Action of slected button and normal button . 
 */
- (void)selectTab:(int)tabID
{
	switch(tabID)
	{
		case 0:
			[_myLifeBtn setSelected:true];
			[_graphsBtn setSelected:false];
			[_trackBtn setSelected:false];
			[_rewardsBtn setSelected:false];
            [_settingsBtn setSelected:false];
			break;
		case 1:
			[_myLifeBtn setSelected:false];
			[_graphsBtn setSelected:true];
			[_trackBtn setSelected:false];
			[_rewardsBtn setSelected:false];
            [_settingsBtn setSelected:false];
			break;
		case 2:
			[_myLifeBtn setSelected:false];
			[_graphsBtn setSelected:false];
			[_trackBtn setSelected:true];
			[_rewardsBtn setSelected:false];
            [_settingsBtn setSelected:false];
			break;
		case 3:
			[_myLifeBtn setSelected:false];
			[_graphsBtn setSelected:false];
			[_trackBtn setSelected:false];
			[_rewardsBtn setSelected:true];
            [_settingsBtn setSelected:false];
            break;
        case 4:
			[_myLifeBtn setSelected:false];
			[_graphsBtn setSelected:false];
			[_trackBtn setSelected:false];
			[_rewardsBtn setSelected:false];
            [_settingsBtn setSelected:true];
			break;
	}	
	self.selectedIndex = tabID;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}



@end
