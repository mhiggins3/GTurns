//
//  GTurnsConst.h
//  GTurns
//
//  Created by Matt Higgins on 5/15/13.
//  Copyright (c) 2013 Matt Higgins. All rights reserved.
//

#import <Foundation/Foundation.h>

// Sensor Tag Const
extern NSString *const GATT_SERVICE_UUID_STRING;

// Accelerometer Const
extern NSString *const ACCELEROMETER_SERVICE_UUID_STRING;
extern NSString *const ACCELEROMETER_CHARACTERISTIC_CONFIG_STRING;
extern NSString *const ACCELEROMETER_CHARACTERISTIC_PERIOD_STRING;
extern NSString *const ACCELEROMETER_CHARACTERISTIC_DATA_STRING;

// User Defaults Keys
extern NSString *const MANAGED_PERIPHERALS_KEY;

@interface GTurnsConst : NSObject

@end
