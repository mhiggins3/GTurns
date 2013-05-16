//
//  MainTabViewController.m
//  GTurns
//
//  Created by Matt Higgins on 5/15/13.
//  Copyright (c) 2013 Matt Higgins. All rights reserved.
//

#import "MainTabViewController.h"

@interface MainTabViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong) BTManager *btManager;

@end

@implementation MainTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.btManager = [BTManager sharedInstance];
    self.btManager.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.btManager = [BTManager sharedInstance];
    self.btManager.delegate = self;
}

-(void)didUpdateAccelerometerValues:(AccelerometerSensor *)accelerometer
{
    self.xValueLable.text = [NSString stringWithFormat:@"%f", accelerometer.xValue];
    self.yValueLable.text = [NSString stringWithFormat:@"%f", accelerometer.yValue];
    self.zValueLable.text = [NSString stringWithFormat:@"%f", accelerometer.zValue];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
