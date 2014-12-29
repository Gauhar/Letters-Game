//
//  ConnectionsViewController.h
//  beatMeIfYouCan
//
//  Created by Gauhar Shakeel on 3/13/2014.
//  Copyright (c) 2014 Gauhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "AppDelegate.h"

@interface ConnectionsViewController : UIViewController <MCBrowserViewControllerDelegate , UITextFieldDelegate , UITableViewDelegate, UITableViewDataSource>
{
    BOOL isConnected;
}

@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UISwitch *swVisible;
@property (strong, nonatomic) IBOutlet UITableView *tbleConnectedDevices;
//@property (strong, nonatomic) IBOutlet UIButton *btnDisconnect;

// the app delegate prperty
@property (strong, nonatomic) AppDelegate * appDelegate;

- (IBAction)browseForDevices:(id)sender;

- (IBAction)toggleVisibility:(id)sender;

//- (IBAction)btnDisconnect:(id)sender;

- (IBAction)checkButton:(id)sender;

// the private method that notifies us
-(void) peerDidChangeStateWithNotification: (NSNotification *) notification;

// the array for adding the peers in the table view
@property(strong, nonatomic) NSMutableArray* arrayConnectedDevices;

-(BOOL) getForConnections;

@end
