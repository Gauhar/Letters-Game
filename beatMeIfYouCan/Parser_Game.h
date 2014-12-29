//
//  Parser_Game.h
//  beatMeIfYouCan
//
//  Created by Gauhar Shakeel on 2/18/2014.
//  Copyright (c) 2014 Gauhar. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MainViewController.h"


@interface Parser_Game : NSObject <NSXMLParserDelegate>
{
    NSXMLParser * parser;
    NSMutableString * element;
    int count;
    NSMutableArray * genericNewArray;
    NSString * checkCatagory;
    int checkingTemp;
    int i;
    
    // keeping track for making the hash table
    NSMutableArray * numOfCatagoriesInXML;
    NSNumber * countingTheElements;
    
    
    // catagoryClass
    
    NSMutableArray * countryArray;
    NSMutableArray * foodArray;
    
    NSMutableString * tempData;
    
    NSString * country;
    NSString * food;
    int countForCata; // counts the number of catagories in the xml
    
    
    
    
}

-(NSMutableArray *) getGenArray;
-(NSString *) getCheckCata;

-(NSMutableArray *) getCountry;
-(NSMutableArray *) getFood;
-(int) getCount;

-(NSString *) getCountryCat;

-(NSString *) getFoodCata;



@end
