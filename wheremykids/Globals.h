//
//  Globals.h
//  WhereMyKids
//
//  Created by Gal Blank on 9/3/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@interface Globals : NSObject
+ (Globals *)sharedInstance;
-(void)callEmergencyNumber;


- (void)sendAsyncNowNewIsFinished:(NSString*)result;
-(NSString*)buildAddressFromLocation:(CLPlacemark*)location;

@end
