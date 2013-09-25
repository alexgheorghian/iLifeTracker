//
//  LoginWithFacebook.h
//  iLifeTracker
//
//  Created by Umesh on 27/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FbGraph.h"
#import "SBJSON.h"
#import "LoginViewController.h"
#import "DataBaseController.h"
#import "LoginViewController.h"
@interface LoginWithFacebook : NSObject{
    FbGraph *objFBGraph;
}


+ (LoginWithFacebook *) LoginWithFacebookSharedInstance;

-(void) loginWithFacebook;

- (void)logOutFaceBookUser;
@end
