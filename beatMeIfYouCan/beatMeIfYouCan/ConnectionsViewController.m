//
//  ConnectionsViewController.m
//  beatMeIfYouCan
//
//  Created by Gauhar Shakeel on 3/13/2014.
//  Copyright (c) 2014 Gauhar. All rights reserved.
//

#import "ConnectionsViewController.h"


@interface ConnectionsViewController ()

@end

@implementation ConnectionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayNAme:[UIDevice currentDevice].name];
    [[_appDelegate mcManager] advertiseSelf:_swVisible.isOn];
    
    // the text field delegate is initialized
    [_txtName setDelegate:self];
    
    // letting our connection class to know about specific notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerDidChangeStateWithNotification:) name:@"MCDidChangeStateNotification" object:nil];
    
    // initializing the array of connected devices
    _arrayConnectedDevices = [[NSMutableArray alloc] init];
    // setting our class to be the delegae of
    // our table view
    
    [_tbleConnectedDevices setDelegate:self];
    [_tbleConnectedDevices setDataSource:self];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)browseForDevices:(id)sender
{
    [[_appDelegate mcManager] setupMCBrowser];
    [[[_appDelegate mcManager] browser] setDelegate:self];
    [self presentViewController:[[_appDelegate mcManager] browser] animated:YES completion:nil];
    
    
}


- (IBAction)toggleVisibility:(id)sender
{
    [_appDelegate.mcManager advertiseSelf:_swVisible.isOn];
}


- (IBAction)checkButton:(id)sender {
    
    NSLog(@"check press hua");
    
    [_appDelegate.mcManager.session disconnect];
    
    _txtName.enabled = YES;
    
    [_arrayConnectedDevices removeAllObjects];
    [_tbleConnectedDevices reloadData];
}



// the delegates methods for MCBrowuserViewControllerDelegate
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}
//////////// delegates for cancel and done button ends ///////////////

// the text field should return delegate method
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [_txtName resignFirstResponder];
    
    _appDelegate.mcManager.peerID = nil;
    _appDelegate.mcManager.browser = nil;
    _appDelegate.mcManager.session = nil;
    
    
    if([_swVisible isOn])
    {
        [_appDelegate.mcManager.advertiser stop];
    }
    
    _appDelegate.mcManager.advertiser = nil;
    
    [_appDelegate.mcManager setupPeerAndSessionWithDisplayNAme:_txtName.text];
    [_appDelegate.mcManager setupMCBrowser];
    
    [_appDelegate.mcManager advertiseSelf:_swVisible.isOn];
    
    
    
    return YES;
}

// the private notification method.
-(void) peerDidChangeStateWithNotification:(NSNotification *)notification
{
    MCPeerID * peerID = [[notification userInfo] objectForKey:@"peerID"];
    
    NSString * peerDisplayName = peerID.displayName;
    MCSessionState  state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if(state != MCSessionStateConnecting)
    {
        if(state == MCSessionStateConnected)
        {
            [_arrayConnectedDevices addObject:peerDisplayName];
           // [_btnDisconnect setEnabled: true];
            
            // that the Phone is connected
            isConnected = true;
            
            NSLog(@"the status of connection is %hhd", isConnected);
        }
        else if(state == MCSessionStateNotConnected)
        {
            if([_arrayConnectedDevices count] >0)
            {
                int indexOfPeer = [_arrayConnectedDevices indexOfObject:peerDisplayName];
                [_arrayConnectedDevices removeObjectAtIndex:indexOfPeer];
                
                // there is no connections
                isConnected = false;
            }
        }
    }
    
    [_tbleConnectedDevices reloadData];
    
    BOOL peerExists = ([[_appDelegate.mcManager.session connectedPeers] count] ==0);
    
    //[_btnDisconnect setEnabled:!peerExists];
    
    [_txtName setEnabled:peerExists];
    
}


// the table view delegate methods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableVie
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayConnectedDevices count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = [_arrayConnectedDevices objectAtIndex:indexPath.row];
    
    return cell;
    
}

-(BOOL) getForConnections
{
    return isConnected;
}


@end
