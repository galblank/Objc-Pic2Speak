//
//  StudentProfileViewController.m
//  Pic2Speak
//
//  Created by Gal Blank on 10/28/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "StudentProfileViewController.h"
#import "PortViewController.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>
#import "Globals.h"

@interface StudentProfileViewController ()

@end

@implementation StudentProfileViewController

@synthesize userprofile;


-(BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger) supportedInterfaceOrientations
{
    //Because your app is only landscape, your view controller for the view in your
    // popover needs to support only landscape
    return UIInterfaceOrientationMaskLandscape;
}


-(void)askForPermissions
{
    NSLog(@"Asking user for location permissions");

    
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled %d",[CLLocationManager authorizationStatus]);
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            if(locationManager == nil){
                locationManager = [[CLLocationManager alloc] init];
            }
            [locationManager requestAlwaysAuthorization];
        }
    }
}

-(void)saveUser
{
    if(userprofile.userID == NEW_USER_ID){
        userprofile.userID = [AppDelegate shared].nGlobalUserCounter.intValue + 1;
        [AppDelegate shared].nGlobalUserCounter = [NSNumber numberWithInt:([AppDelegate shared].nGlobalUserCounter.intValue + 1)];
        [[AppDelegate shared] saveUserDefaults];
    }
    userprofile.username = studentnameTF.text;
    userprofile.userage = [NSNumber numberWithInt:[studentageTF.text intValue]];
    [[AppDelegate shared] saveUser:userprofile];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self askForPermissions];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveUser)];
    if(userprofile == nil){
        userprofile = [[ProfileModel alloc] init];
    }
    UIImage *userImage = [UIImage imageNamed:userprofile.userimage];
    
    userimageview = [[UIImageView alloc] initWithFrame:CGRectMake(5,5,[UIImage imageNamed:@"defaultuser"].size.width,[UIImage imageNamed:@"defaultuser"].size.height)];
    userimageview.tag = userprofile.userID;
    userimageview.userInteractionEnabled = YES;
    
    if(userprofile.userID != NEW_USER_ID){
        userimageview.image = userImage;
    }
    else{
        userimageview.layer.borderColor = themeColor.CGColor;
        userimageview.layer.borderWidth = 2.0;
        userimageview.layer.cornerRadius = 10.0;
    }

    UIImageView *smileImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, [UIImage imageNamed:@"smile"].size.width,  [UIImage imageNamed:@"smile"].size.height)];
    smileImage.image = [UIImage imageNamed:@"smile"];
    
    [userimageview addSubview:smileImage];
    
    
    UIButton *userProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userProfileButton.frame = CGRectMake(userimageview.frame.size.width - [UIImage imageNamed:@"selectpicture"].size.width - 5,userimageview.frame.size.height - [UIImage imageNamed:@"selectpicture"].size.height - 5,[UIImage imageNamed:@"selectpicture"].size.width, [UIImage imageNamed:@"selectpicture"].size.height);
    [userProfileButton addTarget:self action:@selector(chooseImageSource:) forControlEvents:UIControlEventTouchUpInside];
    [userProfileButton setBackgroundImage:[UIImage imageNamed:@"selectpicture"] forState:UIControlStateNormal];
    userProfileButton.tag = userprofile.userID;
    userProfileButton.layer.cornerRadius = 10.0;
    [userProfileButton.layer setMasksToBounds:YES];
    [userimageview addSubview:userProfileButton];
    [self.view addSubview:userimageview];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userimageview.frame.size.width + 10, 5, self.view.frame.size.width - (userimageview.frame.size.width + 10), 30)];
    nameLabel.text = NSLocalizedString(@"Kid's name", nil);
    nameLabel.font = [UIFont fontWithName:themeFontName size:13];
    nameLabel.textColor = themeColor;
    [self.view addSubview:nameLabel];
    
    studentnameTF = [[UITextField alloc] initWithFrame:CGRectMake(userimageview.frame.size.width + 10,nameLabel.frame.origin.y + nameLabel.frame.size.height, self.view.frame.size.width - (userimageview.frame.size.width + 10) - 10, 30)];
    studentnameTF.borderStyle = UITextBorderStyleNone;
    studentnameTF.layer.borderColor = themeColor.CGColor;
    studentnameTF.layer.borderWidth = 0.5;
    studentnameTF.textColor = themeColor;
    studentnameTF.textAlignment = NSTextAlignmentLeft;
    studentnameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    studentnameTF.font = [UIFont fontWithName:themeFontName size:17];
    NSString *firstNamePlaceholder = NSLocalizedString(@"Kid's name", nil);
    studentnameTF.placeholder = firstNamePlaceholder;
    studentnameTF.backgroundColor = [UIColor clearColor];
    studentnameTF.autocorrectionType = UITextAutocorrectionTypeNo;
    studentnameTF.autocapitalizationType = UITextAutocapitalizationTypeWords;
    studentnameTF.returnKeyType = UIReturnKeyNext;
    studentnameTF.keyboardType  = UIKeyboardTypeEmailAddress;
    studentnameTF.keyboardAppearance = UIKeyboardAppearanceLight;
    studentnameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    studentnameTF.tag = 1;
    studentnameTF.delegate = self;
    [self.view addSubview:studentnameTF];
    [studentnameTF becomeFirstResponder];
    
    
    
    UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(userimageview.frame.size.width + 10,studentnameTF.frame.origin.y + studentnameTF.frame.size.height + 5, self.view.frame.size.width - (userimageview.frame.size.width + 10), 30)];
    ageLabel.text = NSLocalizedString(@"Kid's age", nil);
    ageLabel.font = [UIFont fontWithName:themeFontName size:13];
    ageLabel.textColor = themeColor;
    [self.view addSubview:ageLabel];
    
    studentageTF = [[UITextField alloc] initWithFrame:CGRectMake(userimageview.frame.size.width + 10,ageLabel.frame.origin.y + ageLabel.frame.size.height + 5, self.view.frame.size.width - (userimageview.frame.size.width + 10) - 10, 30)];
    studentageTF.borderStyle = UITextBorderStyleNone;
    studentageTF.textColor = themeColor;
    studentageTF.layer.borderColor = themeColor.CGColor;
    studentageTF.layer.borderWidth = 0.5;
    studentageTF.textAlignment = NSTextAlignmentLeft;
    studentageTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    studentageTF.font = [UIFont fontWithName:themeFontName size:17];;
    studentageTF.placeholder = NSLocalizedString(@"Kid's age", nil);;
    studentageTF.backgroundColor = [UIColor clearColor];
    studentageTF.autocorrectionType = UITextAutocorrectionTypeNo;
    studentageTF.autocapitalizationType = UITextAutocapitalizationTypeWords;
    studentageTF.returnKeyType = UIReturnKeyNext;
    studentageTF.keyboardType  = UIKeyboardTypeNumberPad;
    studentageTF.keyboardAppearance = UIKeyboardAppearanceLight;
    studentageTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    studentageTF.tag = 1;
    studentageTF.delegate = self;
    [self.view addSubview:studentageTF];
    
    
    UILabel *teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(userimageview.frame.size.width + 10,studentageTF.frame.origin.y + studentageTF.frame.size.height + 5, self.view.frame.size.width - (userimageview.frame.size.width + 10), 30)];
    teacherLabel.text = NSLocalizedString(@"Teacher / Parent name", nil);
    teacherLabel.font = [UIFont fontWithName:themeFontName size:13];
    teacherLabel.textColor = themeColor;
    [self.view addSubview:teacherLabel];
    
    teachernameTF = [[UITextField alloc] initWithFrame:CGRectMake(userimageview.frame.size.width + 10,teacherLabel.frame.origin.y + teacherLabel.frame.size.height + 5, self.view.frame.size.width - (userimageview.frame.size.width + 10) - 10, 30)];
    teachernameTF.borderStyle = UITextBorderStyleNone;
    teachernameTF.textColor = themeColor;
    teachernameTF.layer.borderColor = themeColor.CGColor;
    teachernameTF.layer.borderWidth = 0.5;
    teachernameTF.textAlignment = NSTextAlignmentLeft;
    teachernameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    teachernameTF.font = [UIFont fontWithName:themeFontName size:17];;
    teachernameTF.backgroundColor = [UIColor clearColor];
    teachernameTF.autocorrectionType = UITextAutocorrectionTypeNo;
    teachernameTF.autocapitalizationType = UITextAutocapitalizationTypeWords;
    teachernameTF.returnKeyType = UIReturnKeyNext;
    teachernameTF.keyboardType  = UIKeyboardTypeAlphabet;
    teachernameTF.keyboardAppearance = UIKeyboardAppearanceLight;
    teachernameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    teachernameTF.tag = 1;
    teachernameTF.delegate = self;
    [self.view addSubview:teachernameTF];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(userimageview.frame.size.width + 10,teachernameTF.frame.origin.y + teachernameTF.frame.size.height + 5, self.view.frame.size.width - (userimageview.frame.size.width + 10), 30)];
    locationLabel.text = NSLocalizedString(@"Kid's location", nil);
    locationLabel.font = [UIFont fontWithName:themeFontName size:13];
    locationLabel.textColor = themeColor;
    [self.view addSubview:locationLabel];
    
    studentlocationTF = [[UITextField alloc] initWithFrame:CGRectMake(userimageview.frame.size.width + 10,locationLabel.frame.origin.y + locationLabel.frame.size.height + 5, self.view.frame.size.width - (userimageview.frame.size.width + 10) - 10, 30)];
    studentlocationTF.borderStyle = UITextBorderStyleNone;
    studentlocationTF.textColor = themeColor;
    studentlocationTF.layer.borderColor = themeColor.CGColor;
    studentlocationTF.layer.borderWidth = 0.5;
    studentlocationTF.textAlignment = NSTextAlignmentLeft;
    studentlocationTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    studentlocationTF.font = [UIFont fontWithName:themeFontName size:17];;
    studentlocationTF.backgroundColor = [UIColor clearColor];
    studentlocationTF.autocorrectionType = UITextAutocorrectionTypeNo;
    studentlocationTF.autocapitalizationType = UITextAutocapitalizationTypeWords;
    studentlocationTF.returnKeyType = UIReturnKeyNext;
    studentlocationTF.keyboardType  = UIKeyboardTypeAlphabet;
    studentlocationTF.keyboardAppearance = UIKeyboardAppearanceLight;
    studentlocationTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    studentlocationTF.tag = 1;
    studentlocationTF.delegate = self;
    [self.view addSubview:studentlocationTF];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    
    if([CLLocationManager  locationServicesEnabled] == YES)
    {
        NSLog(@"SnapLocationService:initSelf Location Services Are enabled");
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        locationManager.pausesLocationUpdatesAutomatically = YES;
        [locationManager startUpdatingLocation];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chooseImageSource:(UIButton*)sender
{
    
    UIActionSheet *photoTypeAlert = nil;

    if([userprofile.userimage caseInsensitiveCompare:@"defaultuser"] != NSOrderedSame)
    {
        // only if user has a profile pic show remove pic option
        photoTypeAlert = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:NSLocalizedString(@"Choose existing", nil),NSLocalizedString(@"Take a photo", nil),NSLocalizedString(@"Remove photo", nil), nil];
    }
    else
    {
        photoTypeAlert = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:NSLocalizedString(@"Choose existing", nil),NSLocalizedString(@"Take a photo", nil), nil];
        
    }
    [photoTypeAlert showInView:self.view];
}
#pragma mark -
#pragma mark Picker delegate methods
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"[AvatarUploadViewController] -didFinishPickingMediaWithInfo-");
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if(userprofile.userID == NEW_USER_ID){
        userprofile.userID = [AppDelegate shared].nGlobalUserCounter.intValue + 1;
        [AppDelegate shared].nGlobalUserCounter = [NSNumber numberWithInt:([AppDelegate shared].nGlobalUserCounter.intValue + 1)];
        [[AppDelegate shared] saveUserDefaults];
    }
    NSString *imagePath = [NSString stringWithFormat:@"Documents/Pic2Speak/profiles/%d/",userprofile.userID];
    NSString  *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:imagePath];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath])	//Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:fullPath
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]){
        fullPath = [fullPath stringByAppendingString:@"/profile.png"];
        BOOL bWroteImageOk = [UIImagePNGRepresentation(image) writeToFile:fullPath atomically:YES];
        NSLog(@"Saved Image at %@ with Result %d",fullPath,bWroteImageOk);
    }
    
    
    userprofile.userimage = fullPath;
    userimageview.image = [UIImage imageWithContentsOfFile:fullPath];
    userimageview.layer.borderWidth = 0;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"[AvatarUploadViewController] -imagePickerControllerDidCancel-");
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

#pragma mark -
#pragma mark Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"[AvatarUploadViewController] -clickedButtonAtIndex-");
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    PortViewController *imagePicker = [[PortViewController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    
    
    switch (buttonIndex)
    {
        case 0:
            NSLog(@"buttonIndex: 0");
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
        case 1:
        {
            NSLog(@"buttonIndex: 1");
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
        }
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
        case 2:
            NSLog(@"buttonIndex: 2");
            userprofile.userimage = @"defaultuser";
            userimageview.image = [UIImage imageNamed:userprofile.userimage];
            break;
    }
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    if(CLLocationCoordinate2DIsValid(newLocation.coordinate) == NO || newLocation.coordinate.longitude == -180.00000000){
        NSLog(@"SnapLocationService:didUpdateLocations - INVALID COORDINATE RECEIVED",newLocation.coordinate);
        return;
    }
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
 
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            NSString *addressTxt = [[Globals sharedInstance] buildAddressFromLocation:placemark];
            studentlocationTF.text = addressTxt;
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Unable to start location manager. Error:%@", [error description]);
    
    if(error.code == kCLErrorDenied)
    {
            NSString *alertTitle        = NSLocalizedString(@"Information", nil);
            NSString *alertMessage      = NSLocalizedString(@"Location Services are turned off. To enable, please goto Settings - Privacy - Location Services scroll to FamilySafe and turn the switch to ON.", nil);
            NSString *okButtonTitle     = NSLocalizedString(@"Ok", nil);
            UIAlertView *coreLocAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:okButtonTitle otherButtonTitles:nil];
            coreLocAlert.alertViewStyle = UIAlertViewStyleDefault;
            [coreLocAlert show];

    }
}



///textfield delegate

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string {
    if (theTextField == studentageTF){
        NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0) || [string isEqualToString:@""];
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)txtObject {
    [txtObject resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{

    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{

}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
    static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
    static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
    static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
    static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
    
    CGRect textFieldRect = [self.view convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}

@end
