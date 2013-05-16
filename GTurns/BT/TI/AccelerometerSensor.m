//
//  AccelerometerSensor.m
//  GTurns
//
//  Created by Matt Higgins on 5/16/13.
//  Copyright (c) 2013 Matt Higgins. All rights reserved.
//

#import "AccelerometerSensor.h"
float const ACCELEROMETER_MAX_VALUE = 4.0;

@interface AccelerometerSensor ()
    @property (strong) NSMutableArray *currentValues;
    @property (strong) NSData *currentData;
@end


@implementation AccelerometerSensor

-(float) xValue
{
    return [self valueForIndex:0];
}

-(float) yValue
{
    return [self valueForIndex:1];
}

-(float) zValue
{
    return [self valueForIndex:2];
}

-(float) valueForIndex:(NSInteger) index {
    if(self.currentValues && self.currentValues.count){
        return [[self.currentValues objectAtIndex:index] floatValue];
    }
    return 0.0;
}

-(void) updateCurrentData:(NSData *) data
{
    char tmpValues[3];
    [data getBytes:&tmpValues length:3];
    [self.currentValues insertObject:[NSNumber numberWithFloat:((tmpValues[0] * 1.0) / (256 / ACCELEROMETER_MAX_VALUE))] atIndex:0];
    [self.currentValues insertObject:[NSNumber numberWithFloat:((tmpValues[1] * 1.0) / (256 / ACCELEROMETER_MAX_VALUE))] atIndex:1];
    [self.currentValues insertObject:[NSNumber numberWithFloat:((tmpValues[2] * 1.0) / (256 / ACCELEROMETER_MAX_VALUE))]atIndex:2];
}

- (id) init
{
    self = [super init];
    if (self) {
        self.currentData = [[NSData alloc]init];
        self.currentValues = [NSMutableArray arrayWithCapacity:3];
    }
    return self;
}

@end
