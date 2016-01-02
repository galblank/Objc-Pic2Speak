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

#define systemFont @"ChalkboardSE-Light"
#define PASSCODE @"PASSCODE"
#define USERS_COUNTER_ID        @"USERS_COUNTER_ID"
#define NEW_USER_ID             1000
#define USERS_PATH  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"usersdata"]



@interface AppDelegate : UIResponder <UIApplicationDelegate,CommunicationManagerDelegate,UIImagePickerControllerDelegate>
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
    
    BOOL sessionAllowEditing;
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
@property (nonatomic)BOOL sessionAllowEditing;
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
@end

