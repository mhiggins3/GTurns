//
//  MainTabViewController.m
//  GTurns
//
//  Created by Matt Higgins on 5/15/13.
//  Copyright (c) 2013 Matt Higgins. All rights reserved.
//

#import "MainTabViewController.h"

@interface MainTabViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, BTManagerDelegate>

@property (strong) BTManager *btManager;
@property (strong) CLLocationManager *locationManager;

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
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    // NSLog(@"Location manager status %@", [CLLocationManager authorizationStatus]);
    self.btManager = [BTManager sharedInstance];
    self.btManager.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.btManager = [BTManager sharedInstance];
    self.btManager.delegate = self;
}
#pragma mark - BTManagerDelegate
-(void)didUpdateAccelerometerValues:(AccelerometerSensor *)accelerometer
{
    self.xValueLable.text = [NSString stringWithFormat:@"%f", accelerometer.xValue];
    self.yValueLable.text = [NSString stringWithFormat:@"%f", accelerometer.yValue];
    self.zValueLable.text = [NSString stringWithFormat:@"%f", accelerometer.zValue];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations objectAtIndex:locations.count - 1];
    float mph = 0;
    if(currentLocation.speed > 0){
        mph = (currentLocation.speed / 100) * 0.621371192237334;
    }
    NSLog(@"Current speed: %f MPH", mph);
    self.speedValueLable.text = [NSString stringWithFormat:@"%.2f MPH", mph];
    
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"didChangeAuthorizationStatus: UNIMPLIMENTED");
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: UNIMPLIMENTED %@", error);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
