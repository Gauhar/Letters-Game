//
//  AppDelegate.h
//  beatMeIfYouCan
//
//  Created by Gauhar Shakeel on 2013-09-03.
//  Copyright (c) 2013 Gauhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelcomeViewController.h"
#import "MCManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIViewController * viewController;
   
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MCManager * mcManager;


@end
