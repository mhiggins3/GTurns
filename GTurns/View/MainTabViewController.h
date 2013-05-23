//
//  MainTabViewController.h
//  GTurns
//
//  Created by Matt Higgins on 5/15/13.
//  Copyright (c) 2013 Matt Higgins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTManager.h"
#import <CoreLocation/CoreLocation.h>
#import "CorePlot-CocoaTouch.h"

@interface MainTabViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, BTManagerDelegate, CPTPlotDataSource>

@property (strong) IBOutlet UILabel *xValueLable;
@property (strong) IBOutlet UILabel *yValueLable;
@property (strong) IBOutlet UILabel *zValueLable;
@property (strong) IBOutlet UILabel *speedValueLable;

-(void) didUpdateAccelerometerValues:(AccelerometerSensor *)accelerometer;

@end
