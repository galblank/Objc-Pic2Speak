//
//  PortViewController.m
//  Pic2Speak
//
//  Created by Gal Blank on 10/23/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "PortViewController.h"

@interface PortViewController ()

@end

@implementation PortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    // ATTENTION! Only return orientation MASK values
    // return UIInterfaceOrientationPortrait;
    
    return UIInterfaceOrientationMaskLandscape;
}

@end
