//
//  StudentProfileViewController.h
//  Pic2Speak
//
//  Created by Gal Blank on 10/28/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileModel.h"

@interface StudentProfileViewController : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate>
{
    ProfileModel *userprofile;
    UIImageView *userimageview;
    UITextField * studentnameTF;
    UITextField * studentageTF;
    UITextField * studentlocationTF;
    UITextField * teachernameTF;
    CLLocationManager *locationManager;
    CGFloat animatedDistance;
}

@property(nonatomic,retain)ProfileModel *userprofile;
@end
