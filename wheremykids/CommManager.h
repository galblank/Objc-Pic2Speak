//
//  CommMamanger.h
//  TheLine
//
//  Created by Gal Blank on 5/21/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIS3Request.h"
#import "ASIS3ObjectRequest.h"
#import "ASINetworkQueue.h"
#import "Reachability.h"
#import "SBJsonParser.h"
#import <sys/socket.h>
#import <arpa/inet.h>



#define  KEY_COMM_DELEGATE       @"kKEY_COMM_DELEGATE"



@protocol CommunicationManagerDelegate <NSObject>
@optional
-(void)finishedPostingData:(NSString*)result;
@end



typedef enum
{
    kDevEnvironment=1,
    kStageEnvironment,
    kProdEnvironment,
    kIntegrationEnvironment,
    kQAEnvironment
}Environments;

@interface CommManager : ASIHTTPRequest
{
    
  ASINetworkQueue *netQueue;
  id<CommunicationManagerDelegate> __unsafe_unretained awsCommDelegate;
    int serverEnvironment;
    NSMutableDictionary *_server_settings_dictionary;
    
    NSMutableData *responseData;
}

@property(nonatomic,retain)ASINetworkQueue *netQueue;
+ (CommManager *)sharedInstance;
@property (nonatomic, unsafe_unretained) id<CommunicationManagerDelegate> awsCommDelegate;


-(void)postData:(NSMutableDictionary*)params postData:(NSData*)postData filePath:(NSString*)filePath withDelegate:(id)theDelegate;
-(NSString*)getServerUrl;
-(void)sendData:(NSString*)api params:(NSMutableDictionary*)params withDelegate:(id)theDelegate;
-(void)sendAsyncGoogle:(NSString*)htmlLink withDelegate:(id)theDelegate;
-(void)postAsyncGoogle:(NSString*)htmlLink withParams:(NSMutableDictionary*)params withDelegate:(id)theDelegate;
@end
