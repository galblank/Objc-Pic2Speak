//
//  ProfileModel.h
//  Pic2Speak
//
//  Created by Gal Blank on 10/20/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>

@interface ProfileModel : NSObject

@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSNumber *userage;
@property(nonatomic,strong)NSNumber *userpasscode;
@property(nonatomic)CLLocationCoordinate2D userlocation;
@property(nonatomic,strong)NSString *teachername;
@property(nonatomic,strong)NSString *userimage;
@property(nonatomic)int userID;

-(NSMutableDictionary*)userToDic;
-(void)dicToUser:(NSMutableDictionary*)dicuser;
@end
