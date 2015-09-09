//
//  Globals.m
//  WhereMyKids
//
//  Created by Gal Blank on 9/3/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "Globals.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "CommManager.h"

@implementation Globals
static Globals *sharedSampleSingletonDelegate = nil;


+ (Globals *)sharedInstance {
    @synchronized(self) {
        if (sharedSampleSingletonDelegate == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedSampleSingletonDelegate;
}



+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedSampleSingletonDelegate == nil) {
            sharedSampleSingletonDelegate = [super allocWithZone:zone];
            // assignment and return on first allocation
            return sharedSampleSingletonDelegate;
        }
    }
    // on subsequent allocation attempts return nil
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(id)init
{
    if (self = [super init]) {

    }
    return self;
}

-(NSString*)buildAddressFromLocation:(CLPlacemark*)location
{
    NSLog(@"[Globals] -buildAddressFromLocation-");
    
    NSArray *areasOfInterestList = [location areasOfInterest];
    
    NSString *zipCode     = [location postalCode];
    NSString *country     = [location country];
    NSString *state       = [location administrativeArea];
    NSString *city        = [location locality];
    NSString *streetNum   = [location subThoroughfare];
    NSString *streetName  = [location thoroughfare];
    
    NSString *subLocality = [location subLocality];
    NSString *county      = [location subAdministrativeArea];
    NSString *isoCountry  = [location ISOcountryCode];
    NSString *ocean       = [location ocean];
    NSString *inlandWater = [location inlandWater];
    
    if((areasOfInterestList) && (areasOfInterestList.count > 0))
    {
        NSLog(@"CLPlacemark areasOfInterestList: %@", [areasOfInterestList objectAtIndex:0]);
    }
    NSLog(@"CLPlacemark ocean:       %@", ocean);
    NSLog(@"CLPlacemark inlandWater: %@", inlandWater);
    NSLog(@"CLPlacemark country:     %@", country);
    NSLog(@"CLPlacemark state:       %@", state);
    NSLog(@"CLPlacemark city:        %@", city);
    NSLog(@"CLPlacemark streetNum:   %@", streetNum);
    NSLog(@"CLPlacemark streetName:  %@", streetName);
    NSLog(@"CLPlacemark subLocality: %@", subLocality);
    NSLog(@"CLPlacemark county:      %@", county);
    NSLog(@"CLPlacemark isoCountry:  %@", isoCountry);
    NSLog(@"CLPlacemark zipCode:     %@", zipCode);
    
    
    NSString *address = @"";
    
    if((areasOfInterestList) && (areasOfInterestList.count > 0))
    {
        address = [address stringByAppendingString:[areasOfInterestList objectAtIndex:0]];
        address = [address stringByAppendingString:@", "];
    }
    
    
    if(streetNum != nil && streetNum.length > 0)
    {
        address = [address stringByAppendingString:streetNum];
        address = [address stringByAppendingString:@" "];
        
        if(streetName != nil && streetName.length > 0)
        {
            address = [address stringByAppendingString:streetName];
            address = [address stringByAppendingString:@", "];
        }
    }
    else
    {
        if(streetName != nil && streetName.length > 0)
        {
            address = [address stringByAppendingString:streetName];
            address = [address stringByAppendingString:@", "];
        }
    }
    
    
    
    if(city != nil && city.length > 0)
    {
        if(isoCountry)
        {
            // For non-US addresses, include the 'subLocality' to get the full address.
            if([isoCountry isEqualToString:@"US"] == NO && subLocality)
            {
                address = [address stringByAppendingString:subLocality];
                address = [address stringByAppendingString:@", "];
            }
        }
        
        address = [address stringByAppendingString:city];
        address = [address stringByAppendingString:@", "];
    }
    
    if(isoCountry)
    {
        // For non-US addresses, include the 'county' to get the full address.
        if([isoCountry isEqualToString:@"US"] == NO)
        {
            if(county)
            {
                address = [address stringByAppendingString:county];
                address = [address stringByAppendingString:@", "];
            }
        }
    }
    
    if(state != nil && state.length > 0)
    {
        address = [address stringByAppendingString:state];
        address = [address stringByAppendingString:@", "];
    }
    if(country != nil && country.length > 0)
    {
        if([isoCountry isEqualToString:@"US"] == NO)
        {
            address = [address stringByAppendingString:country];
            address = [address stringByAppendingString:@", "];
        }
    }
    if(country != nil  && [country isEqualToString:@"Kyrgyzstan"])
    {
        return @"";
    }
    if(zipCode != nil && zipCode.length > 0)
    {
        address = [address stringByAppendingString:zipCode];
    }
    
    NSLog(@"Address string: %@", address);
    
    return address;
}


-(void)callEmergencyNumber
{
    CLLocation *location = [AppDelegate shared].lastLocation;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    if(location != nil && CLLocationCoordinate2DIsValid(location.coordinate)){
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (!(error))
             {
                 NSString *City = @"City - Uknonw";
                 NSString *Country = @"Country - Uknown";
                 
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 NSLog(@"\nCurrent Location Detected\n");
                 NSLog(@"placemark %@",placemark);
                 NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                 NSString *Address = [[NSString alloc] initWithString:locatedAt];
                 if(placemark.locality != nil){
                     City = [[NSString alloc] initWithString:placemark.locality];
                 }
                 NSString *numbertocall = @"911";
                 if(placemark.country != nil){
                     Country = [[NSString alloc] initWithString:placemark.country];
                     for(NSMutableDictionary *_emCountry in [AppDelegate shared].emergencyNumbers){
                         NSString *strcountry = [_emCountry objectForKey:@"country"];
                         if([strcountry caseInsensitiveCompare:Country] == NSOrderedSame){
                             numbertocall = [[_emCountry objectForKey:@"number"] stringValue];
                             break;
                         }
                     }
                     
                     NSLog(@"Calling Emergency Number %@",numbertocall);
                     NSString *phoneNumber = [@"tel://" stringByAppendingString:numbertocall];
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                 }
                 
                 
                 
                 //[self performSelectorOnMainThread:@selector(gotAddressfromLocationForUser:) withObject:user waitUntilDone:NO];
             }
             else
             {
                 NSLog(@"Geocode failed with error %@", error);
                 NSLog(@"\nCurrent Location Not Detected\n");
             }
             
         }];
    }
    else{
        NSString *ip = [self getIPAddress];
        NSLog(@"Location is uknown , trying by IP address: %@",ip);
        [[CommManager sharedInstance] sendAsyncGoogle:[NSString stringWithFormat:@"http://api.ipinfodb.com/v3/ip-country/?key=a455bd11d55cf9fb9d2381e2f6e78e54f115bf561abc11d568705ccd02b7c42c&ip=%@&format=json",ip] withDelegate:self];
    }
}


- (void)sendAsyncNowNewIsFinished:(NSString*)result
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonResult = [parser objectWithString:result];
    NSString *numbertocall = @"911";
    NSString *countryName = [jsonResult objectForKey:@"countryName"];
    for(NSMutableDictionary *_emCountry in [AppDelegate shared].emergencyNumbers){
        NSString *strcountry = [_emCountry objectForKey:@"country"];
        if([strcountry caseInsensitiveCompare:countryName] == NSOrderedSame){
            numbertocall = [_emCountry objectForKey:@"country"];
            break;
        }
    }
    
    NSLog(@"Calling Emergency Number %@",numbertocall);
    NSString *phoneNumber = [@"tel://" stringByAppendingString:numbertocall];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}
@end
