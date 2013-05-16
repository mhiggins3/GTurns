//
//  MainTabViewController.h
//  GTurns
//
//  Created by Matt Higgins on 5/15/13.
//  Copyright (c) 2013 Matt Higgins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTManager.h"

@interface MainTabViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, BTManagerDelegate>

@property (strong) IBOutlet UITableView *deviceListTableView;
@property (strong) IBOutlet UIButton *startButton;
@property (strong) IBOutlet UILabel *xValueLable;
@property (strong) IBOutlet UILabel *yValueLable;
@property (strong) IBOutlet UILabel *zValueLable;
-(IBAction)startButtonPressed:(id)sender;
-(void) didUpdateAccelerometerValues:(AccelerometerSensor *)accelerometer;

@end
