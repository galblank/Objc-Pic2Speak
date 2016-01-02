//
//  StudentProfileViewController.m
//  Pic2Speak
//
//  Created by Gal Blank on 10/28/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "ItemViewController.h"
#import "PortViewController.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>
#import "Globals.h"

@interface ItemViewController ()

@end

@implementation ItemViewController

@synthesize selectedItem;


-(BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger) supportedInterfaceOrientations
{
    //Because your app is only landscape, your view controller for the view in your
    // popover needs to support only landscape
    return UIInterfaceOrientationMaskLandscape;
}

-(void)saveUser
{
    if(selectedItem.itemID.intValue == NEW_USER_ID){
        selectedItem.itemID = [NSNumber numberWithInt:1];
    }
    selectedItem.itemname = studentnameTF.text;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveUser)];
    UIImage *userImage = [UIImage imageNamed:selectedItem.itemimage];
    userimageview = [[UIImageView alloc] initWithFrame:CGRectMake(5,5,userImage.size.width,userImage.size.height)];
    userimageview.image = userImage;
    userimageview.tag = selectedItem.itemID.intValue;
    userimageview.userInteractionEnabled = YES;
    UIButton *userProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userProfileButton.frame = CGRectMake(userimageview.frame.size.width - [UIImage imageNamed:@"selectpicture"].size.width - 5,userimageview.frame.size.height - [UIImage imageNamed:@"selectpicture"].size.height - 5,[UIImage imageNamed:@"selectpicture"].size.width, [UIImage imageNamed:@"selectpicture"].size.height);
    [userProfileButton addTarget:self action:@selector(chooseImageSource:) forControlEvents:UIControlEventTouchUpInside];
    [userProfileButton setBackgroundImage:[UIImage imageNamed:@"selectpicture"] forState:UIControlStateNormal];
    userProfileButton.tag = selectedItem.itemID.intValue;
    [userimageview addSubview:userProfileButton];
    [self.view addSubview:userimageview];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userimageview.frame.size.width + 10, 5, self.view.frame.size.width - (userimageview.frame.size.width + 10), 30)];
    nameLabel.text = NSLocalizedString(@"Item name", nil);
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
    NSString *firstNamePlaceholder = NSLocalizedString(@"", nil);
    studentnameTF.placeholder = firstNamePlaceholder;
    studentnameTF.backgroundColor = [UIColor clearColor];
    studentnameTF.autocorrectionType = UITextAutocorrectionTypeNo;
    studentnameTF.autocapitalizationType = UITextAutocapitalizationTypeWords;
    studentnameTF.returnKeyType = UIReturnKeyDone;
    studentnameTF.keyboardType  = UIKeyboardTypeAlphabet;
    studentnameTF.keyboardAppearance = UIKeyboardAppearanceLight;
    studentnameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    studentnameTF.tag = 1;
    studentnameTF.delegate = self;
    [self.view addSubview:studentnameTF];
    [studentnameTF becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chooseImageSource:(UIButton*)sender
{
    UIActionSheet *photoTypeAlert = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:nil];
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
    
    if(selectedItem.itemID.intValue == NEW_USER_ID){
        selectedItem.itemID = [NSNumber numberWithInt:1];
    }
    NSString *imagePath = [NSString stringWithFormat:@"Documents/Pic2Speak/items/%@/",selectedItem.itemname];
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
    
    
    selectedItem.itemimage = fullPath;
    userimageview.image = [UIImage imageWithContentsOfFile:fullPath];
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
            //userprofile.userimage = @"defaultuser";
            //userimageview.image = [UIImage imageNamed:userprofile.userimage];
            break;
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
