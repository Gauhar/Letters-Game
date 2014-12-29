//
//  Parser_Game.m
//  beatMeIfYouCan
//
//  Created by Gauhar Shakeel on 2/18/2014.
//  Copyright (c) 2014 Gauhar. All rights reserved.
//

#import "Parser_Game.h"

@implementation Parser_Game

-init
{
    if(self == [super init]) {
        //    NSLog(@"init mei aaya and self is equal to super init");
        parser = [[NSXMLParser alloc]
                  initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                                pathForResource:@"wordsListData2" ofType: @"xml"]]];
        
        count =0;
        /////////////////// making the generic array from the xml ///////////////
        genericNewArray =  [[NSMutableArray alloc] init];
        checkCatagory = [[NSString alloc] init]; // this will check for the catagory generically
        ///////////////////////////////////////////////////////////////////////////
        
        
        //////////////
        country = [[NSString alloc] init];
        food = [[NSString alloc] init];
        
        countryArray = [[NSMutableArray alloc] init];
        foodArray = [[NSMutableArray alloc] init];
        //////////////
        
        
        [parser setDelegate:self];
        [parser parse];
        
        /////////// temp
        checkingTemp = 1;
        i =0;
        ////////////////
        
        // innitializing the numberofcatagoriesinxml
        numOfCatagoriesInXML = [[NSMutableArray alloc] init];
        
        ////////////////////////////////////////////////////
        countForCata =0;
        
        // catagory
        
        
        
        
        
        
    }
    return self;
}


-(void) parser: (NSXMLParser *) parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"Started Element %@", elementName);
    
    if([elementName isEqualToString:@"catagory"])
    {
        count ++;
        // NSLog(@"count is %d     or qualified name %@", count, [attributeDict objectForKey:@"name"]);
        
        //  NSLog(@"%@",[[attributeDict objectForKey:@"name"] class]);
        if(count == 1)
        {
            ///////////// setting catagory
            checkCatagory = [attributeDict objectForKey:@"name"];
            
            NSLog(@"checkCatagory hai? %@", checkCatagory);
            ////////////////////////////
            
            //  NSLog(@"count is %d", count);
            //count = 0;
        }
    }
    
    element = [NSMutableString string]; // this is nothing here
    
    
    
    tempData = [NSMutableString string];
    // countryArray = [[NSMutableArray alloc] init];
    //foodArray = [[NSMutableArray alloc] init];
    NSLog(@"mutableString %@ ye tha.", element);
    
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"element mei kya aaya hai %@", element);
    
    if(count ==1 && [elementName isEqualToString:@"catagory"])
    {
        NSLog(@"end hua hai yaha catagory and count yaha hai %d", count);
        count = 0;
        
        /*NSLog(@"///////////////////////////////////// the genric from xml ///////////////");
         [controller makingHashTableGenerically:genericNewArray :checkCatagory];
         
         
         NSLog(@"the hashTable is %@", [[controller getHashTable] description]);*/
        
        // countingTheElements = [NSNumber numberWithInt:[genericNewArray count]];
        
        
        
        NSLog(@"the generic array is %@",[genericNewArray description]);
        
        
        
        if([checkCatagory isEqualToString:@"Country"])
        {
            NSLog(@"%@",checkCatagory);
            for(int k=0;k<[genericNewArray count];k++)
            {
                [tempData  appendString:(NSString *)[genericNewArray objectAtIndex:k]];
                
                [countryArray addObject:tempData];
                tempData = [NSMutableString stringWithString:@""];
                // NSLog(@"%@", [countryArray objectAtIndex:k]);
                
                
            }
            country = checkCatagory;
            NSLog(@"the value of country var is and the checkCata is %@ %@", country, checkCatagory);
            NSLog(@"the coutry array is  %@", [countryArray description]);
            countForCata++;
        }
        
        /* if([checkCatagory isEqualToString:@"Food"])
         {
         for(int k=0;k<[genericNewArray count];k++)
         {
         [foodArray addObject:[genericNewArray objectAtIndex:k]];
         //food = checkCatagory;
         }
         food = checkCatagory;
         NSLog(@"the value of fooddddd var is and the checkCata is %@ %@", food, checkCatagory);
         countForCata++;
         }
         */
        // [genericNewArray removeAllObjects];
        i=0;
        count =0;
        
        
        NSLog(@"/////////////////////// cota %@",[foodArray description]);
        
        NSLog(@"////////////////////////// countOfCota  %d",countForCata);
        
        NSLog(@"////////////////////////////////////////////////////////////////////////////////////");
        
        
        
        ////////// adding the result in
    }
    
    // NSLog(@"Found an element named: %@ with a value of: %@", elementName, element);
}
int l =0;
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(element == nil)
        element = [[NSMutableString alloc] init];
    //if([string isEqualToString:@" " ])
    //{
    checkingTemp++;
    
    [element appendString:string];
    if(checkingTemp >= 6 && count ==1 )
    {
        
        //////////// storing the catagory as well as that catagoey's elements.
        //checkCatagory = [attributeDict objectForKey:@"name"];
        
        //NSLog(@"checkCatagory hai? %@", checkCatagory);
        if(i==0)
        {
            NSLog(@"character is found and first object is being added");
            [genericNewArray addObject:element];
            //NSLog(@"pehla element and count is %d", [genericNewArray count]);
            i++;
            //countingTheElements++;
            
        }
        else
        {
            
            i=i-1;
            //  NSLog(@" this value of object at 0 is %@", [genericNewArray objectAtIndex:i]);
            if([[genericNewArray objectAtIndex:i] isEqualToString:element])
            {
                //[genericNewArray addObject:element];
                //  NSLog(@"generic array mei object hai %@ and element is %@", [genericNewArray objectAtIndex:i], element);
                i = [genericNewArray count];
                
                
            }
            else
            {
                //NSLog(@"element to add is %@", element);
                [genericNewArray addObject:element];
                i = [genericNewArray count];
                //NSLog(@"i ki val hai %d",i);
                //countingTheElements++;
                
            }
        }
    }
    /////////////////////////////////////////////////////////////////
    // NSLog(@"string hai %@  and element hai %@ and count is %d", string, element, checkingTemp);
    
    
}

-(NSMutableArray*) getGenArray
{
    return genericNewArray;
}

-(NSString *) getCheckCata
{
    return checkCatagory;
}

-(NSMutableArray *) getCountry
{
    return countryArray;
}

-(NSMutableArray *) getFood
{
    return foodArray;
}

-(int) getCount
{
    return countForCata;
}

-(NSString *) getCountryCat
{
    return country;
}

-(NSString *) getFoodCata
{
    return  food;
}


@end
