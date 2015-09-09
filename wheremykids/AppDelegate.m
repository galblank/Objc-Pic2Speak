//
//  AppDelegate.m
//  WakeSomeoneUp
//
//  Created by Gal Blank on 8/15/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
            

@end

@implementation AppDelegate

@synthesize username,apnskey,userlocation,userID,familyiID,lastLocation,emergencyNumbers,nGlobalUserCounter,sessionAllowEditing;

AppDelegate *shared = nil;


+ (AppDelegate*)shared
{
    return shared;
}


- (id)init
{
    self = [super init];
    
    shared = self;
    
    [self readUserDefaults];
    
    self.sessionAllowEditing = NO;
    
    return (self);
}

-(NSMutableArray*)readUsers
{
    NSMutableArray *users = [[NSMutableArray alloc] initWithContentsOfFile:USERS_PATH];
    return users;
}

-(void)saveUser:(ProfileModel*)user
{
    NSMutableArray *users = [self readUsers];
    BOOL bFound = NO;
    ProfileModel *oneuser = [[ProfileModel alloc] init];
    int i = 0;
    if(users){
        for(i = 0;i<users.count;i++){
            NSMutableDictionary *_user = users[i];
            [oneuser dicToUser:_user];
            if(oneuser.userID == user.userID){
                oneuser = user;
                NSLog(@"Found existing user. updating");
                bFound = YES;
                break;
            }
        }
    }
    else{
        users = [[NSMutableArray alloc] init];
    }
    
    if(bFound == NO){
        [users addObject:[user userToDic]];
    }
    else{
        [users replaceObjectAtIndex:i withObject:oneuser];
    }
    BOOL bOk = [users writeToFile:USERS_PATH atomically:YES];
    
    NSLog(@"Saved users %d",bOk);
}

-(void)saveUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if(standardUserDefaults)
    {
        [standardUserDefaults setObject:self.nGlobalUserCounter        forKey:USERS_COUNTER_ID];
        [standardUserDefaults synchronize];
    }
    
}

-(void)readUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    self.nGlobalUserCounter  = [standardUserDefaults objectForKey:USERS_COUNTER_ID];
    if(self.nGlobalUserCounter == nil || self.nGlobalUserCounter.intValue == 0){
        self.nGlobalUserCounter = [NSNumber numberWithInt:1];
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self readUserDefaults];
    // Create the Snap Secure View Controller.
    profileVC = [[ProfileSelectionViewController alloc] init];
    mainNavigationController = [[UINavigationController alloc] initWithRootViewController:profileVC];
    mainNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    mainNavigationController.navigationBar.translucent = NO;
    mainNavigationController.navigationBar.barTintColor = themeColor;
    mainNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.window.rootViewController = mainNavigationController;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      NSForegroundColorAttributeName,
     themeColor,
      NSBackgroundColorAttributeName,
      globalFont,
      NSFontAttributeName,
      nil]];
    
    self.window.backgroundColor = [UIColor whiteColor];

    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    int ver_float = [currSysVer intValue];
    if(ver_float >= 8){
    //Right, that is the point
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                         |UIRemoteNotificationTypeSound
                                                                                         |UIRemoteNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else{
    //register to receive notifications
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    
    NSMutableArray *payload = [[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"listParamKey"];
    
    if (payload) {
        NSString *isMessage = [payload objectAtIndex:0];
        if([isMessage boolValue] == YES){
            NSLog(@"Got message");
            NSNumber *userid = [payload objectAtIndex:2];
        }
        else{
            NSLog(@"Trying to find you");

        }
        
    }
    
    // [[CommManager sharedInstance] sendData:@"getemnums" params:nil withDelegate:self];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

- (void)getEmNumsFinishedSuccess:(NSString*)response
{
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    emergencyNumbers = [NSMutableArray arrayWithArray:[jsonParser objectWithString:response]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
    
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    NSString *deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"%lu bytes", (unsigned long)[devToken length]);
    NSLog(@"device token = %@", deviceToken);
    self.apnskey = deviceToken;
    [self saveUserDefaults];
    NSLog(@"APNS: %@",self.apnskey);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
#if (TARGET_IPHONE_SIMULATOR)
    self.apnskey = @"simlator1";
    [self saveUserDefaults];
#endif
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)theEvent {
    
    
}

////////////////OTHER METHODS//////////////////////////
-(void)showActivityViewer:(NSString*)caption :(CGRect)frame
{
    @autoreleasepool {
        if(mWaitingScreen != nil){
            if([mWaitingScreen isCurrentlyActive] == YES){
                return;
            }
            mWaitingScreen = nil;
        }
        
        UIView *topView = nil;
        if (self.window.subviews.count > 0)
        {
            topView =  [self.window.subviews objectAtIndex:0];
        }
        
        mWaitingScreen = [[WaitingScreenView alloc] initWithFrame:frame];
        //        mWaitingScreen.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [mWaitingScreen setCaption:caption];
        if (topView)
        {
            [topView addSubview:mWaitingScreen];
        }
        
        [[[mWaitingScreen subviews] objectAtIndex:0] startAnimating];
        [mWaitingScreen setIsCurrentlyActive:YES];
    }
}


-(void)hideActivityViewer
{
	if(mWaitingScreen != nil){
        [mWaitingScreen setIsCurrentlyActive:NO];
		/*NSMutableArray *views = [mWaitingScreen subviews];
         for(int i=0;i<[views count];i++){
         id  oneView = [views objectAtIndex:i];
         if([oneView isKindOfClass:[UIActivityIndicatorView class]] == YES){
         [oneView stopAnimating];
         }
         }
         //[[[mWaitingScreen subviews] objectAtIndex:0] stopAnimating];*/
		[mWaitingScreen removeFromSuperview];
		mWaitingScreen = nil;
	}
}

@end
