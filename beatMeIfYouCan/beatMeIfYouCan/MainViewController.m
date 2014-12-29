//
//  MainViewController.m
//  beatMeIfYouCan
//
//  Created by Gauhar Shakeel on 2013-09-11.
//  Copyright (c) 2013 Gauhar. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

@synthesize timeForMessage;
@synthesize timeForGame;

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
    self.textFieldForWord.delegate = self;
	// Do any additional setup after loading the view.
   
    
    //seconds left
    secondLft = 00;
    currMin = 3;
    waitStartButtonPress =0;
    randomlyGeneratedNumber =0;
    

    
    // initializing the araays of catagories
    
    
    ////////////////////////////////
    
    
    
    
    ///////////////////////////////////////////////////////////
    
    
    
    /////////////////////
    
    ////////////////////////     END     //////////////////////
    
    storeKey = @"";
    
    storeValues = [[NSMutableDictionary alloc] init];
    
    ///////////////////////////////////// Changing of data structure //////////////////////////////////
    
    // initializing the string and dictionary to store.
    listOfKeys = [[NSMutableArray alloc] init];
    
   
    
    // initializing the catagories and its values
    
    
    
    hashTableCatagories = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           
            // the countries
                
                [[NSMutableDictionary alloc]initWithObjectsAndKeys:
            
            [[NSMutableArray alloc] initWithObjects:@"Laos",@"Lebanon", @"Libya", nil, nil], @"L",
            
            [[NSMutableArray alloc] initWithObjects:@"Pakistan",@"Poland", @"Phillippines", nil, nil], @"P",
                                                                              
            
            [[NSMutableArray alloc] initWithObjects:@"Iceland",@"India", @"Iran", nil, nil], @"I",
            
                           
           nil], @"Country",
        
           // Sports
                           

       [[NSMutableDictionary alloc]initWithObjectsAndKeys:
        
        [[NSMutableArray alloc] initWithObjects:@"Skiing",@"Snorkelling", @"Soccer", nil, nil], @"S",
        
        [[NSMutableArray alloc] initWithObjects:@"Cricket",@"Cave Diving", @"Canoeing", nil, nil], @"C",
        
        
        [[NSMutableArray alloc] initWithObjects:@"Ice Hockey",@"Ice Figure Skating", @"Inline Skating", nil, nil], @"I",
        
        
        nil], @"Sports",
        
                           
        nil];
    
    
    
    
    ////////////////////////////////////// END ////////////////////////////////////////////////////////
    
    /////////////////////// using XML parser of apple itself (NSXMLParser)//////////////////////
    
    
    parserOfXML = [[Parser_Game alloc]init];
    
    NSLog(@"the gen Array is in main view %@",[[parserOfXML getGenArray] description]);
    
   
    
    NSLog(@"///////country cata ///////////// %@", [parserOfXML getCountryCat]);
    NSLog(@"///////country cata list ///////////// %@", [parserOfXML getCountry]);
    
    //[self makingHashTableGenerically:[parserOfXML getGenArray] : @"Country"];
    [self makingHashTableGenerically:[parserOfXML getGenArray] : @"Food"];
    
    [hashTableCatagories description];
    
    NSLog(@"///////////////////////////////////////////////////////////////");
    NSLog(@"///////////////////////// The hastable is  ////////////////////////////////////");
    NSLog(@"%@",[hashTableCatagories description]);
    
    NSLog(@"/////////////////////////////////////////////////////////////////////////////////");
    
    
    ///////////////////////////// END ///////////////////////////////////////////////////////////
   
    
    
    //// initiazing the score
    scoreVar =0;
    
    // the app delegate initialization
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    // the connnections initializations
    connection = [[ConnectionsViewController alloc] init];
    
    
    
    
    // letting our game know about the notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
    
    
    
}

-(void) didReceiveMemoryWarning
{
    [self didReceiveMemoryWarning];
}

//////////////////////////
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        NSLog(@"Naye waley voew pe ja");
        
        /// when the time is over
        // going to the next view (viewForResult)
        // to show the score
        NSLog(@"connection %hhd", [connection getForConnections]);
        
        if(![connection getForConnections])
        {
            NSLog(@" its single player ");
          ViewForResultViewController * finalResultView = [[ViewForResultViewController alloc] initWithNibName:@"ViewForResultViewController" bundle:nil];
        
         finalResultView.title = @"The Letter Game";
        
            // sending the score on the final view
        [finalResultView setScore:scoreVar];
        
            [finalResultView dispOnTvChat:scoreVar];
            
        [finalResultView setStatus:1];
        
         [self.navigationController pushViewController:finalResultView animated:YES];
        }
        else
        {
            //////////////
            // send the message
            NSLog(@"message send kia hai");
            [self sendMyMessage];
        }
        
        // sending the score to the server
        
        
        
        
         
    }
}
/////////////////////////


/// the sendMyMessage method
// sends the message to phones connected
-(void) sendMyMessage
{
    NSLog(@"in send method");
    // 1. First step
    // add your own score first
    
    // converting the int to string to send the data
    NSString * score = [NSString stringWithFormat:@"%d",scoreVar];
    
    NSData * dataToSend = [score dataUsingEncoding:NSUTF8StringEncoding];
    NSArray * allPeers = _appDelegate.mcManager.session.connectedPeers;
    NSError * error;
    
    [_appDelegate.mcManager.session sendData:dataToSend toPeers:allPeers withMode:MCSessionSendDataReliable error:&error];
    
    if(error)
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    // now showing on the textView
   
  
    
    
    // my score is displayed
     [_tvScore setText:[_tvScore.text stringByAppendingString:[NSString stringWithFormat:@"My Score:\n%d\n\n", scoreVar]]];
    [_textFieldForWord resignFirstResponder];
    
    
    
    
}

// the didrecieve action to be performed

-(void) didReceiveDataWithNotification:(NSNotification *)notification
{
    NSLog(@"dis recieve data with notification method");
    
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    
    /// the peer score display
    
    NSLog(@"the score is %@", receivedText);
    
    [_tvScore performSelectorOnMainThread:@selector(setText:) withObject:[_tvScore.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
    
}

//time remaining for game
-(void) countForGameRemTime
{
    if(waitStartButtonPress ==0)
    {
        currMin =1;
        secondLft =0;
    }
    
    if((currMin>0 || secondLft>=0) && currMin>=0)
    {
        if(secondLft==0)
        {
            currMin--;
            secondLft=59;
        }
        else if(secondLft>0)
        {
            secondLft-=1;
        }
        if(currMin>-1)
        
            [[[self navigationItem] leftBarButtonItem] setTitle:[NSString stringWithFormat:@"%d%@%02d",currMin,@":", secondLft]];
        
        
        
        
        
        
        NSLog(@"%d : %d", currMin, secondLft);
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Timer Over" message:@"Game Finished" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        
        [timeForGame invalidate];
        [alert setTag:1];
        [alert show];
        _textFieldForWord.enabled = FALSE;
        _catagoryLabel.enabled = FALSE;
        _wordLetterLabel.enabled = FALSE;
        waitStartButtonPress =0;
        //_startGameButt.title = @"Start";
        _startButt.title = @"Start";
        
        
        
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [_textFieldForWord becomeFirstResponder];
}






//textfield delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    BOOL isFound;
    NSString * gettingTheWord;
    
    
    
     gettingTheWord = _textFieldForWord.text;
    
    if(textField == _textFieldForWord)
    {
        isFound = [self compareFunction: gettingTheWord];
                
        
        if(isFound == TRUE)
        {
            NSLog(@"found true hai");
            
            
            _corrIncorrLabel.text = @"Good! Correct Answer";
            _textFieldForWord.text = @"";
            timeForMessage = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(targetMethod) userInfo:nil repeats:NO];
            
            // incrementing the score of
            // the player
            scoreVar++;
            
            // sending the score
            [self sendMyMessage];
            
            ////////////////////
            ////////////////
            
            
        }
        else
        {
            NSLog(@"found false hai");
            
            _corrIncorrLabel.text = @"Sorry! Incorrect Answer";
            _textFieldForWord.text = @"";
            timeForMessage = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(targetMethod) userInfo:nil repeats:NO];
        }
        
        
        
    }
    
    randomlyGeneratedNumber = [self randomCatagory];
    
    [self printingTheCatagoryFunc:randomlyGeneratedNumber];
    
    
    return  YES;
}




// the target method
-(void) targetMethod
{
    _corrIncorrLabel.text = @"";
}

// alert view
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
       // NSLog(@"Cancel Tapped.");
        
        
        // clearing the text field
        _textFieldForWord.text = @"";
        
    }
    else if (buttonIndex == 1) {
      //  NSLog(@"OK Tapped.");
        
        // clearing the text field
        _textFieldForWord.text = @"";
        
    }
}
////////////


-(int) randomCatagory
{
    int catNumber = 0;
    catNumber = arc4random()%[hashTableCatagories count];
    
    
    return catNumber;
}


// print function
- (void) printingTheCatagoryFunc:(int) randNum
{
    
    NSLog(@"print catagory waley finction mei aaya hai");
    
    int randNumForEleSelect =0; // a random number for elements selection
    
    [listOfKeys addObjectsFromArray:[hashTableCatagories allKeys]]; //NSMutabkeArray FOR KEYS OF CATAGORIES
    
    storeKey = [listOfKeys objectAtIndex:randNum];
    
    _catagoryLabel.text = storeKey;
    
    ///////////////////// SELECTING THE ELEMENTS /////////////////////////////////
    
    randNumForEleSelect = arc4random()%4;
    
    [self selectElements:randNumForEleSelect];
    
    //////////////////////////////  SELECTION IS DONE AND PRINTED  //////////////////////
   
    NSString * str = [hashTableCatagories description];
    NSLog(@"%@",str);
     
}

// selection for elements
- (void) selectElements: (int) randNum
{
    NSMutableDictionary * elementStoring = [[NSMutableDictionary alloc] init];
    NSString * storeKeyForElements;
    
    NSMutableArray * elementList = [[NSMutableArray alloc]init];
    
    
    elementStoring = [hashTableCatagories objectForKey:storeKey];
    
    [elementList addObjectsFromArray:[elementStoring allKeys]];
    
    
    
    if(randNum < [elementList count])
    {
        storeKeyForElements = [elementList objectAtIndex:randNum];
        _wordLetterLabel.text = storeKeyForElements;
    }
}
    

// playing the game that means the words will be compared at when enter button is pressed
// compare function

- (BOOL) compareFunction: (NSString *) wordToBeCompared
{
    NSString * getttingTheWordFromTextField = @"";
    BOOL isWordFound = FALSE;
    char firstLetter;
    NSString* firstLetterAsString;
    
    NSString * elementKey;
    NSMutableArray * elementKeyList;
    
    NSMutableArray * elements = [[NSMutableArray alloc] init];
    
    NSMutableDictionary * storeElementsToCmp = [[NSMutableDictionary alloc] init];
    
    
    NSString * temp;
    BOOL keyMatch= FALSE;
    NSString * myNewTemp = @"";
    
    
    /////////////////////////////////////////////
    
    getttingTheWordFromTextField = wordToBeCompared;
    
    firstLetter = [getttingTheWordFromTextField characterAtIndex:0];  // first character of the word entered
    NSLog(@"the store key is %@",storeKey);
    storeElementsToCmp = [hashTableCatagories objectForKey:storeKey]; // for the key that was printed for the catagory
    
    NSLog(@" the object for the catagory key are: \n %@", [storeElementsToCmp description]);
    
    elementKeyList = [[NSMutableArray alloc] initWithArray:[storeElementsToCmp allKeys]];
    
    NSLog(@"compare mei elementKeyList mei hai %@", [elementKeyList description]);
    
    firstLetterAsString = [NSString stringWithFormat:@"%c",firstLetter];
    NSLog(@"the first letter in textField as a string is %@", firstLetterAsString);
    
    
    for(int i =0; i< [elementKeyList count]; i++)
    {
        temp = [elementKeyList objectAtIndex:i];
        NSLog(@"the value for temp is %@", temp);
        
        if([firstLetterAsString isEqualToString:temp])
        {
            NSLog(@"match hua hai");
            keyMatch = TRUE;
            break;
        }
        
    }
    
    if(keyMatch == TRUE)
    {
        elements = [storeElementsToCmp objectForKey:firstLetterAsString];
        
        NSLog(@"the element for the key are %@", [elements description]);
        
        for(int i =0; i< [elements count]; i++)
        {
            temp = [elements objectAtIndex:i];
            temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            temp = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSLog(@"value of temp is (%@) and the class of temp is%@", temp, [temp class]);
            
            NSLog(@"the textField is (%@) and the class of getting field is %@", getttingTheWordFromTextField, [getttingTheWordFromTextField class]);
            
            
            if([temp isEqualToString:getttingTheWordFromTextField])
            {
                NSLog(@"the value is matched");
                isWordFound = TRUE;
                break;
            }
        }
    }
    
    return isWordFound;
}


// making the hashtable from the list given
-(void) makingHashTableGenerically: (NSMutableArray *) genArray :(NSString *)catagoryKey
{
    NSLog(@"Mai aaagayaa am in the making hash function");
    
    
    
    NSMutableArray *listOfCataKeys = [[NSMutableArray alloc]init]; // keeps the keys of the catagories
    
    NSMutableDictionary * storeValuesForFunc = [[NSMutableDictionary alloc] init];
    
    NSMutableArray * listForKeysInCat = [[NSMutableArray alloc] init];
    
    /////////////////
    NSMutableArray * tempObArrayForFunc = [[NSMutableArray alloc] init];
    /////////////////
    
    NSMutableArray * tempObArray2ForFunc = [[NSMutableArray alloc] init];
    NSMutableArray * tempraryStrForStoreValForFunc = [[NSMutableArray alloc] init];
    
    NSMutableArray * storeElementsForCatagForFunc = [[NSMutableArray alloc] init];
    
    NSString * tempstrForFunc = @"";
    NSString * tempForKForFunc = @"";
    NSString * dalaneyKLiyeForFunc = @"";
    
    int countForMatchForFunc =0;
    
    /////////////////////// the variables for the catagory if doesnt exist
    
    NSMutableArray * keyListForCatagories = [[NSMutableArray alloc] init];
    int countForCatagoryCheck =0;
    NSMutableDictionary * emptyDictionary = [[NSMutableDictionary alloc] init];
    
    
    
    ///////////////////////////////////////////////////////////////////////
    
    
    
    
    //////////////////////////////////////////////////////////////////////////
    
    
    [listOfCataKeys addObjectsFromArray:[hashTableCatagories allKeys]];
    
    NSLog(@"the keys of catagories are %@", [listOfCataKeys description]);
    
    for(int i=0;i<[listOfCataKeys count];i++)
    {
        if([[listOfCataKeys objectAtIndex:i] isEqualToString:catagoryKey])
        {
            NSLog(@"the catagory is found");
            
            storeValuesForFunc = [hashTableCatagories objectForKey:catagoryKey];
            
            // listForKeysInCat have all the keys for the specific catagory
            [listForKeysInCat addObjectsFromArray:[storeValuesForFunc allKeys]];
            
            NSLog(@"tje list of keys in that cata is %@", [listForKeysInCat description]);
            
            for(int i=0;i< [genArray count]; i++)
            {
                tempstrForFunc = [genArray objectAtIndex:i];
                NSLog(@"the tempStrForFunc has %@",tempstrForFunc);
                tempstrForFunc = [tempstrForFunc substringToIndex:1];
                NSLog(@"the tempStrForFunc has %@",tempstrForFunc);
                
                for(int j=0;j< [listForKeysInCat count]; j++)
                {
                    NSLog(@"j ki val %d",j);
                    tempForKForFunc = [listForKeysInCat objectAtIndex:j];
                    NSLog(@"the value for tempForK %@",tempForKForFunc);
                    if([tempstrForFunc isEqualToString:tempForKForFunc])
                    {
                        NSLog(@"key match hui hai");
                        tempObArray2ForFunc = [[NSMutableArray alloc] init];
                        // storing the store values for key in this string.
                        if([[storeValuesForFunc objectForKey:tempstrForFunc] isKindOfClass:[NSString class]])
                        {
                            [tempraryStrForStoreValForFunc removeAllObjects];
                            [tempraryStrForStoreValForFunc addObject:[storeValuesForFunc objectForKey:tempstrForFunc]];
                        }
                        else
                        {
                           // NSLog(@"it is ")
                            // [tempraryStrForStoreVal removeAllObjects];
                            tempraryStrForStoreValForFunc = [storeValuesForFunc objectForKey:tempstrForFunc];
                        }
                        NSLog(@"the class for tempraryStrFotStore %@", [tempraryStrForStoreValForFunc class]);
                        ///////////////
                        for(int k =0;k<[tempraryStrForStoreValForFunc count];k++)
                        {
                            
                            [tempObArray2ForFunc addObject:[tempraryStrForStoreValForFunc objectAtIndex:k]];
                        }
                       
                        dalaneyKLiyeForFunc = [genArray objectAtIndex:i];
                        
                        [tempObArray2ForFunc addObject:dalaneyKLiyeForFunc];
                        
                        [storeValuesForFunc removeObjectForKey:tempForKForFunc];
                        [storeValuesForFunc setObject:tempObArray2ForFunc forKey:tempForKForFunc];
                        
                        NSLog(@"the storeValueForFunc ki descrip if key is there %@", [storeValuesForFunc description]);
                        
                        
                         countForMatchForFunc =0;
                        j = [listForKeysInCat count];
                        
                    }
                    else
                    {
                        countForMatchForFunc++;
                    }
                    
                }
                
                NSLog(@"the count value is %d and the listForKey value is %d",countForMatchForFunc, [listForKeysInCat count]);
                
               /// NSLog(@"After loop store ki description ha: %@", [storeValuesForFunc description]);
                if(countForMatchForFunc ==[listForKeysInCat count])
                {
                    NSLog(@"the object is not there so adding it and the tempStrForFunc is %@", tempstrForFunc);
                    if([[[storeValuesForFunc objectForKey:tempstrForFunc] lastObject] isEqualToString:dalaneyKLiyeForFunc])
                    {
                        NSLog(@"Already Exists");
                        
                    }
                    else
                    {
                        NSLog(@"count is greater then or equal to 3");
                        [storeValuesForFunc setObject:[genArray objectAtIndex:i] forKey:tempstrForFunc];
                        
                        [listForKeysInCat removeAllObjects];
                        [listForKeysInCat addObjectsFromArray:[storeValuesForFunc allKeys]];
                        NSLog(@"description for key list %@", [listForKeysInCat description]);
                        NSLog(@"the store Vaue Description is %@", [storeValuesForFunc description]);
                        countForMatchForFunc =0;
                    }
                }
            }
            
            NSLog(@"the descrip is %@",[storeValuesForFunc description]);
            
            /////////////////////// Generic array se sarey elements in the dictionary ////////////////////////////
            
            // printing in a hashtable format
            
            NSLog(@"Key:                    Objects:");
            
            // storing the stuff
            [listForKeysInCat removeAllObjects];
            [listForKeysInCat addObjectsFromArray:[hashTableCatagories allKeys]]; //NSMutabkeArray
            
            for(int k=0; k< 2; k++)
            {
                storeKey = [listForKeysInCat objectAtIndex:k]; // NSString
                
                storeValuesForFunc = [hashTableCatagories objectForKey:storeKey]; // nsdictionary
                
                // adding keys
                [listForKeysInCat removeAllObjects];
                [listForKeysInCat addObjectsFromArray:[storeValuesForFunc allKeys]];
                
                NSString * tempStr = @"";
                
                NSLog(@"Catagory: %@", storeKey);
                
                for(int j =0; j< [listOfKeys count]; j++)
                {
                    tempStr = [listForKeysInCat objectAtIndex:j];
                    
                    storeElementsForCatagForFunc = [storeValuesForFunc objectForKey:tempStr]; // NSMutableArray
                    
                    if([storeElementsForCatagForFunc isKindOfClass:[NSString class]])
                    {
                  
                        printingStr = storeElementsForCatagForFunc;
                  
                    }
                    else
                    {
                        for(int i =0; i< [storeElementsForCatag count]; i++)
                        {
                            printingStr = [storeElementsForCatagForFunc objectAtIndex:i];
                           
                        }
                    }
                    
                  
                }
            }
            
            
            
            
        }
        else
        {
            
            NSLog(@"i am in else as this catagory is not there");
            countForCatagoryCheck++;
            
            NSLog(@"the count for catagory check is %d and the size of list is %D", countForCatagoryCheck, [listOfCataKeys count]);
            
            
        }
    }
    
    if(countForCatagoryCheck == [listOfCataKeys count])
    {
        NSLog(@"catagory cont i equal to size so it means that the catagory is not there");
        
        [keyListForCatagories addObjectsFromArray:[hashTableCatagories allKeys]];
        
        NSLog(@"the keyForListOFcatagories have %@", [keyListForCatagories description]);
        
        [keyListForCatagories addObject:catagoryKey];
        
        NSLog(@"after adding the catagory the list is %@", [keyListForCatagories description]);
        
        [hashTableCatagories setObject:emptyDictionary forKey:catagoryKey];
        [keyListForCatagories removeAllObjects];
        
        [self makingHashTableGenerically:genArray :catagoryKey];
    }
    
    NSLog(@"the count is %d", [hashTableCatagories count]);
    
}


- (IBAction)startGameButton:(UIBarButtonItem *)sender {
    
    NSLog(@"wait count %d", waitStartButtonPress);
    waitStartButtonPress++;
    _timerButton.title = [NSString stringWithFormat:@"%d%@%02d",1,@":", 00];
    
    
    if(waitStartButtonPress ==1)
    {
        NSLog(@"wait is 1 now kaam shuru karo");
        
        sender.title = @"Stop";
        
        _textFieldForWord.enabled = TRUE;
        _catagoryLabel.enabled = TRUE;
        _wordLetterLabel.enabled = TRUE;
        
        
        
        randomlyGeneratedNumber = [self randomCatagory];
        currMin =1;
        secondLft =00;
        
        /////////////////////////////////////////////////
        timeForGame = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countForGameRemTime) userInfo:nil repeats:YES];
        ///////////////////////////////////////////////////
        
        
        // calling print function
        [self printingTheCatagoryFunc:randomlyGeneratedNumber];
        
        // random generation for elements
      //  NSLog(@"%d", [elementArr count]);
        
        
        //////////////////////////////// temp stuff
        //  [self selectElements:randomlyGeneratedNumber];
        
        
    }
    if(waitStartButtonPress ==2)
    {
        sender.title = @"Start";
        _catagoryLabel.text = @"Category";
        _wordLetterLabel.text = @"Letter";
        _timerButton.title = [NSString stringWithFormat:@"%d%@%02d",1,@":", 00];
        _textFieldForWord.enabled = FALSE;
        _catagoryLabel.enabled = FALSE;
        _wordLetterLabel.enabled = FALSE;
        waitStartButtonPress =0;
        currMin =1;
        secondLft =00;
        [timeForGame invalidate];
        
        ViewForResultViewController * finalResultView = [[ViewForResultViewController alloc] initWithNibName:@"ViewForResultViewController" bundle:nil];
        finalResultView.title = @"The Letter Game";
        [self.navigationController pushViewController:finalResultView animated:YES];
        
        int scoreTemp = scoreVar;
        scoreVar=0;
        [finalResultView setStatus:0];
        [finalResultView dispOnTvChat:scoreTemp];
        
        //[finalResultView dispOnTvChat:@"khota hi hai"];
        
        
        
    }
}
- (IBAction)but:(id)sender {
    
   // [_butt setTitle:@"Pressed" forState:]
    //= @"pressed";
}
@end
