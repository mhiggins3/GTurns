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

@interface MainTabViewController : UIViewController <CLLocationManagerDelegate, BTManagerDelegate>

@property (strong) IBOutlet UILabel *xValueLable;
@property (strong) IBOutlet UILabel *yValueLable;
@property (strong) IBOutlet UILabel *zValueLable;
@property (strong) IBOutlet UILabel *speedValueLable;


@property (strong) IBOutlet UILabel *xMaxValueLable;
@property (strong) IBOutlet UILabel *yMaxValueLable;
@property (strong) IBOutlet UILabel *zMaxValueLable;
@property (strong) IBOutlet UILabel *maxSpeedValueLable;

@property (strong) NSMutableDictionary *maxValues;

-(void) didUpdateAccelerometerValues:(AccelerometerSensor *)accelerometer;
-(void) updateMaxValues;
-(IBAction)clearDataButtonPressed:(id)sender;
-(void) clearMaxPerformaceData;
-(void) updateMaxValuesFrom:(AccelerometerSensor *)accelerometer;

@end
