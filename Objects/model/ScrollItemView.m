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
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(consumeMessage:) name:@"internal.unlockadminmode" object:nil];
    
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
               
                changePicLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y + imageView.frame.size.height + 10, imageView.frame.size.width,80)];
                changePicLabel.numberOfLines = 0;
                changePicLabel.textAlignment = NSTextAlignmentCenter;
                changePicLabel.hidden = ![AppDelegate shared].isAdmin;
                changePicLabel.font = [UIFont fontWithName:systemFont size:25];
                changePicLabel.text = NSLocalizedString(@"Tap smiley to change picture", nil);
                [self addSubview:changePicLabel];
                
                saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
                saveButton.frame = CGRectMake(changePicLabel.center.x - 60, changePicLabel.frame.origin.y + changePicLabel.frame.size.height + 10, 120,120);
                [saveButton addTarget:self action:@selector(saveUser:) forControlEvents:UIControlEventTouchUpInside];
                saveButton.layer.cornerRadius = 60;
                saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
                saveButton.layer.borderWidth = 3.0;
                [saveButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
                saveButton.titleLabel.font = [UIFont fontWithName:systemFont size:20];
                
                saveButton.layer.masksToBounds = YES;
                saveButton.enabled = [AppDelegate shared].isAdmin;
                [self addSubview:saveButton];
                
                username = [[UITextField alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, self.frame.size.height - 60, imageView.frame.size.width,40)];
                username.textAlignment = NSTextAlignmentCenter;
                username.font = [UIFont fontWithName:systemFont size:25];
                username.enabled = [AppDelegate shared].isAdmin;
                username.placeholder = NSLocalizedString(@"Tap to edit name", nil);
                [self addSubview:username];
                
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

-(void)saveUser:(UIButton*)btn
{
    NSString * query = [NSString stringWithFormat:@"insert into users (firstname,lastname,avatarurl,age,nickname) values(\"%@\",\"%@\",\"%@\",%d,\"%@\")",username.text,username.text,imageView.image,5,username.text];
    [[DBManager sharedInstance] executeQuery:query];
    
}

-(void)consumeMessage:(NSNotification*)notif
{
    Message * msg = [notif.userInfo objectForKey:@"message"];
    
    if([msg.routingKey caseInsensitiveCompare:@"internal.unlockadminmode"] == NSOrderedSame){
        changePicLabel.hidden = ![AppDelegate shared].isAdmin;
        username.enabled = [AppDelegate shared].isAdmin;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
