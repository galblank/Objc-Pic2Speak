//
//  PhotosScrollView.m
//  First App
//
//  Created by Natalie Blank on 29/09/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PhotosScrollView.h"


@implementation PhotosScrollView


- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {
	
	if (!self.dragging) {
		[self.nextResponder touchesEnded: touches withEvent:event]; 
	}		
	[super touchesEnded: touches withEvent: event];
    UITouch *theTouch = [touches anyObject];
    CGPoint loc = [theTouch locationInView:self];
}

- (void)handleSingleTap:(NSDictionary *)touches {
    // Single-tap: decrease image size by 10%"
    CGRect myFrame = self.frame;
    myFrame.size.width -= self.frame.size.width * 0.1;
    myFrame.size.height -= self.frame.size.height * 0.1;
    myFrame.origin.x += (self.frame.origin.x * 0.1) / 2.0;
    myFrame.origin.y += (self.frame.origin.y * 0.1) / 2.0;
    [UIView beginAnimations:nil context:NULL];
    [self setFrame:myFrame];
    [UIView commitAnimations];
}

- (void) touchesBegin: (NSSet *) touches withEvent: (UIEvent *) event {
	
	/*if (!self.dragging) {
		[self.nextResponder touchesBegin: touches withEvent:event]; 
	}		
	[super touchesBegin: touches withEvent: event];*/
}


@end
