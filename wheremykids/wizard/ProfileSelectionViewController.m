//
//  ProfileSelectionViewController.m
//  Pic2Speak
//
//  Created by Gal Blank on 9/8/15.
//  Copyright (c) 2015 Gal Blank. All rights reserved.
//

#import "ProfileSelectionViewController.h"
#import "AppDelegate.h"
#import "ScrollItemView.h"

@interface ProfileSelectionViewController ()

@end

@implementation ProfileSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    usersScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    usersScrollView.pagingEnabled = YES;
    usersScrollView.bounces = YES;
    [usersScrollView setShowsHorizontalScrollIndicator:YES];
    usersScrollView.delegate = self;
    usersScrollView.minimumZoomScale=0.5;
    usersScrollView.maximumZoomScale=6.0;
    usersScrollView.translatesAutoresizingMaskIntoConstraints  = NO;
    
    [self.view addSubview:usersScrollView];
    
    [self loadImagesForJustView];
    
    
}


-(void)loadImagesForJustView
{
    CGFloat padding = 20.0;
    CGFloat previousX = 0;
    for(int i=0;i< [AppDelegate shared].nGlobalUserCounter.intValue; i++) {
        
        CGFloat x = previousX > 0?previousX + [UIImage imageNamed:@"defaultuser"].size.width:0;
        UIImage *assetimage = [UIImage imageNamed:@"defaultuser"];
        NSLog(@"%f",previousX + x + padding);
        ScrollItemView *item = [[ScrollItemView alloc] initWithFrame:CGRectMake(x + padding,(self.view.frame.size.height - [UIImage imageNamed:@"defaultuser"].size.height) / 2,[UIImage imageNamed:@"defaultuser"].size.width, [UIImage imageNamed:@"defaultuser"].size.height) andType:ITEMTYPE_USER];
        
        previousX = item.frame.origin.x;
        
        item.clipsToBounds = YES;
        item.tag = i;
        item.restorationIdentifier = [NSString stringWithFormat:@"%d",i];
        
        
        UITapGestureRecognizer *tapOnItem = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnItem:)];
        [item addGestureRecognizer:tapOnItem];
        
        [usersScrollView addSubview:item];
        
        usersScrollView.contentSize = CGSizeMake(previousX + [UIImage imageNamed:@"defaultuser"].size.width + padding,self.view.frame.size.height);
    }
}

-(void)tappedOnItem:(UIGestureRecognizer*)gesture
{
    NSInteger t = gesture.view.tag;
    NSLog(@"tapped %ld",(long)t);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
