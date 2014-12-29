//
//  ViewForResultViewController.m
//  beatMeIfYouCan
//
//  Created by Gauhar Shakeel on 3/11/2014.
//  Copyright (c) 2014 Gauhar. All rights reserved.
//

#import "ViewForResultViewController.h"

@interface ViewForResultViewController ()

@end

@implementation ViewForResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Final Result";
    }
    
    checkStatus =0;
    
    // the score value from the game
    scoreVal =0;
    
    return self;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    // default fromPeer val is 0
    // as its from yourself
    fromPeer =0;
    
    // what to display
    //dispWhat =0;
    dispStr = [[NSString alloc] init];
    peerNameID = [[NSString alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
   
    
    if(checkStatus == 0)
    {
        NSLog(@"Stop hi press hua");
        // this means stop is pressed and no one won
        _finalLabel.text = @"The Game is Stopped.";
    }
    
    if(checkStatus == 1)
    {
        _finalLabel.text = @"Game Over";
    }
    
    _scoreLabel.text = [NSString stringWithFormat:@"%d",scoreVal];
    
   
   
   // displaying on text view
    if(dispWhat == 0)
    {
        NSLog(@"view did appear mei aaya dispWhat is 0");
        [_tvChat setText:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"\n My Score: %@", dispStr]]];
        [_tvChat setText:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"\n My Score: %d", scoreVal]]];
       // dispWhat =1;
    }
    else
    {
        if(dispWhat == 1)
        {
            [_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerNameID, dispStr]] waitUntilDone:NO];
            dispWhat =0;
        }
    }
    
    
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(UIBarButtonItem *)sender
{
    MainViewController * mvc = [[MainViewController alloc] initWithNibName:@"MainStoryboard_iPhone" bundle:nil];
    _naviBar.title = @"The Letter Game";
   
    [self.navigationController pushViewController:mvc animated:YES];
    
}

-(int) getStatus
{
    return  checkStatus;
}

-(void) setStatus: (int) x
{
    checkStatus = x;
}

-(void) setScore: (int) scr
{
    scoreVal = scr;
}


// the getter for tcChat
-(UITextView *) getTvChat
{
    return _tvChat;
}

-(void) dispOnTvChat:(int)score
{
    
    dispWhat =0;
   // dispStr = [NSString stringWithString:str];
    dispStr = @"Hi how are?";
    scoreVal = score;
    NSLog(@"dispStr is %@", dispStr);
}

-(void) dispOnTvChatFromPeer:(NSString *)peerName :(NSString *)txtRecieved
{
    dispStr = [NSString stringWithString:txtRecieved];
    peerNameID = [NSString stringWithString:peerName];
    
    dispWhat = 1;
     //[_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerName, txtRecieved]] waitUntilDone:NO];
}


// if its from peer or yourself
-(void) setFromPeer:(int)val
{
    fromPeer = val;
}

@end
