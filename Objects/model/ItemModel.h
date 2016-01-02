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

@interface ItemModel : NSObject

@property(nonatomic,strong)NSString *itemname;
@property(nonatomic,strong)NSString *itemdescription;
@property(nonatomic,strong)NSNumber *itemtype;
@property(nonatomic,strong)NSString *itemimage;
@property(nonatomic,strong)NSNumber *itemID;
@property(nonatomic,strong)NSString *voicetag;

-(NSMutableDictionary*)itemToDic;
-(void)dicToItem:(NSMutableDictionary*)dicitem;
@end