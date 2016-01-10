//
//  ScrollItemView.m
//  Pic2Speak
//
//  Created by Gal Blank on 9/9/15.
//  Copyright (c) 2015 Gal Blank. All rights reserved.
//

#import "ScrollItemView.h"
#import "AppDelegate.h"

@implementation ScrollItemView

@synthesize imageView,username;

- (id)initWithFrame:(CGRect)frame andType:(ItemType)iType
{
    self = [super initWithFrame:frame];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    if (self)
    {
        switch (iType) {
            case ITEMTYPE_MAIN:
            {
                self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIImage imageNamed:@"smiley"].size.width, [UIImage imageNamed:@"smiley"].size.height)];
                self.imageView.image = [UIImage imageNamed:@"smiley"];
                self.imageView.contentMode = UIViewContentModeScaleAspectFit;
                self.imageView.userInteractionEnabled = YES;
                [self addSubview:self.imageView];
            }
                break;
            case ITEMTYPE_USER:
            {
                UIImage * smiley = [UIImage imageNamed:@"smiley"];
                self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - smiley.size.width) / 2, 20, smiley.size.width, smiley.size.height)];
                imageView.image = smiley;
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.userInteractionEnabled = YES;
                [self addSubview:imageView];
                if([AppDelegate shared].isAdmin){
                UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y + imageView.frame.size.height + 10, imageView.frame.size.width,80)];
                lbl.numberOfLines = 0;
                lbl.textAlignment = NSTextAlignmentCenter;
                lbl.font = [UIFont fontWithName:systemFont size:25];
                lbl.text = NSLocalizedString(@"Tap smiley to change picture", nil);
                [self addSubview:lbl];
                
                username = [[UITextField alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, self.frame.size.height - 60, imageView.frame.size.width,40)];
                username.textAlignment = NSTextAlignmentCenter;
                username.font = [UIFont fontWithName:systemFont size:25];
                username.placeholder = NSLocalizedString(@"Tap to edit name", nil);
                [self addSubview:username];
                }
            }
                break;
            case ITEMTYPE_ITEM:
                break;
            default:
                break;
        }
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
