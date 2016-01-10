//
//  PasscodeWindow.m
//  Pic2Speak
//
//  Created by Gal Blank on 1/9/16.
//  Copyright © 2016 Gal Blank. All rights reserved.
//

#import "PasscodeWindow.h"
#import "AppDelegate.h"
@implementation PasscodeWindow

@synthesize pwdDelegate,codeField;

-  (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    
    if (self)
    {
        self.backgroundColor = pastelDarkBlueColor;
        self.layer.borderWidth = 3.5;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.titleLabel.font = [UIFont fontWithName:systemFont size:20];
        [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [cancel setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [self addSubview:cancel];
        codeField = [[UITextField alloc] initWithFrame:CGRectMake(10,aRect.size.height / 2 - 20, aRect.size.width - 10, 40)];
        codeField.font = [UIFont fontWithName:systemFont size:19];
        codeField.placeholder = NSLocalizedString(@"Enter admin code", nil);
        codeField.textAlignment = NSTextAlignmentCenter;
        codeField.borderStyle = UITextBorderStyleNone;
        codeField.secureTextEntry = YES;
        codeField.backgroundColor = [UIColor whiteColor];
        codeField.textColor = [UIColor blackColor];
        codeField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:codeField];
        
        submit = [UIButton buttonWithType:UIButtonTypeCustom];
        [submit addTarget:self action:@selector(submitcode:) forControlEvents:UIControlEventTouchUpInside];
        [submit setTitle:NSLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
        submit.titleLabel.font = [UIFont fontWithName:systemFont size:20];
        [self addSubview:submit];
        
    }
    
    return self;
}

-(void)cancel
{
    if([pwdDelegate respondsToSelector:@selector(cancel)]){
        [pwdDelegate cancel];
    }
}

-(void) submitcode:(NSString*)text
{
    if([pwdDelegate respondsToSelector:@selector(submitcode:)]){
        [pwdDelegate submitcode:codeField.text];
    }
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    codeField.frame = CGRectMake(10,rect.size.height / 2 - 20, rect.size.width - 20, 40);
    cancel.frame = CGRectMake(10,codeField.frame.origin.y - 45, rect.size.width - 20, 40);
    submit.frame = CGRectMake(10,codeField.frame.origin.y + 40 + 5, rect.size.width - 20, 40);
}

@end
