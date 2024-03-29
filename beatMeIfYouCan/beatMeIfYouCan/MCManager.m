//
//  MCManager.m
//  beatMeIfYouCan
//
//  Created by Gauhar Shakeel on 3/13/2014.
//  Copyright (c) 2014 Gauhar. All rights reserved.
//

#import "MCManager.h"

@implementation MCManager

-(id) init
{
    self = [super init];
    
    if(self)
    {
        _peerID =nil;
        _session = nil;
        
        _browser = nil;
        
        _advertiser = nil;
    }
    
    return self;
}

-(void) session: (MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    
    NSDictionary * dict = @{@"peerID": peerID,
                            @"state" : [NSNumber numberWithInt:state]
                            };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification" object:nil userInfo:dict];
    
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    
    // adding in the array
    ////////////////////////
    
    NSDictionary * dict = @{@"data": data,
                            
                            @"peerID": peerID
                            };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification" object:nil userInfo:dict];
    
    
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

// setting up the peer seesion with the display name.
-(void) setupPeerAndSessionWithDisplayNAme:(NSString *)displayName
{
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    
    _session = [[MCSession alloc] initWithPeer:_peerID];
    
    _session.delegate = self;
}

-(void) setupMCBrowser
{
    _browser = [[MCBrowserViewController alloc] initWithServiceType:@"game-score" session:_session];
}

-(void) advertiseSelf:(BOOL)shouldAdvertise
{
    if(shouldAdvertise)
    {
        _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"game-score" discoveryInfo:nil session:_session];
        
        [_advertiser start];
    }
    else
    {
        [_advertiser stop];
        _advertiser = nil;
    }
}

@end
