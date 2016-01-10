//
//  AppDelegate.h
//  WakeSomeoneUp
//
//  Created by Gal Blank on 8/15/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitingScreenView.h"
#import "ProfileSelectionViewController.h"
#import "CommManager.h"
#import "ProfileModel.h"
#import "Pic2Speak-Swift.h"
#import "MessageDispatcher.h"
#import "passcode/PasscodeWindow.h"

#define pastelGreenColor [UIColor colorWithRed:113.0 / 255.0 green:222.0 / 255.0 blue:149.0 / 255.0 alpha:1];
#define pastelBlueColor [UIColor colorWithRed:144.0 / 255.0 green:211.0 / 255.0 blue:245.0 / 255.0 alpha:1];
#define pastelDarkBlueColor [UIColor colorWithRed:102.0 / 255.0 green:142.0 / 255.0 blue:227.0 / 255.0 alpha:1];
#define systemFont @"ChalkboardSE-Light"
#define PASSCODE @"PASSCODE"
#define USERS_COUNTER_ID        @"USERS_COUNTER_ID"
#define NEW_USER_ID             1000
#define USERS_PATH  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"usersdata"]



@interface AppDelegate : UIResponder <UIApplicationDelegate,CommunicationManagerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,PasscodeWindowDelegate>
{
    WaitingScreenView * mWaitingScreen;
    ProfileSelectionViewController *profileVC;
    UINavigationController *mainNavigationController;
    NSString *username;
    NSString *apnskey;
    NSString *userlocation;
    NSString *userID;
    NSString *familyiID;
    UINavigationController *wizardNavController;
    CLLocation *lastLocation;
    UIBackgroundTaskIdentifier bgTaskId;
    NSMutableArray *emergencyNumbers;
    
    NSNumber * nGlobalUserCounter;
    UIButton * adminButton;
    
    PasscodeWindow * passcodeWin;
}
@property (nonatomic,retain) NSNumber * nGlobalUserCounter;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *apnskey;
@property (strong, nonatomic) NSString *userlocation;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *familyiID;
@property (strong, nonatomic) CLLocation *lastLocation;
@property (strong, nonatomic) NSMutableArray *emergencyNumbers;
@property (nonatomic)BOOL isAdmin;
-(void)switchControllers:(UIViewController*)controller;

+ (AppDelegate*)shared;

-(void)saveUserDefaults;
-(void)readUserDefaults;
-(void)showActivityViewer:(NSString*)caption :(CGRect)frame;
-(void)hideActivityViewer;
-(NSMutableArray*)readUsers;
- (void)getEmNumsFinishedSuccess:(NSString*)response;
-(void)saveUser:(ProfileModel*)user;
- (void)selectPhoto;
-(void)chooseImage;

- (void)cancel;
-(void) submitcode:(NSString*)text;
@end

