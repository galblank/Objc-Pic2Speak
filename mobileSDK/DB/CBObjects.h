//
//  CBObjects.h
//  Pic2Speak
//
//  Created by Gal Blank on 1/8/16.
//  Copyright © 2016 Gal Blank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>

@interface CBObjects : NSObject

@property (nonatomic, strong) CBLDatabase *database;
@property (nonatomic, strong) CBLManager *manager;

+ (CBObjects*)sharedInstance;

@end
