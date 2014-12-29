//
//  MainViewController.h
//  beatMeIfYouCan
//
//  Created by Gauhar Shakeel on 2013-09-11.
//  Copyright (c) 2013 Gauhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parser_Game.h"
#import "ViewForResultViewController.h"
#import "OptionsViewController.h"
#import "AppDelegate.h"
#import "ConnectionsViewController.h"

@interface MainViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate >
{
    
    
    ///////////////////////
    
    // timer for the correct in correct message
    NSTimer * timeForMessage;
    
    // timer for the game play
    NSTimer * timeForGame;
    
    int randomlyGeneratedNumber; // the random number
    
    //seconds left
    int currMin;
    int secondLft;
    int waitStartButtonPress;
    
    // counters to check how many words have been used in each catagory
    int countElementsOfCountryUsed; // keeps track that how many words have been used
    int countElementsOfSportsUsed; // keeps track that how many words have been used
    int countElementsOfFruitsUsed; // keeps track that how many words have been used
    int countElementsOfFoodUsed; // keeps track that how many words have been used
    
    
    
    ///////////////////////////////////// Changing of data structure //////////////////////////////////
    
     NSMutableDictionary * hashTableCatagories;
    
    NSString * storeKey;
    
    NSMutableDictionary * storeValues;

    NSMutableArray * storeElementsForCatag;
    
    NSString * printingStr;
    
    NSMutableArray * listOfKeys;
    
    
    /////////////////
    NSMutableArray * tempObArray;
    /////////////////
    
    NSMutableArray * tempObArray2;
    NSMutableArray * tempraryStrForStoreVal;
    
    
    ////////////////////////////////////             END          /////////////////////////////////////
    
    // the parser of xml
    Parser_Game *parserOfXML;
    
    /// calculating the score
    int scoreVar;
    
    // to check whether the phones are connceted
    // the connections object
    
    ConnectionsViewController * connection;
    
    
}

// catagory label
@property (strong, nonatomic) IBOutlet UILabel *catagoryLabel;

// word letter label
@property (strong, nonatomic) IBOutlet UILabel *wordLetterLabel;
// text field for the word
@property (strong, nonatomic) IBOutlet UITextField *textFieldForWord;

@property (strong, nonatomic) IBOutlet UILabel *corrIncorrLabel;

//timer for the message
@property (nonatomic, retain) NSTimer * timeForMessage;

// timer for the game
@property (nonatomic, retain) NSTimer * timeForGame;
// the button of timer 

@property (strong, nonatomic) IBOutlet UIBarButtonItem *timerButton;


/// the app delegate property
@property (strong, nonatomic) AppDelegate *appDelegate;

// the random number function
-(int) randomCatagory;


// print function
- (void) printingTheCatagoryFunc: (int) randNum;

// compare function
- (BOOL) compareFunction: (NSString *) wordToBeCompared;

// action when return button is clicked
-(IBAction)returnIsPressed:(id)sender;

//- (IBAction)startGameButton:(id)sender;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *startGameButt;
- (IBAction)startGameButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *startButt;

//@property (strong, nonatomic) IBOutlet UIBarButtonItem *startGameButt;

//target method
-(void) targetMethod;

// time remaing for game
-(void) countForGameRemTime: (int) currMin :(int) secondlft;

-(void) makingHashTableGenerically: (NSMutableArray *) array :(NSString *)catagoryKey;

// sending the message to server
-(void) sendMyMessage;

// didRecieveDataWithNotification method
-(void) didReceiveDataWithNotification: (NSNotification *) notification;

@property (strong, nonatomic) IBOutlet UITextView *tvScore;

@end
