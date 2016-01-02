//
//  StudentProfileViewController.h
//  Pic2Speak
//
//  Created by Gal Blank on 10/28/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"

@interface ItemViewController : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate>
{
    ItemModel *selectedItem;
    UIImageView *userimageview;
    UITextField * studentnameTF;
    UITextField * studentageTF;
    UITextField * studentlocationTF;
    UITextField * teachernameTF;
    CLLocationManager *locationManager;
    CGFloat animatedDistance;
}

@property(nonatomic,retain)ItemModel *selectedItem;
@end
