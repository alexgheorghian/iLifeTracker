//
//  iLifeTrackerTabbar.m
//  iLifeTracker
//
//  Created by Umesh on 24/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "iLifeTrackerTabbar.h"
#import "GraphViewController.h"
@implementation iLifeTrackerTabbar

static iLifeTrackerTabbar *obj;

static bool rotationIdentify = NO;

+(iLifeTrackerTabbar *) tabBarShareInstance{
    if (obj == nil ) {
        obj = [[iLifeTrackerTabbar alloc] init];
    }
    return obj;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    // You do not need this method if you are not supporting earlier iOS Versions
    if(rotationIdentify){
        if ( interfaceOrientation == UIInterfaceOrientationLandscapeRight){
            //self.tabBar.alpha = 0;
            self.tabBar.hidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }
        else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
            //self.tabBar.alpha = 0;
            self.tabBar.hidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            
        } else if(interfaceOrientation == UIInterfaceOrientationPortrait){
            self.tabBar.hidden = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            
        }else if(interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown){
            self.tabBar.hidden = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            
        }
    }
    return [self.selectedViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

-(NSUInteger)supportedInterfaceOrientations
{
    //[[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (self.selectedViewController)
        return [self.selectedViewController supportedInterfaceOrientations];
    
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    NSLog(@"shouldAutorotate IN CUSTOM TAB BAR");
    UIInterfaceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];    //self.tabBar.hidden = YES;
    NSLog(@"%d rotationIdentify  %d interfaceOrientation",rotationIdentify,interfaceOrientation);
    if(rotationIdentify){
        if ( interfaceOrientation == UIInterfaceOrientationLandscapeRight){
            //self.tabBar.alpha = 0;
            NSLog(@"UIInterfaceOrientationLandscapeRight");
            self.tabBar.hidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }
        else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
            //self.tabBar.alpha = 0;
            NSLog(@"UIInterfaceOrientationLandscapeLeft");
            self.tabBar.hidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];

            // self.tabBar.backgroundColor = [UIColor redColor];
            
        } else if(interfaceOrientation == UIInterfaceOrientationPortrait){
            NSLog(@"UIInterfaceOrientationPortrait");
            self.tabBar.hidden = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:NO];

            
        }else if(interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown){
            NSLog(@"UIInterfaceOrientationPortraitUpsideDown");
            self.tabBar.hidden = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:NO];

            
        }
    }
    
    return [self.selectedViewController shouldAutorotate];
}




- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    NSInteger barItem1 = [[tabBar items] indexOfObject:item];
     if(barItem1 == 1){
        
        rotationIdentify = YES;
     }else{
         rotationIdentify = NO;
     }
}


@end
