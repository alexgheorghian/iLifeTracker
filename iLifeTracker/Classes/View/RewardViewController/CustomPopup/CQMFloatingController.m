//
// CQMFloatingController.m
// Created by cocopon on 2011/05/19.
//
// Copyright (c) 2012 cocopon <cocopon@me.com>
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "CQMFloatingController.h"
#import "CQMFloatingContentOverlayView.h"
#import "CQMFloatingFrameView.h"
#import "CQMFloatingMaskControl.h"
#import "CQMFloatingNavigationBar.h"
#import "CQMPathUtilities.h"

#import "PopupViewController.h"
#import "TrackViewController.h"

#define kDefaultMaskColor  [UIColor colorWithWhite:0 alpha:0.5]
#define kDefaultFrameColor [UIColor colorWithRed:0.10f green:0.12f blue:0.16f alpha:1.00f]
#define kDefaultPortraitFrameSize  CGSizeMake(320 - 66, 460 - 66)
#define kDefaultLandscapeFrameSize CGSizeMake(480 - 66, 300 - 66)
#define kFramePadding      5.0f
#define kRootKey           @"root"
#define kShadowColor       [UIColor blackColor]
#define kShadowOffset      CGSizeMake(0, 2.0f)
#define kShadowOpacity     0.70f
#define kShadowRadius      10.0f
#define kAnimationDuration 0.3f


@interface CQMFloatingController()

@property (nonatomic, readonly, retain) UIControl *maskControl;
@property (nonatomic, readonly, retain) CQMFloatingFrameView *frameView;
@property (nonatomic, readonly, retain) UIView *contentView;
@property (nonatomic, readonly, retain) CQMFloatingContentOverlayView *contentOverlayView;
@property (nonatomic, readonly, retain) UINavigationController *navigationController;
@property (nonatomic, retain) UIImageView *shadowView;

//umesh.
//@property (nonatomic, retain) NSString *message;
//@property (nonatomic, retain) NSString *imageName;
//@property (nonatomic) short      selectedImageCounter;
//end

- (void)layoutFrameView;
// Actions
- (void)maskControlDidTouchUpInside:(id)sender;
// Delegates
- (void)floatingMaskControlDidResize:(CQMFloatingFrameView*)frameView;

@end


@implementation CQMFloatingController {
@private
	BOOL presented_;
	CGSize landscapeFrameSize_;
	CGSize portraitFrameSize_;
	// View
	CQMFloatingMaskControl *maskControl_;
	CQMFloatingFrameView *frameView_;
	UIView *contentView_;
	CQMFloatingContentOverlayView *contentOverlayView_;
	UINavigationController *navController_;
	UIViewController *contentViewController_;
}


- (id)init {
	if (self = [super init]) {
		[self setPortraitFrameSize:kDefaultPortraitFrameSize];
		[self setLandscapeFrameSize:kDefaultLandscapeFrameSize];
		[self setFrameColor:kDefaultFrameColor];
	}
	return self;
}


- (void)dealloc {
	[contentViewController_ release];
	[maskControl_ release];
	[frameView_ release];
	[contentView_ release];
	[contentOverlayView_ release];
	[navController_ release];
	[self setShadowView:nil];
	[super dealloc];
}


#pragma mark -
#pragma mark Property


- (CGSize)portraitFrameSize {
	return portraitFrameSize_;
}
- (void)setPortraitFrameSize:(CGSize)portraitFrameSize {
	portraitFrameSize_ = portraitFrameSize;
	[self layoutFrameView];
}


- (CGSize)landscapeFrameSize {
	return landscapeFrameSize_;
}
- (void)setLandscapeFrameSize:(CGSize)landscapeFrameSize {
	landscapeFrameSize_ = landscapeFrameSize;
	[self layoutFrameView];
}


- (UIColor*)frameColor {
	return [self.frameView baseColor];
}
- (void)setFrameColor:(UIColor*)frameColor {
	[self.frameView setBaseColor:frameColor];
	[self.contentOverlayView setEdgeColor:frameColor];
	[self.navigationController.navigationBar setTintColor:frameColor];
}


- (CQMFloatingMaskControl*)maskControl {
	if (maskControl_ == nil) {
		maskControl_ = [[CQMFloatingMaskControl alloc] init];
		[maskControl_ setBackgroundColor:kDefaultMaskColor];
		[maskControl_ setResizeDelegate:self];
		[maskControl_ addTarget:self
						 action:@selector(maskControlDidTouchUpInside:)
			   forControlEvents:UIControlEventTouchUpInside];
	}
	return maskControl_;
}


- (UIView*)frameView {
	if (frameView_ == nil) {
		frameView_ = [[CQMFloatingFrameView alloc] init];
		[frameView_.layer setShadowColor:[kShadowColor CGColor]];
		[frameView_.layer setShadowOffset:kShadowOffset];
		[frameView_.layer setShadowOpacity:kShadowOpacity];
		[frameView_.layer setShadowRadius:kShadowRadius];
	}
	return frameView_;
}


- (UIView*)contentView {
	if (contentView_ == nil) {
		contentView_ = [[UIView alloc] init];
		[contentView_ setClipsToBounds:YES];
	}
	return contentView_;
}


- (CQMFloatingContentOverlayView*)contentOverlayView {
	if (contentOverlayView_ == nil) {
		contentOverlayView_ = [[CQMFloatingContentOverlayView alloc] init];
		[contentOverlayView_ setUserInteractionEnabled:NO];
	}
	return contentOverlayView_;
}


- (UINavigationController*)navigationController {
	if (navController_ == nil) {
		UIViewController *dummy = [[UIViewController alloc] init];
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:dummy];
		[dummy release];
		
		// Archive navigation controller for changing navigationbar class
		[navController navigationBar];
		NSMutableData *data = [[NSMutableData alloc] init];
		NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		[archiver encodeObject:navController forKey:kRootKey];
		[archiver finishEncoding];
		[archiver release];
		[navController release];
		
		// Unarchive it with changing navigationbar class
		NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		[unarchiver setClass:[CQMFloatingNavigationBar class]
				forClassName:NSStringFromClass([UINavigationBar class])];
		navController_ = [[unarchiver decodeObjectForKey:kRootKey] retain];
		[unarchiver release];
		
		[data release];
	}
	return navController_;
}


@synthesize shadowView = shadowView_;


#pragma mark -
#pragma mark Singleton


+ (CQMFloatingController*)sharedFloatingController {
	static CQMFloatingController *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^ {
		instance = [[CQMFloatingController alloc] init];
	});
	return instance;
}

//
@synthesize message,imageName,selectedImageCounter,messageShareOnTwtAndFB,socialMediaIdentify,activityIndicator,overallIndtify;
#pragma mark -

//static bool overAllPopupDisplay;

- (void)showInView:(UIView*)view withContentViewController:(UIViewController*)viewController animated:(BOOL)animated {
	@synchronized(self) {
		if (presented_) {
			return;
		}
		presented_ = YES;
	}
	
	[self.view setAlpha:0];
	
	if (contentViewController_ != viewController) {
		[[contentViewController_ view] removeFromSuperview];
		[contentViewController_ release];
		contentViewController_ = [viewController retain];

		NSArray *viewControllers = [NSArray arrayWithObject:contentViewController_];
		[self.navigationController setViewControllers:viewControllers];
        
        //
        UIImageView *star1 = [[UIImageView alloc] initWithFrame:CGRectMake(75, 40, 27, 26)];
        star1.image = [UIImage imageNamed:@"pop_up_white_star_ipad.png"];
        [self.view addSubview:star1];
        
        UIImageView *star2 = [[UIImageView alloc] initWithFrame:CGRectMake(112, 40, 27, 26)];
        star2.image = [UIImage imageNamed:@"pop_up_white_star_ipad.png"];
        [self.view addSubview:star2];
        
        UIImageView *star3 = [[UIImageView alloc] initWithFrame:CGRectMake(149, 40, 27, 26)];
        star3.image = [UIImage imageNamed:@"pop_up_white_star_ipad.png"];
        [self.view addSubview:star3];
        
        UIImageView *star4 = [[UIImageView alloc] initWithFrame:CGRectMake(186, 40, 27, 26)];
        star4.image = [UIImage imageNamed:@"pop_up_white_star_ipad.png"];
        [self.view addSubview:star4];
        
        UIImageView *star5 = [[UIImageView alloc] initWithFrame:CGRectMake(223, 40, 27, 26)];
        star5.image = [UIImage imageNamed:@"pop_up_white_star_ipad.png"];
        [self.view addSubview:star5];
        
        
        UIImageView *categoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(123, 70, 80, 80)];
        categoryImage.image = [UIImage imageNamed:imageName];
        [self.view addSubview:categoryImage];
        
        for (int i = 0; i < selectedImageCounter; i++) {
            if (i == 0) {
                star1.image = [UIImage imageNamed:@"golden_star.png"];
            } else if(i== 1){
               star2.image = [UIImage imageNamed:@"golden_star.png"];   
            }else if(i== 2){
                star3.image = [UIImage imageNamed:@"golden_star.png"];   
            }else if(i== 3){
                star4.image = [UIImage imageNamed:@"golden_star.png"];   
            }else if(i== 4){
                star5.image = [UIImage imageNamed:@"golden_star.png"];   
            }
        }
        //
        if (smsTextView) {
            [smsTextView removeFromSuperview];
            smsTextView = nil;
        }
        smsTextView = [[UITextView alloc] initWithFrame:CGRectMake(65, 160, 200, 100)];
        smsTextView.text = message;
        //smsTextView.backgroundColor= [UIColor redColor];
        smsTextView.editable = NO;
        smsTextView.scrollEnabled = NO;
        smsTextView.backgroundColor = [UIColor clearColor];

        [self.view addSubview:smsTextView];
        
        
        //modify by umesh.
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(45, 20, 22, 22)];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        
        [closeBtn addTarget:self 
                     action:@selector(closePopup) 
           forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeBtn];
        
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 230, 90, 34)];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"share_to.png"] forState:UIControlStateNormal];
        
        [shareBtn addTarget:self 
                      action:@selector(shareSocialMidea) 
            forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareBtn];
        
        _fbBtn = [[UIButton alloc] initWithFrame:CGRectMake(173, 230, 35, 35)];
        [_fbBtn setBackgroundImage:[UIImage imageNamed:@"fb.png"] forState:UIControlStateNormal];
        
        [_fbBtn addTarget:self 
                      action:@selector(fbShare) 
            forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_fbBtn];
        //
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(173, 230, 35, 35)];
        //activityIndicator.color = [UIColor redColor];
        [self.view addSubview:activityIndicator];
        activityIndicator.hidden = YES;
        
        _twtBtn = [[UIButton alloc] initWithFrame:CGRectMake(221, 230, 35, 35)];
        [_twtBtn setBackgroundImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
        
        [_twtBtn addTarget:self 
                      action:@selector(twtShare) 
            forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_twtBtn];
        
	}
    
   

	
	[self.view setFrame:[view bounds]];
	[view addSubview:[self view]];
	
	[self layoutFrameView];
	
	__block CQMFloatingController *me = self;
	[UIView animateWithDuration:(animated ? kAnimationDuration : 0)
					 animations:
	 ^(void) {
		 [me.view setAlpha:1.0f];
	 }];
    
    //overAllPopupDisplay = YES;
}

//custom method (umesh)
-(void) closePopup{
    [self dismissAnimated:YES];
   
    //[self overAllPopup];
    if(!overallIndtify){
         NSLog(@"dismiss ");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginComplete" object:nil];
         //overAllPopupDisplay = NO;
    }
   

}





-(void) overAllPopup{
    
    
    //
    DataBaseController *obj = [DataBaseController DBControllerharedInstance];
    
    // rewardDataArray = [obj selectRewardMessageDataCategoryName];
    long totalTime = [obj totalTimeAllOver];
    NSMutableArray *rewardDataArrayStartic = [obj selectRewardMessageDataCategoryName];
    
    NSArray *intervalArray = nil;
    short numberofStarSelected;
    NSString *imageName1;
    
    for (RwardMessageModel *objRewardSMS in rewardDataArrayStartic) {
        //NSLog(@"reward message data category name Track Cell :-> %@", objRewardSMS.starCount);
        if ([@"Overall" isEqualToString:objRewardSMS.categoryName]) {
            if(LOGS_ON)  NSLog(@"reward message data category name Track Cell :-> %@", objRewardSMS.categoryName);
            //if(LOGS_ON)  NSLog(@"ctegory :-> %@", categoryName1);
            if(LOGS_ON) NSLog(@"reward message data category name Track Cell :-> %@", objRewardSMS.rewardInterval);
            if(LOGS_ON) NSLog(@"reward message data category name Track Cell :-> %@", objRewardSMS.starCount);
            numberofStarSelected = [ objRewardSMS.starCount intValue];
            imageName1            = objRewardSMS.rewardImage;
            intervalArray = [objRewardSMS.rewardInterval componentsSeparatedByString:@","]; 
            
        }
        
    }
    
    short totalStar = 0;
    int totalTimeForTotalStar;
    for (NSString *str in intervalArray) {
        int interval = [str intValue]*1;
        // if(LOGS_ON)  NSLog(@"totalTime  :-> %ld",totalTime);
        //if(LOGS_ON)   NSLog(@"interval  :-> %i",interval);
        if(totalTime  <= interval)
        {
            break;
        }
        totalTimeForTotalStar = [str intValue];
        totalStar++;
    }
    
    NSString *messageShare;
    NSString *shareOnShocialMidea;
    
    for (RwardMessageModel *objRewardSMS in rewardDataArrayStartic) {
        //NSLog(@"reward message data category name Track Cell :-> %@", objRewardSMS.starCount);
        if ([@"Overall" isEqualToString:objRewardSMS.categoryName]) {
            // PopupViewController *objPopup = [[PopupViewController alloc] init];
            if (totalStar == 1) {
                messageShare = objRewardSMS.rewardMessage1;
                
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  Overall category for tracking %i hours of activitiy.",totalStar,totalTimeForTotalStar];
                //NSString *str1 = [str stringByAppendingFormat:@"star of the %",categoryName1];
                //NSString *str1 = [@" star of the " stringByAppendingFormat:@"%",categoryName1];
                
                //=@"I just unlocked the 3rd star of the Sports category for tracking 50 hours of activitiy.";
                // NSLog(@"message 1 :-> %@ :-> %@",messageShare,shareOnShocialMidea);
                break;
            }else if (totalStar == 2) {
                messageShare = objRewardSMS.rewardMessage2;
                
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  Overall category for tracking %i hours of activitiy.",totalStar,totalTimeForTotalStar];
                //  NSLog(@"message 2 :-> %@ :-> %@",messageShare,shareOnShocialMidea);
                break;
            }else if (totalStar == 3) {
                messageShare = objRewardSMS.rewardMessage3;
                
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  Overall category for tracking %i hours of activitiy.",totalStar,totalTimeForTotalStar];
                //NSLog(@"message 3:-> %@ :-> %@",messageShare,shareOnShocialMidea);
                break;
            }else if (totalStar == 4) {
                messageShare = objRewardSMS.rewardMessage4;
                
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  Overall category for tracking %i hours of activitiy.",totalStar,totalTimeForTotalStar];
                NSLog(@"message 4:-> %@ :-> %@",messageShare,shareOnShocialMidea);
                break;
            }else if (totalStar == 5) {
                messageShare = objRewardSMS.rewardMessage4;
                
                shareOnShocialMidea= [@"I just unlocked the " stringByAppendingFormat:@"%i star of the  Overall category for tracking %i hours of activitiy.",totalStar,totalTimeForTotalStar];
                // NSLog(@"message 5:-> %@ :-> %@",messageShare,shareOnShocialMidea); 
                break;
                
            }
        }
    }
    
    
    //NSLog(@"numberofStarSelectedr  :-> %i",numberofStarSelected);
    //  NSLog(@"totalStar  :-> %i",totalStar);
    
    if((numberofStarSelected < totalStar)){ //|| (  totalStar < numberofStarSelected)){
        PopupViewController *demoViewController = [[PopupViewController alloc] init];
        
        // 2. Get shared floating controller
        CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
        
        floatingController.selectedImageCounter  = totalStar; 
        floatingController.imageName = imageName1;
        floatingController.message = messageShare;
        floatingController.messageShareOnTwtAndFB = shareOnShocialMidea;
        floatingController.socialMediaIdentify = NO;
        [floatingController showInView:[TrackViewController TrackSharedInstance].view
             withContentViewController:demoViewController
                              animated:YES];
        //  [obj updateRewardStarCountCatregoryName:categoryName1 trackerSetion:[NSString stringWithFormat:@"%i",totalStar]];
    }
    
    
}
















//-(void)shareSocialMidea{
//    NSLog(@"shareSocialMidea ");
//}
//
//-(void) fbShare{
//    NSLog(@"fbShare ");
//}
// 
//-(void) twtShare{
//     NSLog(@"twtShare ");
//}





//**********************************************
#define FBNORMALBTN              @"fb.png"
#define FBSELECTEDBTN            @"fb_Sel.png"
#define TWTNORMALBTN             @"twitter_sel.png"
#define TWTSELECTEDBTN           @"twitter.png"


static bool fbBoolValue = YES;
static bool twtBoolValue = YES;
static bool faceBookTwitterAlertIdentifier = YES;

-(void) fbShare{
    // UIButton *fbButton;
    NSURL        *requestUrl = [NSURL URLWithString:@"http://www.google.com"];
    // NSURLRequest *requestObj = [NSURLRequest requestWithURL:requestUrl];
    NSData       *loadTest   = [NSData dataWithContentsOfURL:requestUrl];
    
    //    if (loadTest == nil) {
    //        NSLog(@"No internet");
    //    } else {
    //        NSLog(@"Yes internet");
    //    }
    [_fbBtn setBackgroundImage:[UIImage imageNamed:FBSELECTEDBTN] forState:UIControlStateNormal];
    if(loadTest != nil){
        if (fbBoolValue) {
            [_fbBtn setSelected:YES];
            //[_fbBtn setBackgroundImage:[UIImage imageNamed:FBSELECTEDBTN] forState:UIControlStateSelected];
            fbBoolValue = NO; 
            //NSLog(@"select facebook ");
            
            objFBGraph = [[FbGraph alloc]initWithFbClientID:FbClientID];
            //mark some permissions for your access token so that it knows what permissions it has
            [objFBGraph authenticateUserWithCallbackObject:self andSelector:@selector(FBGraphResponse) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins,publish_checkins,email"];
            activityIndicator.hidden = NO;
            // activityIndicator =[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 200, 100, 100)];
            //activityIndicator = CGRectMake(200, 50, 100, 100);
            activityIndicator.color = [UIColor redColor];
            //[self.view addSubview:activityIndicator];
            [activityIndicator startAnimating];
            //NSLog(@" shareFaceBook  selected");
            
        } else{
            [_fbBtn setSelected:NO];
            [_fbBtn setBackgroundImage:[UIImage imageNamed:FBNORMALBTN] forState:UIControlStateNormal];
            fbBoolValue = YES;   
        }
    }else {
        CommonUtilClass *obj = [CommonUtilClass CommonUtilSharedInstance];
        [obj  showAlertView:@"NO internet" title:@"Share"];
    }
    
}



- (void)FBGraphResponse
{
    @try 
    {
        if (objFBGraph.accessToken) 
        {
            [activityIndicator stopAnimating];
            activityIndicator.hidden = YES;
           // NSLog(@" verify fb account ");
        }
    }
    @catch (NSException *exception) {
        
        activityIndicator.hidden = YES;
        [activityIndicator stopAnimating];
       // NSLog(@"NSException in facebook connection : -> %@",exception);
    }
    //NSLog(@"token acess problem :-> %@",objFBGraph.accessToken);
}



#define UPDATE_WITH_MEDIA_TWITTER @"https://upload.twitter.com/1/statuses/update_with_media.json"
#define UPDATE_WITH_TEXT_TWITTER @"https://api.twitter.com/1/statuses/update.json"

-(void) twtShare{
    
    if (twtBoolValue) {
        //   NSLog(@" sharetwitter  selected");
        [_twtBtn setSelected:YES];
        [_twtBtn setBackgroundImage:[UIImage imageNamed:TWTNORMALBTN] forState:UIControlStateSelected];
        twtBoolValue = NO; 
        
        
    }else{
        
        [_twtBtn setSelected:NO];
          [_twtBtn setBackgroundImage:[UIImage imageNamed:TWTSELECTEDBTN ] forState:UIControlStateNormal];
        twtBoolValue = YES; 
    }
}

-(void)shareSocialMidea{
    NSURL        *requestUrl = [NSURL URLWithString:@"http://www.google.com"];
    // NSURLRequest *requestObj = [NSURLRequest requestWithURL:requestUrl];
    NSData       *loadTest   = [NSData dataWithContentsOfURL:requestUrl];
    
    //    if (loadTest == nil) {
    //        NSLog(@"No internet");
    //    } else {
    //        NSLog(@"Yes internet");
    //    }
    if(loadTest != nil){
        
        
        
        if (!twtBoolValue) {
            // NSLog(@" twtBoolValue  selected"); 
            
            
            ACAccountStore *account = [[ACAccountStore alloc] init];
            ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            
            // Request access from the user to access their Twitter account
            [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error)
             {
                 twtMessageSendIdentify = NO; 
                 // Did user allow us access?
                 if (granted == YES)
                 {
                     //twiterAlertIdentify = YES;
                     // Populate array with all available Twitter accounts
                     NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                     
                     // Sanity check
                     if ([arrayOfAccounts count] > 0){
                         
                         if(LOGS_ON) NSLog(@" user login with twitter");
                         
                         // Keep it simple, use the first account available
                         ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                         
                         // Build a twitter request
                         TWRequest *postRequest = nil; 
                         NSData *myData = nil;
                         
                         UIImage *image = [UIImage imageNamed:imageName];
                         
                         if(image )
                         {
                             postRequest = [[TWRequest alloc] initWithURL: [NSURL URLWithString:UPDATE_WITH_MEDIA_TWITTER] parameters:nil requestMethod:TWRequestMethodPOST];
                             
                             myData = UIImagePNGRepresentation(image);
                             [postRequest addMultiPartData:myData withName:@"media" type:@"image/png"];
                         }
                         else
                         {
                             postRequest = [[TWRequest alloc] initWithURL:  [NSURL URLWithString:UPDATE_WITH_TEXT_TWITTER] parameters:nil requestMethod:TWRequestMethodPOST];
                         }
                         myData = [messageShareOnTwtAndFB dataUsingEncoding:NSUTF8StringEncoding];
                         [postRequest addMultiPartData:myData withName:@"status" type:@"text/plain"];
                         
                         
                         // Post the request
                         [postRequest setAccount:acct];
                         
                         // Block handler to manage the response
                         [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                          {
                              if(LOGS_ON) NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
                              if (responseData)
                              {
                                  // Parse the JSON response
                                  NSError *jsonError = nil;
                                  //id resp = [NSJSONSerialization JSONObjectWithData:responseData
                                           //                                 options:0
                                           //                                   error:&jsonError];
                                  if (jsonError) {
                                      if(LOGS_ON)  NSLog(@"Json Parsing Error :%@", [jsonError localizedDescription]);
                                      twtMessageSendIdentify = NO;
                                  }
                                  else{
                                      //  NSLog(@"JSON RESPONSE AFTER UPLOAD ->%@",resp);
                                      twtMessageSendIdentify = YES;
                                      
                                      if (fbBoolValue) {
                                         [self performSelectorOnMainThread:@selector(showAlertForShareFBAndTwitter) withObject:nil waitUntilDone:NO];
                                          // NSLog(@"message send on twtBoolValue");
                                      }else{
                                          if(faceBookTwitterAlertIdentifier){
                                              faceBookTwitterAlertIdentifier = NO; 
                                          }else{
                                             [self performSelectorOnMainThread:@selector(showAlertForShareFBAndTwitter) withObject:nil waitUntilDone:NO];
                                          }
                                      }
                                      
                                  }}}];
                     }
                 } else{
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]]; 
                     //twiterAlertIdentify = NO;
                 }
             }];
            
            //  [self showAlertForShareFBAndTwitter];  
            
        } else if(twtBoolValue){
            //NSLog(@" twtBoolValue not selected");  
            twtMessageSendIdentify = NO; 
            //[self showAlertForShareFBAndTwitter];
            
        }
        if (fbBoolValue) {
            if(LOGS_ON)  NSLog(@" facebook  selected");
            FaceBookMessageSendIdentify = NO;
        }else if(!fbBoolValue){
            
            //            NSMutableDictionary *variable = [[NSMutableDictionary alloc]initWithCapacity:1];
            //            [variable setObject:message forKey:@"message"];
            //            [objFBGraph doGraphPost:@"me/feed" withPostVars:variable];  
//            NSMutableDictionary *variable = [[NSMutableDictionary alloc]initWithCapacity:1];
//            [variable setObject:messageShareOnTwtAndFB forKey:@"message"];
//            [objFBGraph doGraphPost:@"me/feed" withPostVars:variable];
            //NSLog(@"message send on face book");
            
            NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:2];
            
            //create a UIImage (you could use the picture album or camera too)
            // NSLog(@" image name :-> %@", imageNameShare);
            UIImage *picture = [UIImage imageNamed:imageName];
            //create a FbGraphFile object insance and set the picture we wish to publish on it
            FbGraphFile *graph_file = [[FbGraphFile alloc] initWithImage:picture];
            
            //finally, set the FbGraphFileobject onto our variables dictionary....
            [variables setObject:graph_file forKey:@"file"];
            
            [variables setObject:messageShareOnTwtAndFB forKey:@"message"];
            
            //the fbGraph object is smart enough to recognize the binary image data inside the FbGraphFile
            //object and treat that is such.....
            //FbGraphResponse *fb_graph_response = [fbGraph doGraphPost:@"117795728310/photos" withPostVars:variables];
            [objFBGraph doGraphPost:@"me/photos" withPostVars:variables];
            
            
            
            FaceBookMessageSendIdentify = YES;
            if (twtBoolValue) {
                [self performSelectorOnMainThread:@selector(showAlertForShareFBAndTwitter) withObject:nil waitUntilDone:NO];
                // NSLog(@"message send on twtBoolValue");
            }else{
                if(faceBookTwitterAlertIdentifier){
                    faceBookTwitterAlertIdentifier = NO; 
                }else{
                    [self performSelectorOnMainThread:@selector(showAlertForShareFBAndTwitter) withObject:nil waitUntilDone:NO];         }
            }
        }
    }else {
        CommonUtilClass *obj = [CommonUtilClass CommonUtilSharedInstance];
        [obj  showAlertView:@"NO internet" title:@"Share"];
        
    }
    
    //[NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(showAlert) userInfo:nil repeats:NO];
}


//-(void) showAlert{
//   // NSLog(@"*****************  showAlert");
//    [self showAlertForShareFBAndTwitter];
//}



-(void)showAlertForShareFBAndTwitter{
   // shareCounter ++;
    //NSLog(@"***************** after twitter");
    NSString *messageText;
    if ((twtMessageSendIdentify) && (FaceBookMessageSendIdentify)) {
        messageText = @"Tracker details successfully shared on Facebook and Twitter"; 
        CommonUtilClass *obj = [CommonUtilClass CommonUtilSharedInstance];
        [obj  showAlertView:messageText title:@"Share"]; 
    }
    else if (twtMessageSendIdentify) {
        messageText = @"Tracker details successfully shared on Twitter";
        CommonUtilClass *obj = [CommonUtilClass CommonUtilSharedInstance];
        [obj  showAlertView:messageText title:@"Share"]; 
        // NSLog(@"share tracker detail on social media ");
    }else if(FaceBookMessageSendIdentify){
        messageText = @"Tracker details successfully shared on Facebook";
        CommonUtilClass *obj = [CommonUtilClass CommonUtilSharedInstance];
        [obj  showAlertView:messageText title:@"Share"];
    }
    faceBookTwitterAlertIdentifier = YES;
}


//**************************************************























- (void)dismissAnimated:(BOOL)animated {
	__block CQMFloatingController *me = self;
	[UIView animateWithDuration:(animated ? kAnimationDuration : 0)
					 animations:
	 ^(void) {
		[me.view setAlpha:0];
	 }
					 completion:
	 ^(BOOL finished) {
		 if (finished) {
			 [me.view removeFromSuperview];
			 presented_ = NO;
		 }
	 }];
}


- (void)layoutFrameView {
	// Frame
	CGSize maskSize = [self.maskControl frame].size;
	BOOL isPortrait = (maskSize.width <= maskSize.height);
	CGSize frameSize = isPortrait ? [self portraitFrameSize] : [self landscapeFrameSize];
	CGSize viewSize = [self.view frame].size;
	UIView *frameView = [self frameView];
	[frameView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
    //modify by umesh.
	[frameView setFrame:CGRectMake(round((viewSize.width - frameSize.width) / 2),
								   round((viewSize.height - frameSize.height) / 2),
								   0,
								   0)];
    //modification end
    
	[frameView setNeedsDisplay];
	
	// Content
    //modify by umesh.
    CGRect contentFrame;
	UIView *contentView = [self contentView];
    if (socialMediaIdentify) {
        contentFrame = CGRectMake(19, -20,
                                  220,
                                  300);
    }else{
	 contentFrame = CGRectMake(19, 0,
									 220,
									 300);
    }
    //modification end
    
	CGSize contentSize = contentFrame.size;
	[contentView setFrame:contentFrame];
	
	// Navigation
	UIView *navView = [self.navigationController view];
	CGFloat navBarHeight = [self.navigationController.navigationBar sizeThatFits:[contentView bounds].size].height;
	[navView setFrame:CGRectMake(0, 0,
								 contentSize.width, contentSize.height)];
	[self.navigationController.navigationBar setFrame:CGRectMake(0, 0,
																 contentSize.width, navBarHeight)];
	
	// Content overlay
	UIView *contentOverlay = [self contentOverlayView];
	CGFloat contentFrameWidth = [CQMFloatingContentOverlayView frameWidth];
	[contentOverlay setFrame:CGRectMake(contentFrame.origin.x - contentFrameWidth,
										contentFrame.origin.y + navBarHeight - contentFrameWidth,
										contentSize.width  + contentFrameWidth * 2,
										contentSize.height - navBarHeight + contentFrameWidth * 2)];
	[contentOverlay setNeedsDisplay];
	[contentOverlay.superview bringSubviewToFront:contentOverlay];
	
	// Shadow
	CGFloat radius = [self.frameView cornerRadius];
	CGPathRef shadowPath = CQMPathCreateRoundingRect(CGRectMake(0, 0,
																frameSize.width, frameSize.height),
													 radius, radius, radius, radius);
	[frameView.layer setShadowPath:shadowPath];
	CGPathRelease(shadowPath);
}


#pragma mark -
#pragma mark Actions


- (void)maskControlDidTouchUpInside:(id)sender {
	//[self dismissAnimated:YES];
}

-(CQMFloatingController *) objCQMFloatingController{
    return self;
}

#pragma mark -
#pragma mark Delegates


- (void)floatingMaskControlDidResize:(CQMFloatingFrameView*)frameView {
	[self layoutFrameView];
}


#pragma mark -
#pragma mark UIViewController
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

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor clearColor]];
	
	UIView *maskControl = [self maskControl];
	CGSize viewSize = [self.view frame].size;
	[maskControl setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
    
   
	[maskControl setFrame:CGRectMake(0, 0,
									 viewSize.width, viewSize.height)];
    
	[self.view addSubview:maskControl];
    
	
	[self.view addSubview:[self frameView]];
	[self.frameView addSubview:[self contentView]];
	[self.contentView addSubview:[self.navigationController view]];
	[self.frameView addSubview:[self contentOverlayView]];
}




@end
