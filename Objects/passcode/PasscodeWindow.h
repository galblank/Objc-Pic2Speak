//
//  PasscodeWindow.h
//  Pic2Speak
//
//  Created by Gal Blank on 1/9/16.
//  Copyright © 2016 Gal Blank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PasscodeWindowDelegate <NSObject>

/// Called when object start is found
- (void)cancel;
-(void) submitcode:(NSString*)text;
@end

@interface PasscodeWindow : UIView
{
    UITextField * codeField;
    UIButton * cancel;
    UIButton * submit;
    
    id<PasscodeWindowDelegate> __unsafe_unretained pwdDelegate;
}

@property(nonatomic,strong)UITextField * codeField;
@property (nonatomic, unsafe_unretained) id<PasscodeWindowDelegate> pwdDelegate;

@end
