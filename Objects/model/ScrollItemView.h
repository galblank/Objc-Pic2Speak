//
//  ScrollItemView.h
//  Pic2Speak
//
//  Created by Gal Blank on 9/9/15.
//  Copyright (c) 2015 Gal Blank. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
   ITEMTYPE_MAIN = 0,
    ITEMTYPE_ITEM,
    ITEMTYPE_USER
}ItemType;

@interface ScrollItemView : UIView
{
    UILabel * changePicLabel;
    UIButton * saveButton;
}

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UITextField *username;
- (id)initWithFrame:(CGRect)frame andType:(ItemType)iType andUser:(NSMutableDictionary*)user;
@end
