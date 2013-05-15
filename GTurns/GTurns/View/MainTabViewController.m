//
//  MainTabViewController.m
//  GTurns
//
//  Created by Matt Higgins on 5/15/13.
//  Copyright (c) 2013 Matt Higgins. All rights reserved.
//

#import "MainTabViewController.h"

@interface MainTabViewController ()

@property (strong) BTManager *btManager;

@end

@implementation MainTabViewController

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
    self.btManager = [BTManager sharedInstance];
	// Do any additional setup after loading the view.
}

- (IBAction)startButtonPressed:(id)sender
{
    NSLog(@"StartScanButtonPressed !");
    [self.btManager startScan];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
