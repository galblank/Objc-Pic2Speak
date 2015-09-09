//
//  ProfileModel.m
//  Pic2Speak
//
//  Created by Gal Blank on 10/20/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "ProfileModel.h"
#import "AppDelegate.h"

@implementation ProfileModel

@synthesize username,teachername,userlocation,userimage,userID,userage;


-(NSMutableDictionary*)userToDic
{
    NSMutableDictionary *dictionaryUser = [[NSMutableDictionary alloc] init];
    
    [dictionaryUser setObject:username!=nil?username:@""                            forKey:@"username"];
    [dictionaryUser setObject:teachername!=nil?teachername:@""                      forKey:@"teachername"];
    [dictionaryUser setObject:userimage!=nil?userimage:@""                          forKey:@"userimage"];
    [dictionaryUser setObject:userage!=nil?userage:[NSNumber numberWithInt:5]       forKey:@"userage"];
    if(CLLocationCoordinate2DIsValid(userlocation)){
        [dictionaryUser setObject:[NSNumber numberWithDouble:userlocation.latitude] forKey:@"latitude"];
        [dictionaryUser setObject:[NSNumber numberWithDouble:userlocation.longitude] forKey:@"longitude"];
    }
    [dictionaryUser setObject:[NSNumber numberWithInt:userID] forKey:@"userID"];
    
    return dictionaryUser;
}

-(void)dicToUser:(NSMutableDictionary*)dicuser
{
    username            = [dicuser objectForKey:@"username"];
    userID              = [[dicuser objectForKey:@"userID"] intValue];
    teachername         = [dicuser objectForKey:@"teachername"];
    userimage           = [dicuser objectForKey:@"userimage"];
    userage             = [dicuser objectForKey:@"userage"];
    
    if([dicuser objectForKey:@"latitude"] &&  [dicuser objectForKey:@"longitude"]){
        userlocation = CLLocationCoordinate2DMake([[dicuser objectForKey:@"latitude"] doubleValue],[[dicuser objectForKey:@"longitude"] doubleValue]);
    }
}


@end
