//
//  ViewForResultViewController.h
//  beatMeIfYouCan
//
//  Created by Gauhar Shakeel on 3/11/2014.
//  Copyright (c) 2014 Gauhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface ViewForResultViewController :UIViewController

{
    int checkStatus;
    int scoreVal;
    int fromPeer;
    int dispWhat;
    NSString * dispStr;
    NSString * peerNameID;

}
- (IBAction)backButton:(UIBarButtonItem *)sender;

@property (strong, nonatomic) IBOutlet UILabel *finalLabel;

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) IBOutlet UINavigationItem *naviBar;

-(int) getStatus;
-(void) setStatus : (int) x;

//-(void) settingTheLabel;

// setting the score value
-(void) setScore: (int) scr;

@property (strong, nonatomic) IBOutlet UITextView *tvChat;




-(UITextView *) getTvChat;
-(void) dispOnTvChat: (int) score;

-(void) setFromPeer: (int) val;



// displaying for the peer
//-(void) countForGameRemTime: (int) currMin :(int) secondlft;
-(void) dispOnTvChatFromPeer: (NSString *) peerName :(NSString *) txtRecieved;

@end
