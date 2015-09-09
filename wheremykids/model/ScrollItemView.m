//
//  ScrollItemView.m
//  Pic2Speak
//
//  Created by Gal Blank on 9/9/15.
//  Copyright (c) 2015 Gal Blank. All rights reserved.
//

#import "ScrollItemView.h"

@implementation ScrollItemView

- (id)initWithFrame:(CGRect)frame andType:(ItemType)iType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        switch (iType) {
            case ITEMTYPE_MAIN:
                
                break;
            case ITEMTYPE_USER:
            {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIImage imageNamed:@"defaultuser"].size.width, [UIImage imageNamed:@"defaultuser"].size.height)];
                imageView.image = [UIImage imageNamed:@"defaultuser"];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.userInteractionEnabled = YES;
                [self addSubview:imageView];
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
