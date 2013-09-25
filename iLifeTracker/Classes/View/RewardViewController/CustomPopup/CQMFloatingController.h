//
// CQMFloatingController.h
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

#import <Foundation/Foundation.h>
#import "CommonUtilClass.h"
#import "FbGraph.h"
#import "SBJSON.h"

#import <Accounts/Accounts.h>
#import <Accounts/ACAccount.h>
#import <Accounts/ACAccountStore.h>
#import <Twitter/TWRequest.h>
#import "FbGraphFile.h"



@class CQMFloatingFrameView;
@class CQMFloatingNavigationBar;


@interface CQMFloatingController : UIViewController {
//    NSString *massage;
//    NSString *imageName;
//    short      *selectedImageCounter;
    UIActivityIndicatorView *activityIndicator;
    FbGraph                 *objFBGraph;
    
    bool twtMessageSendIdentify;
    bool FaceBookMessageSendIdentify;
    
    IBOutlet UIButton        *_fbBtn;
    IBOutlet UIButton        *_twtBtn;
    UITextView *smsTextView ;
    bool socialMediaIdentify;
    bool overallIndtify;
}

//@property (nonatomic, retain) NSString *massage;
//@property (nonatomic, retain) NSString *imageName;
//@property (nonatomic) short      *selectedImageCounter;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic) short      selectedImageCounter;
@property (nonatomic, retain) NSString *messageShareOnTwtAndFB;
@property (nonatomic) bool socialMediaIdentify;
@property (nonatomic) bool overallIndtify;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) CGSize landscapeFrameSize;
@property (nonatomic) CGSize portraitFrameSize;
@property (nonatomic, retain) UIColor *frameColor;

+ (CQMFloatingController*)sharedFloatingController;

- (void)showInView:(UIView*)view withContentViewController:(UIViewController*)contentViewController animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;

-(CQMFloatingController *) objCQMFloatingController;
-(void)showAlertForShareFBAndTwitter;
-(void) overAllPopup;
@end
