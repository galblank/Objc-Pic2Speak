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


- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

-(void)loadImagesForJustView
{
    CGFloat horizontalpadding = 20.0;
    CGFloat topPadding = 80.0;
    CGFloat bottomPadding = topPadding * 2;
    CGFloat width = self.view.frame.size.width / 3;
    CGFloat previousX = 0;
    for(int i=0;i< 5/*[AppDelegate shared].nGlobalUserCounter.intValue*/; i++) {
        
        CGFloat x = previousX > 0?previousX + width:0;
        NSLog(@"%f",previousX + x + horizontalpadding);
        float height = self.view.frame.size.height - (topPadding + bottomPadding);
        ScrollItemView *item = [[ScrollItemView alloc] initWithFrame:CGRectMake(x + horizontalpadding,topPadding,width,height) andType:ITEMTYPE_USER];
        item.backgroundColor = [UIColor greenColor];
        previousX = item.frame.origin.x;
        
        //item.clipsToBounds = YES;
        item.tag = i;
        item.restorationIdentifier = [NSString stringWithFormat:@"%d",i];
        
        
        UITapGestureRecognizer *tapOnItem = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnItem:)];
        [item addGestureRecognizer:tapOnItem];
        
        [usersScrollView addSubview:item];
        
        usersScrollView.contentSize = CGSizeMake(previousX + width + horizontalpadding,self.view.frame.size.height);
    }
}

-(void)tappedOnItem:(UIGestureRecognizer*)gesture
{
    NSInteger t = gesture.view.tag;
    NSLog(@"tapped %ld",(long)t);
    [[AppDelegate shared] chooseImage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
