//
//  CustomTabbar.h
//  iLifeTracker
//
//  Created by Umesh on 24/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomTabbar : UITabBarController {
    
	UIButton *_myLifeBtn;
	UIButton *_graphsBtn;
	UIButton *_trackBtn;
	UIButton *_rewardsBtn;
    UIButton *_settingsBtn;
    
    NSInteger _height;
    NSInteger _width;
}
@property (nonatomic, retain) UIButton *_myLifeBtn;
@property (nonatomic, retain) UIButton *_graphsBtn;
@property (nonatomic, retain) UIButton *_trackBtn;
@property (nonatomic, retain) UIButton *_rewardsBtn;
@property (nonatomic, retain) UIButton *_settingsBtn;

-(void) hideTabBar;
-(void) addCustomElements;
-(void) selectTab:(int)tabID;


@end
