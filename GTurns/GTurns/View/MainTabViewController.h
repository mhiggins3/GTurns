//
//  MainTabViewController.h
//  GTurns
//
//  Created by Matt Higgins on 5/15/13.
//  Copyright (c) 2013 Matt Higgins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTManager.h"

@interface MainTabViewController : UIViewController

@property (strong) IBOutlet UIButton *startButton;
-(IBAction)startButtonPressed:(id)sender;

@end
