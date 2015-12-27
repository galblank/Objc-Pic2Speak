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
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIImage imageNamed:@"smiley"].size.width, [UIImage imageNamed:@"smiley"].size.height)];
                imageView.image = [UIImage imageNamed:@"smiley"];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.userInteractionEnabled = YES;
                [self addSubview:imageView];
            }
                break;
            case ITEMTYPE_USER:
            {
                UIImage * smiley = [UIImage imageNamed:@"smiley"];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - smiley.size.width) / 2, 20, [UIImage imageNamed:@"smiley"].size.width, [UIImage imageNamed:@"smiley"].size.height)];
                imageView.image = [UIImage imageNamed:@"smiley"];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.userInteractionEnabled = YES;
                [self addSubview:imageView];
                UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y + imageView.frame.size.height + 10, imageView.frame.size.width,80)];
                lbl.numberOfLines = 0;
                lbl.textAlignment = NSTextAlignmentCenter;
                lbl.font = [UIFont fontWithName:systemFont size:25];
                lbl.text = NSLocalizedString(@"Tap smiley to change picture", nil);
                [self addSubview:lbl];
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
