//
//  AccelerometerSensor.h
//  GTurns
//
//  Created by Matt Higgins on 5/16/13.
//  Copyright (c) 2013 Matt Higgins. All rights reserved.
//

#import <Foundation/Foundation.h>

extern float const ACCELEROMETER_MAX_VALUE;

@interface AccelerometerSensor : NSObject

@property (strong, readonly) NSData *currentData;
@property (strong, readonly) NSMutableArray *currentValues;

@property (readonly, getter = xValue) float xValue;
@property (readonly, getter = yValue) float yValue;
@property (readonly, getter = zValue) float zValue;

-(void)  updateCurrentData:(NSData *)data;

@end
