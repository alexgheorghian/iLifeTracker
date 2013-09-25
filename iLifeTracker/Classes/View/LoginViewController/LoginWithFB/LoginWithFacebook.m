//
//  LoginWithFacebook.m
//  iLifeTracker
//
//  Created by Umesh on 27/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginWithFacebook.h"

@implementation LoginWithFacebook

static LoginWithFacebook *_objLoginWithFacebook = nil;

+ (LoginWithFacebook *) LoginWithFacebookSharedInstance {
    if (_objLoginWithFacebook == nil) {
        _objLoginWithFacebook = [[LoginWithFacebook alloc] init];
    }
    
    return _objLoginWithFacebook;
}

-(void) loginWithFacebook {
    
    //create the instance of graph api
    objFBGraph = [[FbGraph alloc]initWithFbClientID:FbClientID];
    //mark some permissions for your access token so that it knows what permissions it has
    [objFBGraph authenticateUserWithCallbackObject:self andSelector:@selector(FBGraphResponse) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins,publish_checkins,email"];
}


- (void)FBGraphResponse
{
    @try 
    {
        if (objFBGraph.accessToken) 
        {
            //SBJSON *jsonparser = [[SBJSON alloc]init];
            //FbGraphResponse *fb_graph_response = [objFBGraph doGraphGet:@"me" withGetVars:nil];
            
           // NSString *resultString = [NSString stringWithString:fb_graph_response.htmlResponse];
            //NSDictionary *dict =  [jsonparser objectWithString:resultString];
           //  NSString *email = [dict objectForKey:@"email"];
            
            // Save user ID in database 
           // DataBaseController *objDBC = [DataBaseController DBControllerharedInstance];
          ///  [objDBC InsertDataIntoFBRegistrationTable:email];
            //
            LoginViewController *objLogin = [[LoginViewController alloc]init];
            [objLogin openTabBarScreenForFacebookLogin];
        }
    }
    @catch (NSException *exception) {
       if(LOGS_ON) NSLog(@"NSException in facebook connection : -> %@",exception);
    }
}



- (void)logOutFaceBookUser{
    
    if(LOGS_ON) NSLog(@"logout");
    
    objFBGraph.accessToken = nil;
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
    //[self loginButtonPressed:nil];
}
@end
