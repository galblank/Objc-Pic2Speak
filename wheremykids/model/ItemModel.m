//
//  ProfileModel.m
//  Pic2Speak
//
//  Created by Gal Blank on 10/20/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "ItemModel.h"
#import "AppDelegate.h"

@implementation ItemModel

@synthesize itemdescription,itemID,itemimage,itemname,itemtype,voicetag;


-(NSMutableDictionary*)userToDic
{
    NSMutableDictionary *dictionaryUser = [[NSMutableDictionary alloc] init];
    
    [dictionaryUser setObject:itemdescription!=nil?itemdescription:@""                  forKey:@"itemdescription"];
    [dictionaryUser setObject:itemID!=nil?itemID:[NSNumber numberWithInt:1001]          forKey:@"itemID"];
    [dictionaryUser setObject:itemimage!=nil?itemimage:@""                              forKey:@"itemimage"];
    [dictionaryUser setObject:itemname!=nil?itemname:@""                              forKey:@"itemimage"];
    [dictionaryUser setObject:itemtype!=nil?itemtype:[NSNumber numberWithInt:1001]      forKey:@"itemtype"];
    [dictionaryUser setObject:voicetag!=nil?voicetag:@""                              forKey:@"voicetag"];
    return dictionaryUser;
}

-(void)dicToItem:(NSMutableDictionary*)dicitem
{
    itemdescription             = [dicitem objectForKey:@"itemdescription"];
    itemID                      = [dicitem objectForKey:@"itemID"];
    itemimage                   = [dicitem objectForKey:@"itemimage"];
    itemname                    = [dicitem objectForKey:@"itemname"];
    itemtype                    = [dicitem objectForKey:@"itemtype"];
    voicetag                    = [dicitem objectForKey:@"voicetag"];
}


@end
