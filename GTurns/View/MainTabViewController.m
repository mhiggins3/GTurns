//
//  MainTabViewController.m
//  GTurns
//
//  Created by Matt Higgins on 5/15/13.
//  Copyright (c) 2013 Matt Higgins. All rights reserved.
//

#import "MainTabViewController.h"

@interface MainTabViewController () <CLLocationManagerDelegate, BTManagerDelegate>

@property (strong) BTManager *btManager;
@property (strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property float lastMph;

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
    self.btManager = [BTManager sharedInstance];
    self.btManager.delegate = self;
    self.lastMph = 0.0;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.maxValues = [[NSUserDefaults standardUserDefaults] objectForKey:@"maxValues"];
    if(!self.maxValues){
        self.maxValues = [[NSMutableDictionary alloc]init];
        [self clearMaxPerformaceData];
        [[NSUserDefaults standardUserDefaults] setObject:self.maxValues forKey:@"maxValues"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self updateMaxValues];

    
}
-(IBAction)clearDataButtonPressed:(id)sender
{
    [self clearMaxPerformaceData];

}
-(void)clearMaxPerformaceData
{
    [self.maxValues setObject:@"0.000" forKey:@"xValue"];
    [self.maxValues setObject:@"0.000" forKey:@"yValue"];
    [self.maxValues setObject:@"0.000" forKey:@"zValue"];
    [self.maxValues setObject:@"0.0" forKey:@"speedValue"];
}
-(void)updateMaxValues{
    self.xMaxValueLable.text = [self.maxValues objectForKey:@"xValue"];
    self.yMaxValueLable.text = [self.maxValues objectForKey:@"yValue"];
    self.zMaxValueLable.text = [self.maxValues objectForKey:@"zValue"];
    self.maxSpeedValueLable.text = [self.maxValues objectForKey:@"speedValue"];
    [[NSUserDefaults standardUserDefaults] setObject:self.maxValues forKey:@"maxValues"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void) updateMaxValuesFrom:(AccelerometerSensor *)accelerometer{
    if(self.maxValues){
        BOOL shouldUpdate = NO;
        if(accelerometer.xValue > [[self.maxValues objectForKey:@"xValue"] floatValue]){
            [self.maxValues setObject:[NSString stringWithFormat:@"%.3f", accelerometer.xValue] forKey:@"xValue"];
            shouldUpdate = YES;
        } else if(accelerometer.yValue > [[self.maxValues objectForKey:@"yValue"] floatValue]){
            [self.maxValues setObject:[NSString stringWithFormat:@"%.3f", accelerometer.yValue] forKey:@"yValue"];
            shouldUpdate = YES;
        } else if(accelerometer.zValue > [[self.maxValues objectForKey:@"zValue"] floatValue]){
            [self.maxValues setObject:[NSString stringWithFormat:@"%.3f", accelerometer.zValue] forKey:@"zValue"];
            shouldUpdate = YES;
        }
        if(shouldUpdate){
            [self updateMaxValues];
        }
    }
}
#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}
- (void)viewWillAppear:(BOOL)animated
{
    self.btManager = [BTManager sharedInstance];
    self.btManager.delegate = self;
}
#pragma mark - BTManagerDelegate
-(void)didUpdateAccelerometerValues:(AccelerometerSensor *)accelerometer
{
    self.xValueLable.text = [NSString stringWithFormat:@"%.3f", accelerometer.xValue];
    self.yValueLable.text = [NSString stringWithFormat:@"%.3f", accelerometer.yValue];
    self.zValueLable.text = [NSString stringWithFormat:@"%.3f", accelerometer.zValue];
    [self updateMaxValuesFrom:accelerometer];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations objectAtIndex:locations.count - 1];
    if(currentLocation.speed > 0){
        self.lastMph = (currentLocation.speed * 3.6)/ 1.609344;
        self.speedValueLable.textColor = [UIColor blackColor];
    } else {
        self.speedValueLable.textColor = [UIColor yellowColor];
    }
    self.speedValueLable.text = [NSString stringWithFormat:@"%.1f", self.lastMph];
    if(self.maxValues){
        if(self.lastMph > [[self.maxValues objectForKey:@"speedValue"] floatValue]){
            [self.maxValues setObject:[NSString stringWithFormat:@"%.1f", self.lastMph] forKey:@"speedValue"];
            [self updateMaxValues];
        }
    }
    
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"didChangeAuthorizationStatus: UNIMPLIMENTED");
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: UNIMPLIMENTED %@", error);
}

@end
