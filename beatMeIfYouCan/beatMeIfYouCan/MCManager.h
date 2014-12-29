//
//  MCManager.h
//  beatMeIfYouCan
//
//  Created by Gauhar Shakeel on 3/13/2014.
//  Copyright (c) 2014 Gauhar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCManager : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

-(void) setupPeerAndSessionWithDisplayNAme: (NSString *) displayName;

-(void) setupMCBrowser;

-(void) advertiseSelf: (BOOL) shouldAdvertise;


@end
